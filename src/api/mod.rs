mod api;
mod di;
mod error;
#[cfg(any(windows))]
mod windows;

pub use self::api::Shiori3;
pub use self::error::ShioriError;
#[cfg(any(windows))]
pub use self::windows::RawAPI;
pub use crate::shiori_parser::req::ShioriRequest;
