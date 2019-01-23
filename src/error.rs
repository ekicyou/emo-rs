use failure::Fail;

pub type Result<T> = std::result::Result<T, failure::Error>;

#[allow(dead_code)]
#[derive(Debug, Fail)]
pub enum EmoError {
    #[fail(display = "Other Emo Error")]
    Other,
}
