#![allow(clippy::trivially_copy_pass_by_ref)]
use crate::prelude::*;

/// luaで利用する関数を登録します。
pub fn load_functions(c: &rlua::Context<'_>) -> LuaResult<()> {
    let g = c.globals();
    let f = c.create_function(|_, name: String| {
        println!("Hello, {}!", name);
        Ok(())
    })?;
    g.set("rust_hello", f)?;
    Ok(())
}
