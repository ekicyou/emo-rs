use failure::Fail;

pub type Result<T> = std::result::Result<T, failure::Error>;

#[derive(Debug, Fail)]
pub enum HGlobalError {
    #[fail(display = "ANSI encodeing error")]
    EncodeAnsi,
}
