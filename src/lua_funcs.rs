use crate::prelude::*;
use shiori3::*;

/// luaで利用する関数を登録します。
pub fn load_functions(c: &rlua::Context) -> LuaResult<()> {
    let g = c.globals();
    let f = c.create_function(|_, name: String| {
        println!("Hello, {}!", name);
        Ok(())
    })?;
    g.set("rust_hello", f)?;
    Ok(())
}

// UserData
pub struct Req<'a>(req::ShioriRequest<'a>);

impl<'a> Req<'a> {
    pub fn parse(text: &'a str) -> MyResult<Req<'a>> {
        let a = req::ShioriRequest::parse(text)?;
        Ok(Req(a))
    }
}

impl<'a> rlua::UserData for Req<'a> {
    fn add_methods<'lua, M: rlua::UserDataMethods<'lua, Self>>(methods: &mut M) {
        methods.add_method("text", |_, x, _: ()| Ok(x.0.text));
        methods.add_method("version", |_, x, _: ()| Ok(x.0.version));
        methods.add_method("method", |_, x, _: ()| {
            let a = match x.0.method {
                req::Rule::get => "get",
                req::Rule::notify => "notify",
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
        methods.add_method("reference", |c, x, _: ()| {
            let i = x.0.reference.iter().map(|&a| (a.0, a.1));
            let t = c.create_table_from(i)?;
            Ok(t)
        });
        methods.add_method("dic", |_, x, _: ()| Ok(x.0.dic.to_owned()));
        methods.add_method("key_values", |c, x, _: ()| {
            let i = x.0.key_values.iter().map(|&a| (a.1, a.2));
            let t = c.create_table_from(i)?;
            Ok(t)
        });
    }
}
