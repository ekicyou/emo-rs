#![allow(clippy::trivially_copy_pass_by_ref)]
use crate::prelude::*;
use std::fs;
use std::sync::Arc;

/// emo.* 関数を登録します。
pub fn load_functions(c: &rlua::Context<'_>) -> LuaResult<()> {
    let emo = c.create_table()?;
    let lfs = c.create_table()?;
    {
        let f = c.create_function(|_, name: String| {
            println!("Hello, {}!", name);
            Ok(())
        })?;
        emo.set("rust_hello", f)?;
    }
    {
        let f = c.create_function(|_, ansi_dir: LuaString| {
            let bytes = ansi_dir.as_bytes();
            let dir = Encoding::ANSI
                .to_string(bytes)
                .map_err(|e| LuaError::ExternalError(Arc::new(e)))?;
            fs::create_dir_all(dir).map_err(|e| LuaError::ExternalError(Arc::new(e)))?;
            Ok(())
        })?;
        lfs.set("mkdir", f)?;
    }
    c.globals().set("emo", emo)?;
    c.globals().set("lfs", lfs)?;
    Ok(())
}
