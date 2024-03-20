#![allow(dead_code, unused_imports)] // FIXME: remove this once the module is used!

use std::{io, pin::Pin};

use async_trait::async_trait;
use tokio::io::{AsyncRead, AsyncWrite};

mod local;

pub use local::LocalImageStorage;

/// Provides an interface for storing and loading images.
///
/// See the [`LocalImageStorage`] implementation for a local file-based storage.
///
/// Load operations are expected to be concurrent, while store operations (on the same image)
/// are expected to be mutually exclusive.
#[async_trait]
pub trait ImageStorage {
    /// Opens the original image with the given hash and kind for reading.
    async fn load(
        &self,
        hash: ImageHash,
        kind: StoredImageKind,
    ) -> io::Result<Pin<Box<dyn AsyncRead>>>;

    /// Opens the original image with the given hash and kind for writing.
    ///
    /// This function is *not* responsible for compressing and/or converting the image.
    async fn store(
        &self,
        hash: ImageHash,
        kind: StoredImageKind,
    ) -> io::Result<Pin<Box<dyn AsyncWrite>>>;
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum StoredImageKind {
    Original,
    CompressedJpegXl,
}

#[repr(transparent)]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ImageHash {
    md5: [u8; 16],
}

impl ImageHash {
    pub const fn from_md5_bytes(md5: [u8; 16]) -> Self {
        ImageHash { md5 }
    }

    pub const fn to_md5_bytes(self) -> [u8; 16] {
        self.md5
    }
}
