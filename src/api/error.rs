use failure::Fail;

pub type Result<T> = std::result::Result<T, failure::Error>;

#[derive(Debug, Fail)]
pub enum ShioriError {
    #[fail(display = "not initialized error")]
    NotInitialized,

    #[allow(dead_code)]
    #[fail(display = "load error")]
    Load,
}
