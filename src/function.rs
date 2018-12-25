use rlua::Lua;
use rlua::Result;

pub fn init_functions(l: &Lua) -> Result<()> {
    let g = l.globals();
    {
        let f = l.create_function(|_, name: String| {
            println!("Hello, {}!", name);
            Ok(())
        })?;
        g.set("rust_hello", f)?;
    }
    Ok(())
}
