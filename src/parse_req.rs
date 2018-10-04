use shiori3::*;

pub struct Req<'a> {
    inner: ShioriRequest<'a>,
}

impl<'lua, 'a> ToLua<'lua> for &Req<'a> {
    fn to_lua(self, lua: &'lua Lua) {
        0.to_lua(lua)
    }
}
