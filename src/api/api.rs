use super::error::*;
use std::borrow::Cow;
use std::path::Path;

pub trait Shiori3: Drop + Sized {
    /// 新しいSHIORIインスタンスを作成します。
    fn load<P: AsRef<Path>>(h_inst: usize, load_dir: P) -> Result<Self>;

    /// SHIORIリクエストを解釈し、応答を返します。
    fn request<'a, S: Into<&'a str>>(&mut self, req: S) -> Result<Cow<'a, str>>;
}

pub trait Shiori3X: Drop + Sized {}

pub trait IsSvcShiori3: Drop + Sized {
    /// 新しいSHIORIインスタンスを作成します。
    fn load<P: AsRef<Path>>(h_inst: usize, load_dir: P) -> Result<Self>;

    /// SHIORIリクエストを解釈し、応答を返します。
    fn request<'a, S: Into<&'a str>>(&mut self, req: S) -> Result<Cow<'a, str>>;
}
