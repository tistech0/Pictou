use std::{
    error::Error as StdError,
    fmt::{self, Display},
};

use actix_web::{HttpResponse, ResponseError};
use oauth2::http::StatusCode;
use serde::Serialize;
use utoipa::ToSchema;

#[non_exhaustive]
#[derive(Debug, Serialize, Clone, Copy, PartialEq, Eq, ToSchema)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum AuthErrorKind {
    InvalidCredentials,
    InvalidAuthorizationHeader,
    InvalidToken,
    OAuth2ProviderError,
    OAuth2AuthorizationDenied,
    OAuth2InvalidState,
    OAuth2Forbidden,
    InternalError,
}

impl AuthErrorKind {
    pub const fn user_message(self) -> &'static str {
        match self {
            AuthErrorKind::InvalidCredentials => "invalid or expired credentials",
            AuthErrorKind::InvalidAuthorizationHeader => "invalid or expired authorization header",
            AuthErrorKind::InvalidToken => "malformed or invalid token",
            AuthErrorKind::OAuth2ProviderError => "OAuth2 provider error",
            AuthErrorKind::OAuth2AuthorizationDenied => "authorization denied by user",
            AuthErrorKind::OAuth2InvalidState => {
                "an error occurred while processing the authorization request"
            }
            AuthErrorKind::OAuth2Forbidden => "invalid state token",
            AuthErrorKind::InternalError => "internal server error",
        }
    }

    pub const fn status_code(self) -> StatusCode {
        match self {
            AuthErrorKind::InvalidCredentials => StatusCode::UNAUTHORIZED,
            AuthErrorKind::InvalidAuthorizationHeader => StatusCode::UNAUTHORIZED,
            AuthErrorKind::InvalidToken => StatusCode::UNAUTHORIZED,
            AuthErrorKind::OAuth2ProviderError => StatusCode::INTERNAL_SERVER_ERROR,
            AuthErrorKind::OAuth2AuthorizationDenied => StatusCode::FORBIDDEN,
            AuthErrorKind::OAuth2InvalidState => StatusCode::BAD_REQUEST,
            AuthErrorKind::OAuth2Forbidden => StatusCode::FORBIDDEN,
            AuthErrorKind::InternalError => StatusCode::INTERNAL_SERVER_ERROR,
        }
    }

    pub const fn to_error(self) -> AuthError {
        AuthError::new(self)
    }

    #[inline]
    pub fn with_cause<E>(self, cause: E) -> AuthError
    where
        E: Into<Box<dyn StdError + 'static>>,
    {
        AuthError::with_cause(self, cause)
    }
}

#[derive(Debug, ToSchema)]
pub struct AuthError {
    kind: AuthErrorKind,
    #[schema(value_type = String)]
    cause: Option<Box<dyn StdError + 'static>>,
}

impl AuthError {
    pub const fn new(kind: AuthErrorKind) -> AuthError {
        AuthError { kind, cause: None }
    }

    pub fn with_cause<E>(kind: AuthErrorKind, cause: E) -> AuthError
    where
        E: Into<Box<dyn StdError + 'static>>,
    {
        AuthError {
            kind,
            cause: Some(cause.into()),
        }
    }

    pub const fn kind(&self) -> AuthErrorKind {
        self.kind
    }
}

impl Display for AuthError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self.cause.as_ref() {
            Some(cause) => write!(f, "{}: {}", self.kind.user_message(), cause),
            None => write!(f, "{}", self.kind.user_message()),
        }
    }
}

impl StdError for AuthError {
    fn source(&self) -> Option<&(dyn StdError + 'static)> {
        self.cause.as_ref().map(|e| e.as_ref())
    }
}

impl Serialize for AuthError {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        JsonAuthError {
            code: self.kind,
            message: self.kind.user_message(),
        }
        .serialize(serializer)
    }
}

impl ResponseError for AuthError {
    fn status_code(&self) -> StatusCode {
        self.kind().status_code()
    }

    fn error_response(&self) -> HttpResponse {
        HttpResponse::build(self.status_code()).json(self)
    }
}

/// JSON representation of [`AuthError`].
#[derive(Serialize)]
struct JsonAuthError<'a> {
    code: AuthErrorKind,
    message: &'a str,
}
