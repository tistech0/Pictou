pub mod albums;
pub mod images;
pub mod users;
use actix_web::web;
use serde::Deserialize;
use utoipa::{schema, ToSchema};

use crate::error_handler::ApiError;

#[allow(dead_code)]
#[derive(Deserialize)]
pub struct PaginationQuery {
    limit: Option<i32>,
    offset: Option<i32>,
}

pub fn query_payload_error_example() -> ApiError {
    ApiError::query_payload_error(
        "Query deserialize error: Unknown variant `lo`, expected one of `low`, `medium`, `high`",
    )
}

pub fn json_payload_error_example() -> ApiError {
    ApiError::json_payload_error(
        "Json deserialize error: EOF while parsing an object at line 4 column 0",
    )
}

pub fn json_payload_error_example_missing_field() -> ApiError {
    ApiError::json_payload_error("Json deserialize error:  missing field `name` at line 4 column 1")
}

pub fn path_error_example() -> ApiError {
    ApiError::path_error("Path deserialize error: can not parse \"a\" to a u16")
}

pub fn image_not_found_example() -> ApiError {
    ApiError::not_found_error("Image with id 15")
}

pub fn album_not_found_example() -> ApiError {
    ApiError::not_found_error("Album with id 15")
}

pub fn image_payload_too_large_example() -> ApiError {
    ApiError::image_too_big(10_000_000)
}

#[derive(ToSchema)]
#[schema(value_type = String, format = Binary)]
pub struct Binary(#[allow(dead_code)] String);

#[repr(transparent)]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct OpenapiUuid(::uuid::Uuid);

impl<'__s> utoipa::ToSchema<'__s> for OpenapiUuid {
    fn schema() -> (
        &'__s str,
        utoipa::openapi::RefOr<utoipa::openapi::schema::Schema>,
    ) {
        (
            "Uuid",
            utoipa::openapi::ObjectBuilder::new()
                .schema_type(utoipa::openapi::SchemaType::String)
                .format(Some(utoipa::openapi::SchemaFormat::Custom(
                    "Uuid".to_string(),
                )))
                .min_length(Some(36))
                .max_length(Some(36))
                .pattern(Some(
                    "^[0-9(a-f|A-F)]{8}-[0-9(a-f|A-F)]{4}-4[0-9(a-f|A-F)]{3}-[89ab][0-9(a-f|A-F)]{3}-[0-9(a-f|A-F)]{12}$",
                ))
                .example(Some(serde_json::value::Value::String(
                    "e58ed763-928c-4155-bee9-fdbaaadc15f3".to_string(),
                )))
                .into(),
        )
    }
}

pub fn configure(cfg: &mut web::ServiceConfig) {
    //define your methods here
    cfg.service(web::scope("/images").configure(images::configure))
        .service(web::scope("/albums").configure(albums::configure))
        .service(web::scope("/users").configure(users::configure));
}
