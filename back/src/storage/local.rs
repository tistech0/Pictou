use std::{
    io,
    path::{Path, PathBuf},
    pin::Pin,
};

use async_trait::async_trait;
use tokio::{
    fs::File,
    io::{AsyncRead, AsyncWrite},
};

use super::{ImageHash, ImageStorage, StoredImageKind};

/// Local file-based implementation of [`ImageStorage`].
/// Mounts the storage at the given root directory.
///
/// Files are hashed by their MD5 hash and stored in a directory structure like this:
/// ```text
/// root/
/// ├── AAAA/
/// │   ├── BBBB/
/// │   │   ├── CCCC/
/// │   │   │   ├── DDDD/
/// │   │   │   │   ├── original
/// │   │   │   │   └── compressed.jxl
/// │   │   │   ├── EEEE/
/// │   │   │   │   ├── original
/// │   │   │   │   └── compressed.jxl
/// ```
///
/// Where the MD5 hash of the first image is `0xAAAABBBBCCCCDDDD` and the second is `0xAAAABBBBCCCCEEEE`.
#[derive(Debug)]
pub struct LocalImageStorage {
    root: PathBuf,
}

impl LocalImageStorage {
    pub fn new(root: impl AsRef<Path>) -> Self {
        LocalImageStorage {
            root: root.as_ref().to_path_buf(),
        }
    }

    fn make_path(&self, hash: ImageHash, kind: StoredImageKind) -> PathBuf {
        let mut path = self.root.clone();
        let md5 = hash.to_md5_bytes();

        // According to https://stackoverflow.com/questions/466521/how-many-files-can-i-put-in-a-directory
        // 2^16 files per directory should be fine
        for i in (0..16).step_by(2) {
            path.push(format!("{:02x}{:02x}", md5[i], md5[i + 1]));
        }

        match kind {
            StoredImageKind::Original => path.push("original"),
            StoredImageKind::CompressedJpegXl => path.push("compressed.jxl"),
        }

        path
    }
}

#[async_trait]
impl ImageStorage for LocalImageStorage {
    async fn load(
        &self,
        hash: ImageHash,
        kind: StoredImageKind,
    ) -> io::Result<Pin<Box<dyn AsyncRead>>> {
        let file = File::open(self.make_path(hash, kind)).await?;
        Ok(Box::pin(file))
    }

    async fn store(
        &self,
        hash: ImageHash,
        kind: StoredImageKind,
    ) -> io::Result<Pin<Box<dyn AsyncWrite>>> {
        let path = self.make_path(hash, kind);

        // create parent directories if they don't exist
        tokio::fs::create_dir_all(path.parent().expect("make_path() is broken!")).await?;

        let file = File::create(path).await?;
        Ok(Box::pin(file))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    use tokio::io::{AsyncReadExt, AsyncWriteExt};
    use tracing_test::traced_test;

    #[traced_test]
    #[actix_rt::test]
    async fn test_store_load_original() {
        let root = tempfile::tempdir().expect("failed to create tempdir");
        let storage = LocalImageStorage::new(&root);

        let hash = ImageHash::from_md5_bytes(0x112233445566778899aabbccddeeffu128.to_be_bytes());

        let mut to_store = storage
            .store(hash, StoredImageKind::Original)
            .await
            .unwrap();
        to_store
            .write_all(b"this is the original image")
            .await
            .unwrap();
        drop(to_store); // release the lock

        let expected_path = root
            .path()
            .join("0011/2233/4455/6677/8899/aabb/ccdd/eeff/original");

        assert!(tokio::fs::metadata(&expected_path).await.unwrap().is_file());
        assert_eq!(
            tokio::fs::read(expected_path).await.unwrap(),
            b"this is the original image"
        );

        let mut to_load = storage.load(hash, StoredImageKind::Original).await.unwrap();
        let mut buf = Vec::new();
        to_load.read_to_end(&mut buf).await.unwrap();
        assert_eq!(buf, b"this is the original image");

        // loading the wrong kind should fail
        assert!(storage
            .load(hash, StoredImageKind::CompressedJpegXl)
            .await
            .is_err());
    }

    #[traced_test]
    #[actix_rt::test]
    async fn test_store_load_jxl() {
        let root = tempfile::tempdir().expect("failed to create tempdir");
        let storage = LocalImageStorage::new(&root);

        let hash = ImageHash::from_md5_bytes(0x112233445566778899aabbccddeeffu128.to_be_bytes());

        let mut to_store = storage
            .store(hash, StoredImageKind::CompressedJpegXl)
            .await
            .unwrap();
        to_store.write_all(b"this is the JXL image").await.unwrap();
        drop(to_store); // release the lock

        let expected_path = root
            .path()
            .join("0011/2233/4455/6677/8899/aabb/ccdd/eeff/compressed.jxl");

        assert!(tokio::fs::metadata(&expected_path).await.unwrap().is_file());
        assert_eq!(
            tokio::fs::read(expected_path).await.unwrap(),
            b"this is the JXL image"
        );

        let mut to_load = storage
            .load(hash, StoredImageKind::CompressedJpegXl)
            .await
            .unwrap();
        let mut buf = Vec::new();
        to_load.read_to_end(&mut buf).await.unwrap();
        assert_eq!(buf, b"this is the JXL image");

        // loading the wrong kind should fail
        assert!(storage.load(hash, StoredImageKind::Original).await.is_err());
    }
}
