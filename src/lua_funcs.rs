use crate::prelude::*;
use rlua::*;
use shiori3::*;

/// luaで利用する関数を登録します。
pub fn load_functions(c: &Context) -> LuaResult<()> {
    let g = c.globals();
    let f = c.create_function(|_, name: String| {
        println!("Hello, {}!", name);
        Ok(())
    })?;
    g.set("rust_hello", f)?;
    Ok(())
}

// UserData
pub struct Req<'a>(ShioriRequest<'a>);

impl<'a> Req<'a> {
    pub fn parse(text: &'a str) -> MyResult<Req<'a>> {
        let a = ShioriRequest::parse(text)?;
        Ok(Req(a))
    }
}

impl<'a> UserData for Req<'a> {
    fn add_methods<'lua, M: UserDataMethods<'lua, Self>>(methods: &mut M) {
        methods.add_method("text", |_, x, _: ()| Ok(x.0.text));
        methods.add_method("version", |_, x, _: ()| Ok(x.0.version));
        methods.add_method("method", |_, x, _: ()| {
            let a = match x.0.method {
                ShioriParserRule::get => "get",
                ShioriParserRule::notify => "notify",
                _ => "other",
            };
            Ok(a)
        });
        methods.add_method("id", |_, x, _: ()| Ok(x.0.id));
        methods.add_method("sender", |_, x, _: ()| Ok(x.0.sender));
        methods.add_method("security_level", |_, x, _: ()| Ok(x.0.security_level));
        methods.add_method("charset", |_, x, _: ()| Ok(x.0.charset));
        methods.add_method("status", |_, x, _: ()| Ok(x.0.status));
        methods.add_method("base_id", |_, x, _: ()| Ok(x.0.base_id));
        methods.add_method("reference", |c, x, _: ()|{
            let a = x.0.reference.iter()
                .map(|&a| {
                    let k = a.0.to_lua(c);
                    let v = a.1.to_lua(c);
                    (k,v)
                } ).collect::<Vec<_>>();
             Ok(1)
             });
        methods.add_method("dic", |_, x, _: ()| Ok(x.0.dic));
        methods.add_method("key_values", |_, x, _: ()| Ok(x.0.key_values));
    }
}
