use crate::prelude::*;
use std::ffi::OsStr;
use std::path::PathBuf;

pub trait ToAnsi {
    /// rust文字列をANSI文字列に変換します。
    fn to_ansi(&self) -> MyResult<String>;
}

impl ToAnsi for AsRef<str> {
    /// rust文字列をANSI文字列に変換します。
    fn to_ansi(&self) -> MyResult<String> {
        str_to_ansi(self)
    }
}

impl ToAnsi for AsRef<OsStr> {
    /// osstrをANSI文字列に変換します。
    fn to_ansi(&self) -> MyResult<String> {
        osstr_to_ansi(self)
    }
}
impl ToAnsi for PathBuf {
    /// osstrをANSI文字列に変換します。
    fn to_ansi(&self) -> MyResult<String> {
        osstr_to_ansi(self)
    }
}
fn str_to_ansi<S: AsRef<str>>(s: S) -> MyResult<String> {
    let utf8 = s.as_ref();
    let ansi_bytes = Encoding::ANSI.to_bytes(utf8)?;
    let rc = unsafe { String::from_utf8_unchecked(ansi_bytes) };
    Ok(rc)
}

fn osstr_to_ansi<S: AsRef<OsStr>>(src: S) -> MyResult<String> {
    let osstr = src.as_ref();
    let s = osstr.to_string_lossy();
    str_to_ansi(s)
}
