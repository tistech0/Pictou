#![allow(dead_code, unused_imports)] // FIXME: remove this once the module is used!

use std::{
    fmt::{self, Display},
    io::{self, Write},
    pin::Pin,
};

use async_trait::async_trait;
use diesel::{
    deserialize::{FromSql, FromSqlRow},
    expression::AsExpression,
    serialize::ToSql,
    sql_types,
};
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
pub trait ImageStorage: Send + Sync {
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
#[derive(Debug, Clone, Copy, PartialEq, Eq, FromSqlRow, AsExpression)]
#[diesel(sql_type = sql_types::Binary)]
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

impl Display for ImageHash {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        for byte in &self.md5 {
            write!(f, "{:02x}", byte)?;
        }
        Ok(())
    }
}

/// Allows direct deserialization from SQL.
impl FromSql<sql_types::Binary, diesel::pg::Pg> for ImageHash {
    fn from_sql(value: diesel::pg::PgValue<'_>) -> diesel::deserialize::Result<Self> {
        let bytes = value.as_bytes();
        let md5_bytes: [u8; 16] = bytes.try_into().map_err(|_| {
            format!(
                "Invalid length for ImageHash, expected 16 bytes, got {}",
                bytes.len()
            )
        })?;
        Ok(ImageHash::from_md5_bytes(md5_bytes))
    }
}

/// Allows direct serialization to SQL.
impl ToSql<sql_types::Binary, diesel::pg::Pg> for ImageHash {
    fn to_sql<'b>(
        &'b self,
        out: &mut diesel::serialize::Output<'b, '_, diesel::pg::Pg>,
    ) -> diesel::serialize::Result {
        out.write_all(&self.md5[..])
            .map(|_| diesel::serialize::IsNull::No)
            .map_err(Into::into)
    }
}
