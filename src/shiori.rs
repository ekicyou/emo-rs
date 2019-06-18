use crate::lua_funcs::*;
use crate::lua_path::*;
use crate::lua_request::*;
use crate::prelude::*;
use rlua::{Function, Lua, Table};
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
    fn load<P: AsRef<Path>>(
        h_inst: usize,
        load_dir_path: P,
        load_dir_bytes: &[u8],
    ) -> MyResult<Self> {
        // 検索パスの作成
        let (load_dir_path, _, lua_path) = lua_search_path(load_dir_path, "lua")?;

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
                // ### モジュールパスを設定してinit.luaを読み込む
                let package: Table = globals.get("package")?;
                package.set("path", lua_path.clone())?;
                let _: usize = context.load("require(\"init\");return 0;").eval()?;
            }
            {
                // ### shiori.load()の呼び出し
                let shiori: Table = globals.get("shiori")?;
                let func: Function = shiori.get("load")?;
                let ansi_load_dir = unsafe {
                    let s = std::str::from_utf8_unchecked(load_dir_bytes);
                    s.to_owned()
                };
                func.call::<_, std::string::String>((h_inst, ansi_load_dir))?;
            }

            // ##  luaモジュールのロード
            Ok(())
        });
        result?;

        // リザルト
        Ok(Shiori {
            h_inst: h_inst,
            load_dir: load_dir_path,
            lua_path: lua_path,
            lua: lua,
        })
    }

    /// SHIORIリクエストを解釈し、応答を返します。
    fn request<'a, S: Into<&'a str>>(&mut self, req: S) -> MyResult<Cow<'a, str>> {
        let result: MyResult<_> = self.lua().context(|context| {
            let req = parse_request(&context, req.into())?;
            let globals = context.globals();
            let shiori: Table = globals.get("shiori")?;
            let func: Function = shiori.get("request")?;
            let res = func.call::<_, std::string::String>(req)?;
            Ok(res)
        });
        let res = result?;
        Ok(res.into())
    }
}
