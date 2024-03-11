use std::fmt::Display;

use actix_web::http::StatusCode;
use actix_web::{
    body::MessageBody, dev::ServiceResponse, http::header, middleware::ErrorHandlerResponse,
    HttpResponse, HttpResponseBuilder, Result,
};
use actix_web::{HttpRequest, ResponseError};
use futures::executor::block_on;
use mime;
use serde::{Deserialize, Serialize};
use std::str::from_utf8;

#[derive(Clone, Deserialize, Serialize, Debug)]
pub enum ApiErrorCode {
    Unknown,
    QueryPayloadError,
    PathError,
    NotFoundError,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct APIError {
    http_status: u16,
    error_code: ApiErrorCode,
    description: String,
}

impl Display for APIError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{:?}", self)
    }
}

impl APIError {
    pub fn new(http_status: StatusCode, error_code: ApiErrorCode, description: &str) -> Self {
        APIError {
            http_status: http_status.as_u16(),
            error_code: error_code,
            description: description.into(),
        }
    }
}

// Important: implement ResponseError to render as actix_web::Error
impl actix_web::ResponseError for APIError {
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
    let api_error = APIError {
        http_status: http_status.as_u16(),
        error_code: error_code,
        description: description,
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
            APIError::new(
                StatusCode::INTERNAL_SERVER_ERROR,
                ApiErrorCode::Unknown,
                "An error occurred",
            )
        })?;

        // Already handled error
        if let Some(_err) = error.as_error::<APIError>() {
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
    }

    // Unknown error, serialize the body content to json as an unknown error without changing the http status
    let status = res.response().status();
    let Ok(_body_bytes) = block_on(actix_web::body::to_bytes(res.into_body())) else {
        panic!("Error reading body");
    };
    let body_str = match from_utf8(&_body_bytes) {
        Ok(str) => str,
        Err(_) => "<no message>",
    };
    let mut error_code = ApiErrorCode::Unknown;
    if status == StatusCode::NOT_FOUND {
        error_code = ApiErrorCode::NotFoundError;
    }
    make_error_response(request, body_str.to_string(), error_code, status)
}
