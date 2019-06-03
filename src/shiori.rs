use crate::function::*;
use rlua::{Lua, Table};
use shiori3::*;
use std::borrow::Cow;
use std::path::Path;
use std::path::PathBuf;

#[allow(dead_code)]
#[derive(Default)]
pub struct Shiori {
    h_inst: usize,
    load_dir: PathBuf,
    lua_path: String,
    lua: Lua,
}
impl Drop for Shiori {
    fn drop(&mut self) {}
}

#[allow(dead_code)]
impl Shiori {
    fn h_inst(&self) -> usize {
        (self.h_inst)
    }
    fn load_dir(&self) -> &Path {
        &(self.load_dir)
    }
    fn lua(&self) -> &Lua {
        &(self.lua)
    }
}

impl Shiori3 for Shiori {
    /// load_dir pathのファイルでSHIORIインスタンスを作成します。
    fn load<P: AsRef<Path>>(h_inst: usize, load_dir: P) -> Result<Self, failure::Error> {
        // 検索パスの作成
        let (load_dir, lua_path) = lua_search_path(load_dir, "lua")?;

        // ##  Lua インスタンスの作成
        let lua = Lua::new();

        let result: rlua::Result<()> = lua.context(|context| {
            // ## 関数の登録
            load_functions(&context)?;

            // ##  グローバル変数の設定
            // ### lua内のパス名解決ではANSI文字列を与える必要があることに注意
            // 1. rust⇔lua間の文字列エンコーディングはutf-8とする。
            // 2. モジュール解決対象のファイル名はASCII名称とする。
            let globals = context.globals();

            // ### モジュール
            let package: Table = globals.get("package")?;
            package.set("path", lua_path.clone())?;

            // ##  luaモジュールのロード
            Ok(())
        });
        result?;

        // リザルト
        Ok(Shiori {
            h_inst: h_inst,
            load_dir: load_dir,
            lua_path: lua_path,
            lua: lua,
        })
    }

    /// SHIORIリクエストを解釈し、応答を返します。
    fn request<'a, S: Into<&'a str>>(&mut self, req: S) -> Result<Cow<'a, str>, failure::Error> {
        let req_str = req.into();
        let _req = ShioriRequest::parse(req_str)?;
        let rc = format!("[{:?}]{} is OK", self.load_dir, req_str);
        Ok(rc.into())
    }
}

/// luaの検索パスを作成します。
fn lua_search_path<P: AsRef<Path>>(
    load_dir: P,
    ext: &str,
) -> Result<(PathBuf, String), failure::Error> {
    // load dir(終端文字は除去)
    let load_dir = {
        let mut buf = load_dir.as_ref().to_path_buf();
        buf.push("a");
        buf.pop();
        buf
    };

    // クロージャ呼び出し
    let mut lua_path = String::default();
    {
        let load_dir = {
            let a = load_dir.to_str();
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

    Ok((load_dir, lua_path))

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
