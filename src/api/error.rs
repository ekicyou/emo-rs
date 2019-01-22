use failure::{Backtrace, Fail};

pub type Result<T> = std::result::Result<T, failure::Error>;

#[derive(Debug, Fail)]
pub enum ShioriError {
    #[fail(display = "not initialized error")]
    NotInitialized,

    #[allow(dead_code)]
    #[fail(display = "poison error")]
    Poison,

    #[allow(dead_code)]
    #[fail(display = "load error")]
    Load,
}

#[derive(Debug, Fail)]
#[fail(display = "resource bla Mutex was poisoned")]
pub struct ShioriPoisonError {
    backtrace: Backtrace,
}

impl ShioriPoisonError {
    pub fn new() -> ShioriPoisonError {
        ShioriPoisonError {
            backtrace: Backtrace::new(),
        }
    }
}

//for op-?, "auto" type conversion
impl<T> From<std::sync::PoisonError<T>> for ShioriPoisonError {
    fn from(_: std::sync::PoisonError<T>) -> Self {
        ShioriPoisonError::new()
    }
}
