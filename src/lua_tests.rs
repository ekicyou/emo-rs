#![cfg(test)]
use crate::lua_funcs::*;
use crate::prelude::*;
use crate::utils::*;
use log::*;
use std::env::current_dir;

use std::fs;
use std::path::Path;
#[test]
fn hello_test() {
    {
        std::env::set_var("RUST_LOG", "trace");
        let _ = env_logger::try_init();
    }
    let lua = Lua::new();
    lua.context(|lua| {
        let globals = lua.globals();
        let package = globals.get::<_, LuaTable<'_>>("package").unwrap();
        {
            let src_path = current_dir().unwrap();
            set_package_path(&lua, src_path);
        }
        {
            let path = package.get::<_, String>("path");
            assert_eq!(path.is_ok(), true);
            trace!("path= {:?}", path);
        }
        {
            let _: usize = lua
                .load("require(\"shiori.hello\");return 0;")
                .eval()
                .unwrap();
        }
        {
            let rc: String = lua.load("return hello(\"hello\")").eval().unwrap();
            assert_eq!(rc, "hello world");
        }
        {
            let rc: String = lua
                .load("return こんにちわ(\"世界\")")
                .eval()
                .unwrap();
            assert_eq!(rc, "こんにちわ、世界");
        }
        {
            let rc: String = lua.load("return _G._VERSION").eval().unwrap();
            assert_eq!(rc, "Lua 5.3");
        }
    });
}

/// 試験環境のlua モジュール検索パスを作成する。
/// * [root]\\script\\?.lua
/// * [root]\\script\\?\\init.lua
fn set_package_path<P: AsRef<Path>>(lua: &LuaContext<'_>, load_dir: P) {
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
        pre.push("target");
        pre.push("ソ―Ы 場所");
        append(&mut buf, pre);
    }
    {
        let mut pre = load_dir.as_ref().to_path_buf();
        pre.push("script");
        append(&mut buf, pre);
    }
    let globals = lua.globals();
    let package = globals.get::<_, LuaTable<'_>>("package").unwrap();
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

#[cfg(any(windows))]
#[test]
fn lua_funcs_test() {
    {
        std::env::set_var("RUST_LOG", "trace");
        let _ = env_logger::try_init();
    }
    let lua = Lua::new();
    lua.context(|lua| {
        {
            let src_path = current_dir().unwrap();
            set_package_path(&lua, src_path);
            load_functions(&lua).unwrap();
        }
        let globals = lua.globals();
        let emo = globals.get::<_, LuaTable<'_>>("emo").unwrap();
        {
            let f = emo.get::<_, LuaFunction<'_>>("rust_hello").unwrap();
            let rc: String = f.call("world").unwrap();
            assert_eq!(rc, "Hello, world!");
        }
        {
            let rc: String = lua.load("return emo.rust_hello(\"world\")").eval().unwrap();
            assert_eq!(rc, "Hello, world!");
        }
        {
            let save_dir = {
                let mut pre = current_dir().unwrap();
                pre.push("target");
                pre.push("ソ―Ы 場所");
                pre
            };
            let _ = fs::remove_dir_all(&save_dir);
            let ansi_save_dir = save_dir.to_ansi().unwrap();
            let mkdir_test = lua.create_table().unwrap();
            mkdir_test.set("ansi_save_dir", ansi_save_dir).unwrap();
            globals.set("mkdir_test", mkdir_test).unwrap();
            {
                let rc: bool = lua
                    .load("return lfs.mkdir(mkdir_test.ansi_save_dir .. \"\\\\test\")")
                    .eval()
                    .unwrap();
                assert_eq!(rc, true);
                let mut p = save_dir.to_owned();
                p.push("test");
                let _entry = fs::read_dir(p).unwrap();
            }
            {
                let rc: bool = lua
                    .load("return lfs.mkdir(mkdir_test.ansi_save_dir .. \"\\\\test\")")
                    .eval()
                    .unwrap();
                assert_eq!(rc, true);
            }
        }
    });
}
