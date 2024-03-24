//! Restricted wrapper over the `image` crate that supports the JXL format.

use std::{
    fmt::{self, Display},
    io::Cursor,
    pin::Pin,
};

use image_backend::{
    codecs::{gif::GifDecoder, jpeg::JpegDecoder, png::PngDecoder},
    DynamicImage,
};
use md5::{Digest, Md5};
use tokio::io::{AsyncRead, AsyncReadExt};

use crate::storage::ImageHash;

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
        let decoder = new_decoder(image_type, &original_bytes)?;
        let inner = DynamicImage::from_decoder(decoder)?;

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
