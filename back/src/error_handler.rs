use std::fmt::Display;

use actix_web::http::StatusCode;
use actix_web::{
    body::MessageBody, dev::ServiceResponse, http::header, middleware::ErrorHandlerResponse,
    HttpResponse, HttpResponseBuilder, Result,
};
use actix_web::{HttpRequest, ResponseError};
use futures::executor::block_on;
use serde::{Deserialize, Serialize};
use std::str::from_utf8;
use utoipa::ToSchema;

use crate::auth::error::AuthError;

#[derive(Clone, Deserialize, Serialize, Debug, ToSchema)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum ApiErrorCode {
    Unknown,
    QueryPayloadError,
    JsonPayloadError,
    PathError,
    NotFoundError,
    UnauthorizedError,
    ForbiddenError,
}

#[derive(Debug, Deserialize, Serialize, ToSchema)]
pub struct ApiError {
    http_status: u16,
    error_code: ApiErrorCode,
    description: String,
}

impl Display for ApiError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{:?}", self)
    }
}

impl ApiError {
    pub fn new(http_status: StatusCode, error_code: ApiErrorCode, description: &str) -> Self {
        ApiError {
            http_status: http_status.as_u16(),
            error_code,
            description: description.into(),
        }
    }

    pub fn query_payload_error(description: &str) -> Self {
        ApiError::new(
            StatusCode::BAD_REQUEST,
            ApiErrorCode::QueryPayloadError,
            description,
        )
    }

    pub fn json_payload_error(description: &str) -> Self {
        ApiError::new(
            StatusCode::BAD_REQUEST,
            ApiErrorCode::JsonPayloadError,
            description,
        )
    }

    pub fn path_error(description: &str) -> Self {
        ApiError::new(
            StatusCode::BAD_REQUEST,
            ApiErrorCode::PathError,
            description,
        )
    }

    pub fn not_found_error(resource_name: &str) -> Self {
        ApiError {
            http_status: StatusCode::NOT_FOUND.as_u16(),
            error_code: ApiErrorCode::NotFoundError,
            description: format!("{} not found", resource_name),
        }
    }

    pub fn unauthorized_error() -> Self {
        ApiError {
            http_status: StatusCode::UNAUTHORIZED.as_u16(),
            error_code: ApiErrorCode::UnauthorizedError,
            description: "Trying to access private resource with missing or invalid credentials"
                .to_string(),
        }
    }

    pub fn forbidden_error() -> Self {
        ApiError {
            http_status: StatusCode::FORBIDDEN.as_u16(),
            error_code: ApiErrorCode::ForbiddenError,
            description: "Trying to access private resource with valid credentials but insufficient access rights"
                .to_string(),
        }
    }
}

// Important: implement ResponseError to render as actix_web::Error
impl actix_web::ResponseError for ApiError {
    fn status_code(&self) -> StatusCode {
        StatusCode::from_u16(self.http_status).unwrap_or(StatusCode::INTERNAL_SERVER_ERROR)
    }

    fn error_response(&self) -> HttpResponse {
        HttpResponseBuilder::new(self.status_code())
            .insert_header(header::ContentType(mime::APPLICATION_JSON))
            .json(actix_web::web::Json(self))
    }
}

fn make_error_response<B: MessageBody>(
    req: HttpRequest,
    description: String,
    error_code: ApiErrorCode,
    http_status: StatusCode,
) -> Result<ErrorHandlerResponse<B>> {
    let api_error = ApiError {
        http_status: http_status.as_u16(),
        error_code,
        description,
    };
    Ok(ErrorHandlerResponse::Response(
        ServiceResponse::new(req, api_error.error_response()).map_into_right_body(),
    ))
}

pub fn json_error_handler<B: MessageBody>(
    res: ServiceResponse<B>,
) -> Result<ErrorHandlerResponse<B>> {
    let request = res.request().clone();

    // Handle error response
    if res.response().error().is_some() {
        let error = res.response().error().ok_or_else(|| {
            ApiError::new(
                StatusCode::INTERNAL_SERVER_ERROR,
                ApiErrorCode::Unknown,
                "An error occurred",
            )
        })?;

        // Already handled errors
        if let Some(_err) = error.as_error::<ApiError>() {
            return Ok(ErrorHandlerResponse::Response(res.map_into_left_body()));
        }
        if let Some(_err) = error.as_error::<AuthError>() {
            return Ok(ErrorHandlerResponse::Response(res.map_into_left_body()));
        }
        // Actix error types handled here
        if let Some(err) = error.as_error::<actix_web::error::QueryPayloadError>() {
            return make_error_response(
                request,
                err.to_string(),
                ApiErrorCode::QueryPayloadError,
                StatusCode::BAD_REQUEST,
            );
        }
        if let Some(err) = error.as_error::<actix_web::error::PathError>() {
            return make_error_response(
                request,
                err.to_string(),
                ApiErrorCode::PathError,
                StatusCode::BAD_REQUEST,
            );
        }
        if let Some(err) = error.as_error::<actix_web::error::JsonPayloadError>() {
            return make_error_response(
                request,
                err.to_string(),
                ApiErrorCode::JsonPayloadError,
                StatusCode::BAD_REQUEST,
            );
        }
    }

    // Unknown error, serialize the body content to json as an unknown error without changing the http status
    let status = res.response().status();
    let Ok(_body_bytes) = block_on(actix_web::body::to_bytes(res.into_body())) else {
        panic!("Error reading body");
    };
    let body_str = from_utf8(&_body_bytes).unwrap_or("<no message>");
    let mut error_code = ApiErrorCode::Unknown;
    if status == StatusCode::NOT_FOUND {
        error_code = ApiErrorCode::NotFoundError;
    }
    make_error_response(request, body_str.to_string(), error_code, status)
}

pub fn path_error_handler(
    e: actix_web::error::PathError,
    _req: &HttpRequest,
) -> actix_web::error::Error {
    ApiError::path_error(&e.to_string()).into()
}
