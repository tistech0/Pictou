//! Restricted wrapper over the `image` crate that supports the JXL format.

use std::{
    fmt::{self, Display},
    io::{self, Cursor},
    pin::Pin,
};

use actix_web::web;
use image_backend::{
    codecs::{
        gif::GifDecoder,
        jpeg::{JpegDecoder, JpegEncoder},
        png::PngDecoder,
    },
    DynamicImage, ExtendedColorType, ImageBuffer, LumaA, Rgba,
};
use jpegxl_rs::{
    decode::decoder_builder,
    encode::{encoder_builder, EncoderFrame, EncoderSpeed},
    EncodeError,
};
use jpegxl_rs::{encode::EncoderResult, image::ToDynamic};
use md5::{Digest, Md5};
use tokio::io::{AsyncRead, AsyncReadExt, AsyncWriteExt, BufReader};
use tracing::Level;

use crate::storage::{ImageHash, ImageStorage, StoredImageKind};

use self::jxl::JxlDecoder;

mod jxl;

pub async fn decode<R>(
    image_type: ImageType,
    mut data: Pin<&mut R>,
    size_hint: usize,
) -> anyhow::Result<DecodedImage>
where
    R: AsyncRead + ?Sized,
{
    let mut original_bytes = Vec::with_capacity(size_hint);
    data.read_to_end(&mut original_bytes).await?;

    tokio::task::spawn_blocking(move || {
        let hash = digest_image(&original_bytes);
        let inner: DynamicImage = match image_type {
            ImageType::Jxl => {
                let decoder = decoder_builder().build()?;
                decoder
                    .decode_to_image(&original_bytes)?
                    .ok_or_else(|| anyhow::anyhow!("JXL image is not representable"))?
            }
            _ => {
                let decoder = new_decoder(image_type, &original_bytes)?;
                DynamicImage::from_decoder(decoder)?
            }
        };

        Ok(DecodedImage {
            inner,
            hash,
            original_bytes,
        })
    })
    .await?
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ImageType {
    Jpeg,
    Png,
    Gif,
    Jxl,
}

impl ImageType {
    pub const ALL: &'static [Self] = &[Self::Jpeg, Self::Png, Self::Gif, Self::Jxl];

    pub fn from_mime(mime: impl AsRef<str>) -> Option<Self> {
        match mime.as_ref() {
            "image/jpeg" => Some(Self::Jpeg),
            "image/jpg" => Some(Self::Jpeg),
            "image/png" => Some(Self::Png),
            "image/gif" => Some(Self::Gif),
            "image/jxl" => Some(Self::Jxl),
            _ => None,
        }
    }

    pub const fn as_mime(self) -> &'static str {
        match self {
            Self::Jpeg => "image/jpeg",
            Self::Png => "image/png",
            Self::Gif => "image/gif",
            Self::Jxl => "image/jxl",
        }
    }
}

impl Display for ImageType {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            ImageType::Jpeg => write!(f, "JPEG"),
            ImageType::Png => write!(f, "PNG"),
            ImageType::Gif => write!(f, "GIF"),
            ImageType::Jxl => write!(f, "JPEG XL"),
        }
    }
}

pub struct DecodedImage {
    inner: DynamicImage,
    hash: ImageHash,
    original_bytes: Vec<u8>,
}

impl DecodedImage {
    pub fn compress_jxl(&self) -> Result<EncoderResult<u8>, EncodeError> {
        let mut encoder = encoder_builder()
            .lossless(false)
            .speed(EncoderSpeed::Lightning)
            .quality(1.0)
            .has_alpha(self.inner.color().has_alpha())
            .use_container(false)
            .init_buffer_size(self.size() as usize)
            .build()?;
        let frame = EncoderFrame::new(self.inner.as_bytes())
            .num_channels(3 + self.inner.color().has_alpha() as u32);

        encoder.encode_frame(&frame, self.inner.width(), self.inner.height())
    }

    pub fn size(&self) -> i64 {
        self.original_bytes
            .len()
            .try_into()
            .expect("image size overflowed i64")
    }

    pub fn width(&self) -> i64 {
        self.inner.width() as i64
    }

    pub fn height(&self) -> i64 {
        self.inner.height() as i64
    }

    pub fn hash(&self) -> ImageHash {
        self.hash
    }

    /// The raw image file as it was uploaded
    pub fn original_bytes(&self) -> &[u8] {
        &self.original_bytes
    }

    fn crop_to_square(&self) -> DynamicImage {
        let (width, height) = (self.inner.width(), self.inner.height());

        // Calculate the size of the square
        let size = width.min(height);

        // Calculate the coordinates for cropping
        let left = (width - size) / 2;
        let top = (height - size) / 2;

        // Crop the image to a square
        self.inner.crop_imm(left, top, size, size)
    }

    pub fn square_thumbnail(self, size: u32) -> DynamicImage {
        let cropped = self.crop_to_square();
        cropped.thumbnail_exact(size, size)
    }
}

/// **BLOCKING**: call in async with caution!
fn digest_image(bytes: &[u8]) -> ImageHash {
    ImageHash::from_md5_bytes(Md5::digest(bytes).into())
}

/// **BLOCKING**: call in async with caution!
fn new_decoder<'a>(
    image_type: ImageType,
    bytes: &'a [u8],
) -> anyhow::Result<Box<dyn image_backend::ImageDecoder + Send + 'a>> {
    let reader = Cursor::new(bytes);
    Ok(match image_type {
        ImageType::Jpeg => Box::new(JpegDecoder::new(reader)?),
        ImageType::Png => Box::new(PngDecoder::new(reader)?),
        ImageType::Gif => Box::new(GifDecoder::new(reader)?),
        ImageType::Jxl => Box::new(JxlDecoder::new(reader)?),
    })
}

#[tracing::instrument(skip(storage), level = Level::DEBUG)]
async fn create_thumbnail(
    storage: &dyn ImageStorage,
    hash: ImageHash,
    size: u32,
) -> io::Result<()> {
    let stored_kind = StoredImageKind::JpegThumbnail(size);
    // Load the compressed image (not original for less data transfer)
    let image_source = storage
        .load(hash, StoredImageKind::CompressedJpegXl)
        .await?;

    // Decode the jxl image
    let mut input = BufReader::new(image_source);
    let decoded: DecodedImage = decode(
        ImageType::Jxl,
        Pin::new(&mut input),
        (size * size * 4) as usize,
    )
    .await
    .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))?;
    drop(input);

    // Resize the image to the requested thumbnail size
    let thumbnail = decoded.square_thumbnail(size);

    // Encode the image as a jpeg thumbnail
    let bytes = thumbnail.as_bytes();
    let mut buf = Cursor::new(Vec::with_capacity(bytes.len()));
    let mut encoder = JpegEncoder::new(&mut buf);

    // Can't use encode because of the incredible idea of the image-rs developper to forbid "silent" alpha channel removal
    // (like you don't know encoding something in jpeg will remove the alpha channel, but no, you have to specify it explicitly)
    // https://github.com/image-rs/image/commit/c193acbf7b745b071f5617e269f0955ee97c25d3
    match thumbnail.color().into() {
        ExtendedColorType::Rgb8 | ExtendedColorType::L8 => encoder.encode(
            bytes,
            thumbnail.width(),
            thumbnail.height(),
            thumbnail.color().into(),
        ),
        ExtendedColorType::La8 => {
            let image: ImageBuffer<LumaA<_>, _> =
                ImageBuffer::from_raw(thumbnail.width(), thumbnail.height(), bytes).unwrap();
            encoder.encode_image(&image)
        }
        ExtendedColorType::Rgba8 => {
            let image: ImageBuffer<Rgba<_>, _> =
                ImageBuffer::from_raw(thumbnail.width(), thumbnail.height(), bytes).unwrap();
            encoder.encode_image(&image)
        }
        _ => {
            return Err(io::Error::new(
                io::ErrorKind::InvalidData,
                "Unsupported color type",
            ));
        }
    }
    .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))?;

    // Store the thumbnail in the storage
    let mut compressed_output = storage.store(hash, stored_kind).await?;
    buf.set_position(0);
    compressed_output.write_all_buf(&mut buf).await
}

#[tracing::instrument(skip(storage), level = Level::DEBUG)]
pub async fn load_thumbnail(
    storage: web::Data<dyn ImageStorage>,
    hash: ImageHash,
    size: u32,
) -> io::Result<Pin<Box<dyn AsyncRead>>> {
    // Round up image size to multiple of 64
    let size = size.next_multiple_of(64);
    let image_kind = StoredImageKind::JpegThumbnail(size);

    // Try to load from storage and return if success
    let result = storage.load(hash, image_kind).await;
    if result.is_ok() {
        return result;
    }

    // Otherwise resize the image, store it and return it
    create_thumbnail(storage.as_ref(), hash, size).await?;
    storage.load(hash, image_kind).await
}
