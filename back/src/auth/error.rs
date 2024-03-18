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
pub enum AuthErrorKind {
    #[serde(rename = "INVALID_CREDENTIALS")]
    InvalidCredentials,
    #[serde(rename = "INVALID_AUTHORIZATION_HEADER")]
    InvalidAuthorizationHeader,
    #[serde(rename = "INVALID_TOKEN")]
    InvalidToken,
    #[serde(rename = "OAUTH2_PROVIDER_ERROR")]
    OAuth2ProviderError,
    #[serde(rename = "OAUTH2_AUTHORIZATION_DENIED")]
    OAuth2AuthorizationDenied,
    #[serde(rename = "OAUTH2_INVALID_STATE")]
    OAuth2InvalidState,
    #[serde(rename = "OAUTH2_FORBIDDEN")]
    OAuth2Forbidden,
    #[serde(rename = "INVALID_CLIENT_TYPE")]
    UnknownProvider,
    #[serde(rename = "INTERNAL_ERROR")]
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
            AuthErrorKind::UnknownProvider => "unknown authentication provider",
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
            AuthErrorKind::UnknownProvider => StatusCode::BAD_REQUEST,
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

#[derive(Debug)]
pub struct AuthError {
    kind: AuthErrorKind,
    /// Should *not* appear in client responses, for debugging/tracing purposes only.
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
    /// Should *not* appear in client responses, for debugging/tracing purposes only.
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
            error_code: self.kind,
            description: self.kind.user_message(),
            http_status: self.kind.status_code().as_u16(),
        }
        .serialize(serializer)
    }
}

impl<'s> ToSchema<'s> for AuthError {
    fn schema() -> (
        &'s str,
        utoipa::openapi::RefOr<utoipa::openapi::schema::Schema>,
    ) {
        use utoipa::openapi::{ObjectBuilder, SchemaType};

        (
            "AuthError",
            ObjectBuilder::new()
                .property(
                    "description",
                    ObjectBuilder::new()
                        .schema_type(SchemaType::String)
                        .example(Some(serde_json::value::Value::String(
                            "some error description".to_owned(),
                        ))),
                )
                .required("description")
                .property("error_code", AuthErrorKind::schema().1)
                .required("error_code")
                .property(
                    "http_status",
                    ObjectBuilder::new()
                        .schema_type(SchemaType::Integer)
                        .example(Some(serde_json::value::Value::Number(
                            serde_json::Number::from(401),
                        ))),
                )
                .required("http_status")
                .into(),
        )
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
    error_code: AuthErrorKind,
    description: &'a str,
    http_status: u16,
}
