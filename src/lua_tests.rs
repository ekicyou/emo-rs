#![cfg(test)]
use log::*;
use rlua::{Context, Lua, Table};
use std::env::current_dir;
use std::path::Path;

#[test]
fn hello_test() {
    {
        std::env::set_var("RUST_LOG", "trace");
        let _ = env_logger::try_init();
    }
    let lua = Lua::new();
    lua.context(|context| {
        let globals = context.globals();
        let package = globals.get::<_, Table<'_>>("package").unwrap();
        {
            let src_path = current_dir().unwrap();
            set_package_path(&context, src_path);
        }
        {
            let path = package.get::<_, String>("path");
            assert_eq!(path.is_ok(), true);
            trace!("path= {:?}", path);
        }
        {
            let _: usize = context
                .load("require(\"shiori.hello\");return 0;")
                .eval()
                .unwrap();
        }
        {
            let rc: String = context.load("return hello(\"hello\")").eval().unwrap();
            assert_eq!(rc, "hello world");
        }
        {
            let rc: String = context
                .load("return こんにちわ(\"世界\")")
                .eval()
                .unwrap();
            assert_eq!(rc, "こんにちわ、世界");
        }
        {
            let rc: String = context.load("return _G._VERSION").eval().unwrap();
            assert_eq!(rc, "Lua 5.3");
        }
    });
}

fn set_package_path<P: AsRef<Path>>(lua: &Context<'_>, load_dir: P) {
    fn append<P: AsRef<Path>>(buf: &mut String, dir: P) {
        {
            let mut p = dir.as_ref().to_path_buf();
            p.push("?.lua");
            let text = p.to_str().unwrap();
            if !buf.is_empty() {
                buf.push(';');
            }
            buf.push_str(text);
        }
        {
            let mut p = dir.as_ref().to_path_buf();
            p.push("?");
            p.push("init.lua");
            let text = p.to_str().unwrap();
            if !buf.is_empty() {
                buf.push(';');
            }
            buf.push_str(text);
        }
    }

    let mut buf = String::new();
    {
        let mut pre = load_dir.as_ref().to_path_buf();
        pre.push("script");
        append(&mut buf, pre);
    }
    let globals = lua.globals();
    let package = globals.get::<_, Table<'_>>("package").unwrap();
    package.set("path", buf).unwrap();
}

#[cfg(any(windows))]
#[test]
fn os_str_test() {
    use std::ffi::*;
    use std::os::windows::ffi::*;
    let src_str = "ソポabcあいうえ";
    let src_utf16 = [
        0x30BD, 0x30DD, 0x0061, 0x0062, 0x0063, 0x3042, 0x3044, 0x3046, 0x3048,
    ];

    // OS文字列(UTF16)に変換
    let os1 = OsString::from(&src_str);
    let os2 = OsString::from_wide(&src_utf16[..]);
    assert_eq!(os1, os2);

    // rust文字列(UTF8)に変換
    let s1 = os1.into_string().unwrap();
    let s2 = os2.into_string().unwrap();
    assert_eq!(s1, src_str);
    assert_eq!(s2, src_str);

    // read_linkの挙動
    {
        let p1 = Path::new("c:\\Windows");
        assert_eq!(p1.is_absolute(), true);

        let p2 = Path::new("c:\\Windows\\");
        assert_eq!(p2.is_absolute(), true);

        {
            let mut buf = p1.to_path_buf();
            buf.push("a");
            assert_eq!(buf.pop(), true);
            let c = buf.to_str();
            assert_eq!(c, Some("c:\\Windows"));
        }
        {
            let mut buf = p2.to_path_buf();
            buf.push("a");
            assert_eq!(buf.pop(), true);
            let c = buf.to_str();
            assert_eq!(c, Some("c:\\Windows"));
        }
    }
}
