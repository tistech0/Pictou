use std::{
    collections::HashMap,
    io,
    path::{Path, PathBuf},
    pin::Pin,
    sync::{Arc, Weak},
    task::{Context, Poll},
};

use async_trait::async_trait;
use pin_project::pin_project;
use tokio::{
    fs::File,
    io::{AsyncRead, AsyncWrite, ReadBuf},
    sync::{
        Mutex, MutexGuard, OnceCell, OwnedMutexGuard, OwnedRwLockReadGuard, OwnedRwLockWriteGuard,
        RwLock, RwLockReadGuard,
    },
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
        let path = self.make_path(hash, kind);
        let guard = acquire_file_read_lock(&path).await;
        let file = File::open(path).await?;

        Ok(Box::pin(ReadGuard {
            reader: file,
            read_guard: guard,
        }))
    }

    async fn store(
        &self,
        hash: ImageHash,
        kind: StoredImageKind,
    ) -> io::Result<Pin<Box<dyn AsyncWrite>>> {
        let path = self.make_path(hash, kind);
        let guard = acquire_file_write_lock(&path).await;

        // create parent directories if they don't exist
        tokio::fs::create_dir_all(path.parent().expect("make_path() is broken!")).await?;
        let file = File::create(path).await?;

        Ok(Box::pin(WriteGuard {
            writer: file,
            write_guard: guard,
        }))
    }
}

/// Provides a file from being written to while this guard is held.
#[pin_project]
struct ReadGuard<R> {
    #[pin]
    reader: R,
    read_guard: OwnedRwLockReadGuard<()>,
}

impl<R: AsyncRead> AsyncRead for ReadGuard<R> {
    fn poll_read(
        self: Pin<&mut Self>,
        cx: &mut Context,
        buf: &mut ReadBuf,
    ) -> Poll<io::Result<()>> {
        self.project().reader.poll_read(cx, buf)
    }
}

#[pin_project]
struct WriteGuard<W> {
    #[pin]
    writer: W,
    write_guard: OwnedRwLockWriteGuard<()>,
}

impl<W: AsyncWrite> AsyncWrite for WriteGuard<W> {
    fn poll_write(self: Pin<&mut Self>, cx: &mut Context, buf: &[u8]) -> Poll<io::Result<usize>> {
        self.project().writer.poll_write(cx, buf)
    }

    fn poll_flush(self: Pin<&mut Self>, cx: &mut Context) -> Poll<io::Result<()>> {
        self.project().writer.poll_flush(cx)
    }

    fn poll_shutdown(self: Pin<&mut Self>, cx: &mut Context) -> Poll<io::Result<()>> {
        self.project().writer.poll_shutdown(cx)
    }
}

/// Exercise: make this type somehow longer than this:
///
/// - The outer Mutex prevents multiple access the the HashMap
/// - The HashMap maps a file path to its coresponding lock.
/// - The Weak reference is used to count the number of active guards to a lock.
/// - The RwLocks do the actual locking, they don't hold any data since FS is global by nature.
type FileLocks = Arc<Mutex<HashMap<PathBuf, Weak<RwLock<()>>>>>;

/// Prevents multiple instances of the same file from being opened for reading and writing at the
/// same time using RwLocks. This only enfoces intra-process locking, not inter-process locking.
async fn get_file_locks() -> FileLocks {
    static INSTANCE: OnceCell<FileLocks> = OnceCell::const_new();

    INSTANCE
        .get_or_init(|| async { Default::default() })
        .await
        .clone()
}

async fn get_file_lock(path: &Path) -> Arc<RwLock<()>> {
    let mut inner_locks: OwnedMutexGuard<_> = get_file_locks().await.lock_owned().await;

    // re-use existing lock if possible by upgrading the weak reference
    // or create a new lock if it doesn't exist
    let file_lock = match inner_locks.get(path).and_then(|weak| weak.upgrade()) {
        Some(lock) => lock,
        None => {
            let lock = Arc::new(RwLock::new(()));
            inner_locks.insert(path.to_path_buf(), Arc::downgrade(&lock));
            lock
        }
    };

    // cleanup unused weak references
    inner_locks.retain(|_, weak| weak.strong_count() > 0);

    file_lock
}

async fn acquire_file_read_lock(path: &Path) -> OwnedRwLockReadGuard<()> {
    get_file_lock(path).await.read_owned().await
}

async fn acquire_file_write_lock(path: &Path) -> OwnedRwLockWriteGuard<()> {
    get_file_lock(path).await.write_owned().await
}

#[cfg(test)]
mod tests {
    use super::*;

    use tokio::io::{AsyncReadExt, AsyncWriteExt};

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

    #[actix_rt::test]
    async fn test_concurrent_locking_read_shared() {
        let path = std::env::temp_dir().join("test_read_shared");

        // should not block
        tokio::time::timeout(std::time::Duration::from_secs(5), async {
            let lock1 = acquire_file_read_lock(&path).await;
            let lock2 = acquire_file_read_lock(&path).await;
            let lock3 = acquire_file_read_lock(&path).await;

            drop(lock1);
            drop(lock2);
            drop(lock3);
        })
        .await
        .expect("timeout was reached");
    }

    #[actix_rt::test]
    async fn test_concurrent_locking_write_exclusive() {
        let path = std::env::temp_dir().join("test_write_exclusive");

        // should not block
        let excl_lock = tokio::time::timeout(
            std::time::Duration::from_secs(5),
            acquire_file_write_lock(&path),
        )
        .await
        .expect("timeout was reached");

        // should hang
        tokio::time::timeout(
            std::time::Duration::from_secs(1),
            acquire_file_read_lock(&path),
        )
        .await
        .expect_err("should hang, write lock is held");

        // should hang
        tokio::time::timeout(
            std::time::Duration::from_secs(1),
            acquire_file_write_lock(&path),
        )
        .await
        .expect_err("should hang, write lock is held");

        drop(excl_lock);
    }
}
