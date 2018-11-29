use rlua::{Lua, Table};
use shiori3::*;
use std::borrow::Cow;
use std::path::Path;
use std::path::PathBuf;

pub struct EmoShiori {
    h_inst: usize,
    load_dir: PathBuf,
    lua_path: String,
    lua: Lua,
}
impl Drop for EmoShiori {
    fn drop(&mut self) {}
}
impl EmoShiori {
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

fn create_load_path<P: AsRef<Path>>(load_dir: P) -> ShioriResult<(PathBuf, String)> {
    // load dir(終端文字は除去)
    let load_dir = {
        let mut buf = load_dir.as_ref().to_path_buf();
        buf.push("a");
        buf.pop();
        buf
    };

    // luaモジュールのパス解決関数
    fn add_path_impl(buf: &mut String, load_dir: &str, ext: &str, root: &str, pre: &str) {
        if !buf.is_empty() {
            buf.push(';');
        }
        buf.push_str(load_dir);
        buf.push_str(root);
        buf.push_str(pre);
        buf.push_str(ext);
    }
    fn add_path(buf: &mut String, load_dir: &str, ext: &str, root: &str) {
        add_path_impl(buf, load_dir, ext, root, "\\?.");
        add_path_impl(buf, load_dir, ext, root, "\\?\\init.");
    }

    let lua_path = {
        let load_dir = {
            let a = load_dir.to_str();
            let b = a.ok_or(ShioriError::from(ShioriErrorKind::Load))?;
            String::from(b)
        };
        let mut buf = String::default();
        add_path(&mut buf, &load_dir, "lua", "\\usr");
        add_path(&mut buf, &load_dir, "lua", "\\share");
        buf
    };

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

impl Shiori3 for EmoShiori {
    fn load<P: AsRef<Path>>(h_inst: usize, load_dir: P) -> ShioriResult<Self> {
        // load dir(終端文字は除去)
        let (load_dir, lua_path) = create_load_path(load_dir)?;

        // ## luaに与える前にANSI文字列に変換すること

        // luaモジュールのロード

        // Lua インスタンスの作成
        let lua = Lua::new();

        // リザルト
        Ok(EmoShiori {
            h_inst: h_inst,
            load_dir: load_dir,
            lua_path: lua_path,
            lua: lua,
        })
    }
    fn request<'a, S: Into<&'a str>>(&mut self, req: S) -> ShioriResult<Cow<'a, str>> {
        let req_str = req.into();
        let req = ShioriRequest::parse(req_str)?;
        let rc = format!("[{:?}]{} is OK", self.load_dir, req_str);
        Ok(rc.into())
    }
}
