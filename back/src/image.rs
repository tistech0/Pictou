//! Image encoding and decoding utilities.

use std::{
    fmt::{self, Display},
    io,
    pin::Pin,
};

use tokio::io::{AsyncRead, AsyncReadExt};

use crate::storage::ImageHash;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ImageType {
    Jpeg,
    Png,
    Jxl,
}

impl ImageType {
    pub const ALL: &'static [Self] = &[Self::Jpeg, Self::Png, Self::Jxl];

    pub fn from_mime(mime: impl AsRef<str>) -> Option<Self> {
        match mime.as_ref() {
            "image/jpeg" => Some(Self::Jpeg),
            "image/png" => Some(Self::Png),
            "image/jxl" => Some(Self::Jxl),
            _ => None,
        }
    }

    pub const fn as_mime(self) -> &'static str {
        match self {
            Self::Jpeg => "image/jpeg",
            Self::Png => "image/png",
            Self::Jxl => "image/jxl",
        }
    }
}

impl Display for ImageType {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            ImageType::Jpeg => write!(f, "JPEG"),
            ImageType::Png => write!(f, "PNG"),
            ImageType::Jxl => write!(f, "JPEG XL"),
        }
    }
}

pub struct DecodedImage {
    pub hash: ImageHash,
    pub image_type: ImageType,
    pub size: usize,
    pub width: usize,
    pub height: usize,
    pub bytes: Box<[u8]>,
}

pub async fn decode_image<R>(image_type: ImageType, data: Pin<&mut R>) -> io::Result<DecodedImage>
where
    R: AsyncRead + ?Sized,
{
    match image_type {
        ImageType::Jpeg => decode_jpeg(data).await,
        ImageType::Png => decode_png(data).await,
        ImageType::Jxl => decode_jxl(data).await,
    }
}

async fn decode_jpeg<R>(mut data: Pin<&mut R>) -> io::Result<DecodedImage>
where
    R: AsyncRead + ?Sized,
{
    // FIXME: placeholder image
    let mut bytes = Vec::with_capacity(248503);

    data.read_to_end(&mut bytes).await?;
    Ok(DecodedImage {
        image_type: ImageType::Jpeg,
        size: 248503,
        width: 1600,
        height: 1066,
        hash: ImageHash::from_md5_bytes(0x59E665E8E34678F2D6307C3FF4007620u128.to_be_bytes()),
        bytes: bytes.into_boxed_slice(),
    })
}

async fn decode_png<R>(_data: Pin<&mut R>) -> io::Result<DecodedImage>
where
    R: AsyncRead + ?Sized,
{
    todo!()
}

async fn decode_jxl<R>(_data: Pin<&mut R>) -> io::Result<DecodedImage>
where
    R: AsyncRead + ?Sized,
{
    todo!("see GH issue #79")
}
