use failure::Fail;

pub type Result<T> = std::result::Result<T, failure::Error>;

#[derive(Debug, Fail)]
pub enum EmoError {
    #[fail(display = "Other Emo Error")]
    Other,
}
