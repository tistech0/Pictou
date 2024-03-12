pub mod albums;
pub mod images;
pub mod users;
use actix_web::web;
use serde::Deserialize;
use utoipa::{schema, ToSchema};

use crate::error_handler::APIError;

#[allow(dead_code)]
#[derive(Deserialize)]
pub struct PaginationQuery {
    limit: Option<i32>,
    offset: Option<i32>,
}

pub fn query_payload_error_example() -> APIError {
    APIError::query_payload_error(
        "Query deserialize error: Unknown variant `lo`, expected one of `Low`, `Medium`, `High`",
    )
}

pub fn json_payload_error_example() -> APIError {
    APIError::json_payload_error(
        "Json deserialize error: EOF while parsing an object at line 4 column 0",
    )
}

pub fn json_payload_error_example_missing_field() -> APIError {
    APIError::json_payload_error("Json deserialize error:  missing field `name` at line 4 column 1")
}

pub fn path_error_example() -> APIError {
    APIError::path_error("Path deserialize error: can not parse \"a\" to a u16")
}

pub fn image_not_found_example() -> APIError {
    APIError::not_found_error("Image with id 15")
}

pub fn album_not_found_example() -> APIError {
    APIError::not_found_error("Album with id 15")
}

#[derive(ToSchema)]
#[schema(value_type = String, format = Binary)]
pub struct Binary(String);

pub fn configure(cfg: &mut web::ServiceConfig) {
    //define your methods here
    cfg.service(web::scope("/images").configure(images::configure))
        .service(web::scope("/albums").configure(albums::configure))
        .service(web::scope("/users").configure(users::configure));
}
