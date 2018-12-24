mod api;
#[cfg(any(windows))]
mod windows;

pub use self::api::Shiori3;
#[cfg(any(windows))]
pub use self::windows::RawAPI;
pub use crate::error::Error as ShioriError;
pub use crate::error::ErrorKind as ShioriErrorKind;
pub use crate::error::ShioriResult;
pub use crate::shiori_parser::req::ShioriRequest;
