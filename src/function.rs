use rlua::Context;
use rlua::Result;

/// luaで利用する関数を登録します。
pub fn load_functions(context: &Context) -> Result<()> {
    let g = context.globals();
    let f = context.create_function(|_, name: String| {
        println!("Hello, {}!", name);
        Ok(())
    })?;
    g.set("rust_hello", f)?;
    Ok(())
}
