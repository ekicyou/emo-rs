pub use rlua::Result as LuaResult;
pub use shiori3::ShioriResult;
pub type MyResult<T> = std::result::Result<T, failure::Error>;
