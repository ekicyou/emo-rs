pub use shiori3::{Encoder, Encoding, ShioriResult};
pub type MyResult<T> = std::result::Result<T, failure::Error>;
pub use rlua::prelude::*;
