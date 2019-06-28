use crate::prelude::*;

/// rust文字列をANSI文字列に変換します。
pub fn to_ansi_string<'a, S: AsRef<str>>(s: S) -> MyResult<String> {
    let utf8 = s.as_ref();
    let ansi_bytes = Encoding::ANSI.to_bytes(utf8)?;
    let rc = unsafe { String::from_utf8_unchecked(ansi_bytes) };
    Ok(rc)
}

