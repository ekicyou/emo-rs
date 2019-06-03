use crate::function::*;
use crate::path::*;
use crate::prelude::*;
use rlua::{Lua, Table};
use shiori3::*;
use std::borrow::Cow;
use std::path::Path;
use std::path::PathBuf;

#[allow(dead_code)]
#[derive(Default)]
pub struct Shiori {
    h_inst: usize,
    ansi_load_dir: PathBuf,
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
    fn ansi_load_dir(&self) -> &Path {
        &(self.ansi_load_dir)
    }
    fn lua(&self) -> &Lua {
        &(self.lua)
    }
}

impl Shiori3 for Shiori {
    /// load_dir pathのファイルでSHIORIインスタンスを作成します。
    fn load<P: AsRef<Path>>(h_inst: usize, ansi_load_dir: P) -> MyResult<Self> {
        // 検索パスの作成
        let (ansi_load_dir, lua_path) = lua_search_path(ansi_load_dir, "lua")?;

        // ##  Lua インスタンスの作成
        let lua = Lua::new();

        let result: LuaResult<_> = lua.context(|context| {
            // ## 関数の登録
            load_functions(&context)?;

            // ##  グローバル変数の設定
            // ### lua内のパス名解決ではANSI文字列を与える必要があることに注意
            // 1. rust⇔lua間の文字列エンコーディングはutf-8とする。
            // 2. モジュール解決対象のファイル名はASCII名称とする。
            let globals = context.globals();
            {
                // ### モジュールパス設定
                let package: Table = globals.get("package")?;
                package.set("path", lua_path.clone())?;
            }
            {
                // ### SHIORI変数
                let shiori: Table = context.create_table()?;
                shiori.set("h_inst", h_inst)?;
                globals.set("shiori", shiori)?;
            }

            // ##  luaモジュールのロード
            Ok(())
        });
        result?;

        // リザルト
        Ok(Shiori {
            h_inst: h_inst,
            ansi_load_dir: ansi_load_dir,
            lua_path: lua_path,
            lua: lua,
        })
    }

    /// SHIORIリクエストを解釈し、応答を返します。
    fn request<'a, S: Into<&'a str>>(&mut self, req: S) -> MyResult<Cow<'a, str>> {
        let req_str = req.into();
        let _req = ShioriRequest::parse(req_str)?;
        let rc = format!("[{:?}]{} is OK", self.ansi_load_dir, req_str);
        Ok(rc.into())
    }
}
