use crate::prelude::*;
use shiori3::*;
use std::path::Path;
use std::path::PathBuf;

/// luaの検索パスを作成します。
/// 以下の検索順となります。
///   1. [GHOST]/profile/emo/?.ext
///   2. [GHOST]/profile/emo/?/init.ext
///   3. [GHOST]/dic/lua/?.ext
///   4. [GHOST]/dic/lua/?/init.ext
///   5. [GHOST]/emo/lua/?.ext
///   6. [GHOST]/emo/lua/?/init.ext
pub fn lua_search_path<P: AsRef<Path>>(
    load_dir_path: P,
    ext: &str,
) -> MyResult<(PathBuf, String, String)> {
    // load dir(終端文字は除去)
    let load_dir_path = {
        let mut buf = load_dir_path.as_ref().to_path_buf();
        buf.push("a");
        buf.pop();
        buf
    };
    let load_dir = {
        let a = load_dir_path.to_str();
        let b = a.ok_or_else(|| ShioriError::from(ShioriErrorKind::Load))?;
        String::from(b)
    };

    // クロージャ呼び出し
    let mut lua_path = String::default();
    {
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
        add_path("\\profile\\emo");
        add_path("\\dic\\lua");
        add_path("\\emo\\lua");
    }

    Ok((load_dir_path, load_dir, lua_path))

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
fn lua_search_path_test() {
    {
        let (dir, _, path) =
            lua_search_path("c:\\留袖 綺麗ね\\ごーすと\\", "lua").unwrap();
        assert_eq!(dir.to_string_lossy(), "c:\\留袖 綺麗ね\\ごーすと");
        assert_eq!(path, "c:\\留袖 綺麗ね\\ごーすと\\profile\\emo\\?.lua;c:\\留袖 綺麗ね\\ごーすと\\profile\\emo\\?\\init.lua;c:\\留袖 綺麗ね\\ごーすと\\dic\\lua\\?.lua;c:\\留袖 綺麗ね\\ごーすと\\dic\\lua\\?\\init.lua;c:\\留袖 綺麗ね\\ごーすと\\emo\\lua\\?.lua;c:\\留袖 綺麗ね\\ごーすと\\emo\\lua\\?\\init.lua");
    }
}
