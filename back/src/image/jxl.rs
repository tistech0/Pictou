//! Custom JPEG XL codec, because the `image` crate does not support it yet.

use std::io::{BufRead, Seek};

pub struct JxlDecoder<R> {
    _temp: std::marker::PhantomData<R>,
}

impl<R: BufRead + Seek> JxlDecoder<R> {
    pub fn new(reader: R) -> anyhow::Result<Self> {
        let _ = reader;
        Ok(Self {
            _temp: std::marker::PhantomData,
        })
    }
}

impl<R: BufRead + Seek> image_backend::ImageDecoder for JxlDecoder<R> {
    fn dimensions(&self) -> (u32, u32) {
        todo!("see issue #79")
    }

    fn color_type(&self) -> image_backend::ColorType {
        todo!("see issue #79")
    }

    fn read_image(self, buf: &mut [u8]) -> image_backend::ImageResult<()>
    where
        Self: Sized,
    {
        let _ = buf;
        todo!("see issue #79")
    }

    fn read_image_boxed(self: Box<Self>, buf: &mut [u8]) -> image_backend::ImageResult<()> {
        let _ = buf;
        todo!("see issue #79")
    }
}
