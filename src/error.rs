use thiserror::Error;

#[allow(dead_code)]
#[derive(Debug, Error)]
pub enum EmoError {
    #[error("Other Emo Error")]
    Other,
}
