use std::{
    error::Error as StdError,
    fmt::{self, Display},
};

#[cfg(feature = "python-classifier")]
mod python;
#[cfg(feature = "python-classifier")]
pub use python::*;

#[cfg(not(feature = "python-classifier"))]
mod stub;
#[cfg(not(feature = "python-classifier"))]
pub use stub::*;

pub struct ImageTagPrediction {
    pub tag: String,
    pub probability: f64,
}

#[derive(Debug)]
#[non_exhaustive]
pub enum ClassifierError {
    #[cfg(feature = "python-classifier")]
    Python(::pyo3::PyErr),
    #[allow(dead_code)]
    Unknown,
}

impl Display for ClassifierError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            #[cfg(feature = "python-classifier")]
            Self::Python(err) => err.fmt(f),
            Self::Unknown => write!(f, "unknown classifier error"),
        }
    }
}

impl StdError for ClassifierError {}

#[cfg(feature = "python-classifier")]
impl From<::pyo3::PyErr> for ClassifierError {
    fn from(err: ::pyo3::PyErr) -> Self {
        Self::Python(err)
    }
}
