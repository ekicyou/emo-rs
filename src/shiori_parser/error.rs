use failure::Fail;

pub type Result<T> = std::result::Result<T, failure::Error>;

#[allow(dead_code)]
#[derive(Debug, Fail)]
pub enum ShioriParserError {
    #[fail(display = "Unknown Shiori request")]
    UnknownShioriRequest,
}
