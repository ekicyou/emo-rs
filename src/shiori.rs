use crate::lua_funcs::*;
use crate::path::*;
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
    ansi_load_dir: PathBuf,
    load_dir: String,
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
        let (ansi_load_dir, load_dir, lua_path) = lua_search_path(ansi_load_dir, "lua")?;

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
                // ### shioriテーブルがinit.luaで定義されているので読み込む
                let shiori: Table = globals.get("shiori")?;
                let params: Table = context.create_table()?;
                params.set("h_inst", h_inst)?;
                params.set("load_dir", load_dir.clone())?;
                shiori.set("params", params)?;
            }

            // ##  luaモジュールのロード
            Ok(())
        });
        result?;

        // リザルト
        Ok(Shiori {
            h_inst: h_inst,
            ansi_load_dir: ansi_load_dir,
            load_dir: load_dir,
            lua_path: lua_path,
            lua: lua,
        })
    }

    /// SHIORIリクエストを解釈し、応答を返します。
    fn request<'a, S: Into<&'a str>>(&mut self, req: S) -> MyResult<Cow<'a, str>> {
        let result: MyResult<_> = self.lua().context(|context| {
            // rust側の解析結果をうまく渡せない。。。
            // let req_data = Req::parse(req_str)?;

            // local res = shiori.request(req) 関数を呼び出し、結果を取得する。
            let req_str = req.into();
            let globals = context.globals();
            let shiori: Table = globals.get("shiori")?;
            let req_func: Function = shiori.get("request")?;
            let res = req_func.call::<_, std::string::String>(req_str)?;
            Ok(res)
        });
        let res = result?;
        Ok(res.into())
    }
}
