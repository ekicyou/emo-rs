#![allow(clippy::trivially_copy_pass_by_ref)]
use crate::prelude::*;
use log::*;
use std::fs;
use std::sync::Arc;

/// lua環境に関数を登録します。
/// * emo.*
/// * lfs.*
pub fn load_functions(lua: &Lua) -> LuaResult<()> {
    let emo = lua.create_table()?;
    let lfs = lua.create_table()?;
    {
        let f = lua.create_function(|_, name: String| {
            let rc = format!("Hello, {}!", name);
            trace!("rust_hello({})", name);
            Ok(rc)
        })?;
        emo.set("rust_hello", f)?;
    }
    {
        let f = lua.create_function(|_, ansi_dir: LuaString| {
            let bytes = ansi_dir.as_bytes();
            let dir = Encoding::ANSI
                .to_string(bytes)
                .map_err(|e| LuaError::ExternalError(Arc::new(e)))?;
            trace!("mkdir({})", dir);
            fs::create_dir_all(dir).map_err(|e| {
                error!("{}", e);
                LuaError::ExternalError(Arc::new(e))
            })?;
            Ok(true)
        })?;
        lfs.set("mkdir", f)?;
    }
    lua.globals().set("emo", emo)?;
    lua.globals().set("lfs", lfs)?;
    Ok(())
}
