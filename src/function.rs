use rlua::Context;
use shiori3::*;
use std::path::Path;
use std::path::PathBuf;

/// luaの検索パスを作成します。
pub fn lua_search_path<P: AsRef<Path>>(
    ansi_load_dir: P,
    ext: &str,
) -> Result<(PathBuf, String), failure::Error> {
    // load dir(終端文字は除去)
    let ansi_load_dir = {
        let mut buf = ansi_load_dir.as_ref().to_path_buf();
        buf.push("a");
        buf.pop();
        buf
    };

    // クロージャ呼び出し
    let mut lua_path = String::default();
    {
        let load_dir = {
            let a = ansi_load_dir.to_str();
            let b = a.ok_or(ShioriError::from(ShioriErrorKind::Load))?;
            String::from(b)
        };
        // luaモジュールのパス解決関数
        let mut add_path = |root: &str| {
            let mut add_path = |pre: &str| {
                if !lua_path.is_empty() {
                    lua_path.push(';');
                }
                lua_path.push_str(&load_dir);
                lua_path.push_str(root);
                lua_path.push_str(pre);
                lua_path.push_str(ext);
            };
            add_path("\\?.");
            add_path("\\?\\init.");
        };
        add_path("\\usr");
        add_path("\\share");
    }

    Ok((ansi_load_dir, lua_path))

    // # luaのモジュール解決
    // modname は以下の順に検索され、最初に解決したものを返す。
    // この動作はpackage.searchersに登録されている既定の動作である。
    //  1. package.preload[modname]
    //  2. package.path  を用いてパス解決
    //  3. package.cpath を用いてパス解決
    //  4. package.searchers より、オールインワンローダで解決

    // ## パス解決ルール
    // パス解決は package.searchpath (name, path [, sep [, rep]]) により行われる。
    // パスに含まれる「?」が、nameに置き換わり、最初に見つかったファイル名を返す。
    // 例）
    //   * name ="foo.a"
    //     * ? ="foo/a"
    //   * path ="./?.lua;./?.lc;/usr/local/?/init.lua"
    //     * "./foo/a.lua"
    //     * "./foo/a.lc"
    //     * "/usr/local/foo/a/init.lua"

    // ## moe.dllのパス解決
    //  1. load_dirを絶対パスに変換する。例）load_dir="c:\萌え 萌え\ghost\キュン";
    //  2.
}
#[cfg(any(windows))]
#[test]
fn lua_search_pathh_test() {
    {
        let (dir, path) = lua_search_path("c:\\留袖 綺麗ね\\ごーすと\\", "lua").unwrap();
        assert_eq!(dir.to_string_lossy(), "c:\\留袖 綺麗ね\\ごーすと");
        assert_eq!(path, "c:\\留袖 綺麗ね\\ごーすと\\usr\\?.lua;c:\\留袖 綺麗ね\\ごーすと\\usr\\?\\init.lua;c:\\留袖 綺麗ね\\ごーすと\\share\\?.lua;c:\\留袖 綺麗ね\\ごーすと\\share\\?\\init.lua");
    }
}

/// luaで利用する関数を登録します。
pub fn load_functions(c: &Context) -> Result<(), rlua::Error> {
    let g = c.globals();
    let f = c.create_function(|_, name: String| {
        println!("Hello, {}!", name);
        Ok(())
    })?;
    g.set("rust_hello", f)?;
    Ok(())
}
