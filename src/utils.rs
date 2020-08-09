use crate::prelude::*;
use std::ffi::OsStr;
use std::fs;
use std::path::{Path, PathBuf};

pub trait ToAnsi {
    /// rust文字列をANSI文字列に変換します。
    fn to_ansi(&self) -> MyResult<String>;
}

impl ToAnsi for dyn AsRef<str> {
    /// rust文字列をANSI文字列に変換します。
    fn to_ansi(&self) -> MyResult<String> {
        str_to_ansi(self)
    }
}

impl ToAnsi for dyn AsRef<OsStr> {
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

pub fn setup_logger<P: AsRef<Path>>(load_dir: P) -> MyResult<()> {
    let log_file = {
        let mut p = load_dir.as_ref().to_owned();
        p.push("profile");
        p.push("emo");
        p.push("emo.log");
        let f = fs::OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            //.append(true)
            .open(p)?;
        f
    };

    fern::Dispatch::new()
        .format(|out, message, record| {
            out.finish(format_args!(
                "{} {} {} {}",
                chrono::Local::now().format("%Y-%m-%d %H:%M:%S%.6f"),
                record.level(),
                record.target(),
                message
            ))
        })
        .level(log::LevelFilter::Info)
        .chain(std::io::stdout())
        .chain(log_file)
        .apply()?;
    Ok(())
}
