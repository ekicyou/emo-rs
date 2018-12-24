use crate::shiori_parser;
use failure::{Backtrace, Context, Fail};
use std::fmt;
use std::fmt::Display;
use std::str::Utf8Error;
use std::sync::PoisonError;

pub type ShioriResult<T> = Result<T, Error>;

#[derive(Clone, Debug, Fail)]
pub enum ErrorKind {
    #[allow(dead_code)]
    #[fail(display = "others error")]
    Others,

    #[allow(dead_code)]
    #[fail(display = "load error")]
    Load,

    #[fail(display = "not initialized error")]
    NotInitialized,

    #[fail(display = "Poison error")]
    Poison,

    #[fail(display = "ANSI encodeing error")]
    EncodeAnsi,

    #[fail(display = "UTF8 encodeing error: {}", inner)]
    EncodeUtf8 { inner: Utf8Error },

    #[fail(display = "Shiori request parse error: {}", inner)]
    ParseRequest {
        inner: shiori_parser::req::ParseError,
    },

    #[allow(dead_code)]
    #[fail(display = "lua error: {}", inner)]
    Script { inner: rlua::Error },
}

impl<G> From<PoisonError<G>> for Error {
    fn from(_error: PoisonError<G>) -> Error {
        Error::from(ErrorKind::Poison)
    }
}
impl From<Utf8Error> for Error {
    fn from(error: Utf8Error) -> Error {
        Error {
            inner: error.context(ErrorKind::EncodeUtf8 { inner: error }),
        }
    }
}
impl From<shiori_parser::req::ParseError> for Error {
    fn from(error: shiori_parser::req::ParseError) -> Error {
        let cp = error.clone();
        Error {
            inner: error.context(ErrorKind::ParseRequest { inner: cp }),
        }
    }
}
impl From<rlua::Error> for Error {
    fn from(error: rlua::Error) -> Error {
        let cp = error.clone();
        Error {
            inner: error.context(ErrorKind::Script { inner: cp }),
        }
    }
}

/* ----------- failure boilerplate ----------- */
#[derive(Debug)]
pub struct Error {
    inner: Context<ErrorKind>,
}

impl Fail for Error {
    fn cause(&self) -> Option<&Fail> {
        self.inner.cause()
    }

    fn backtrace(&self) -> Option<&Backtrace> {
        self.inner.backtrace()
    }
}

impl Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        Display::fmt(&self.inner, f)
    }
}

impl Error {
    #[allow(dead_code)]
    pub fn new(inner: Context<ErrorKind>) -> Error {
        Error { inner }
    }

    #[allow(dead_code)]
    pub fn kind(&self) -> &ErrorKind {
        self.inner.get_context()
    }
}

impl From<ErrorKind> for Error {
    fn from(kind: ErrorKind) -> Error {
        Error {
            inner: Context::new(kind),
        }
    }
}

impl From<Context<ErrorKind>> for Error {
    fn from(inner: Context<ErrorKind>) -> Error {
        Error { inner }
    }
}
