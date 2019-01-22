use failure::Fail;

pub type Result<T> = std::result::Result<T, failure::Error>;

#[derive(Debug, Fail)]
pub enum ShioriParserError {
    #[fail(display = "Unknown Shiori request")]
    UnknownShioriRequest,
}
