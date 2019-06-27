#![allow(clippy::trivially_copy_pass_by_ref)]
use crate::prelude::*;
use std::fs;
use std::sync::Arc;

/// emo.* 関数を登録します。
pub fn load_functions(lua: &rlua::Context<'_>) -> LuaResult<()> {
    let emo = lua.create_table()?;
    let lfs = lua.create_table()?;
    {
        let f = lua.create_function(|_, name: String| {
            println!("Hello, {}!", name);
            Ok(())
        })?;
        emo.set("rust_hello", f)?;
    }
    {
        let f = lua.create_function(|_, ansi_dir: LuaString| {
            let bytes = ansi_dir.as_bytes();
            let dir = Encoding::ANSI
                .to_string(bytes)
                .map_err(|e| LuaError::ExternalError(Arc::new(e)))?;
            fs::create_dir_all(dir).map_err(|e| LuaError::ExternalError(Arc::new(e)))?;
            Ok(())
        })?;
        lfs.set("mkdir", f)?;
    }
    lua.globals().set("emo", emo)?;
    lua.globals().set("lfs", lfs)?;
    Ok(())
}
