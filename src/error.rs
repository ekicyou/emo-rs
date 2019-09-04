use failure::Fail;

#[allow(dead_code)]
pub type MyResult<T> = std::result::Result<T, failure::Error>;

#[allow(dead_code)]
#[derive(Debug, Fail)]
pub enum EmoError {
    #[fail(display = "Other Emo Error")]
    Other,
}
