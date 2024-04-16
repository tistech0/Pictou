use std::{
    io::{self, Cursor},
    pin::Pin,
};

use crate::{
    image::{self, DecodedImage, ImageType},
    storage::{ImageHash, ImageStorage, StoredImageKind},
};
use actix_web::web;
use image_backend::{codecs::jpeg::JpegEncoder, ExtendedColorType, ImageBuffer, LumaA, Rgba};
use tokio::io::{AsyncRead, AsyncWriteExt, BufReader};
use tracing::{debug, Level};

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
    let decoded: DecodedImage = image::decode(
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

    debug!(%hash, size, "Request thumbnail");

    // Try to load from storage and return if success
    let result = storage.load(hash, image_kind).await;
    if result.is_ok() {
        return result;
    }

    // Otherwise resize the image, store it and return it
    create_thumbnail(storage.as_ref(), hash, size).await?;
    storage.load(hash, image_kind).await
}
