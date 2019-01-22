mod api;
mod error;
#[cfg(any(windows))]
mod windows;

pub use self::api::Shiori3;
#[cfg(any(windows))]
pub use self::windows::RawAPI;
pub use self::error::ShioriError;
pub use crate::shiori_parser::req::ShioriRequest;
