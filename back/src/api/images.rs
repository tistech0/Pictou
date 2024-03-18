use crate::api::{
    image_not_found_example, json_payload_error_example, path_error_example,
    query_payload_error_example,
};
use crate::error_handler::ApiError;
use actix_multipart::Multipart;
use actix_web::{delete, get, http, patch, post, web, Error, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use utoipa::ToSchema;
use uuid::Uuid;

const CONTEXT_PATH: &str = "/images";

#[derive(Clone, Deserialize, Serialize, ToSchema)]
#[serde(rename_all = "snake_case")]
pub enum ImageQuality {
    Low,
    Medium,
    High,
}

#[allow(dead_code)]
#[derive(Deserialize)]
pub struct ImageQuery {
    quality: Option<ImageQuality>,
}

#[allow(dead_code)]
#[derive(Deserialize)]
pub struct ImagesQuery {
    limit: Option<u32>,
    offset: Option<u32>,
    quality: Option<ImageQuality>,
}

#[derive(Deserialize, Serialize, ToSchema)]
pub struct ImagePatch {
    name: Option<String>,
    tags: Option<Vec<String>>,
    shared_with: Option<Vec<String>>,
}

#[derive(Deserialize, Serialize, ToSchema)]
pub struct ImageMetaData {
    id: Uuid,
    owner_id: Uuid,
    caption: String,
    tags: Vec<String>,
    shared_with: Vec<String>,
    url: String,
}

#[derive(Deserialize, Serialize, ToSchema)]
pub struct ImagesMetaData {
    images: Vec<ImageMetaData>,
}

#[derive(Serialize, Deserialize, ToSchema)]
pub struct ImageUploadResponse {
    id: Uuid,
}

/// Get an image by its id.
#[allow(unused_variables)]
#[allow(unreachable_code)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = Uuid, Path, description="Identifier of the image", example="e58ed763-928c-4155-bee9-fdbaaadc15f3"),
        ("quality" = Option<ImageQuality>, Query, description="Image quality", example="Low")
    ),
    responses(
        (status = StatusCode::OK, description = "Image retrieved successfully", body = Binary, content_type = "image/jpeg"),
        (status = StatusCode::BAD_REQUEST, body = ApiError, examples(
            ("Invalid query parameters" = (value = json!(query_payload_error_example()))),
            ("Invalid path parameters" = (value = json!(path_error_example())))),
            content_type = "application/json"
        ),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
        (status = StatusCode::NOT_FOUND, description = "Image not found (or user is forbidden to see it)", body = ApiError, example = json!(image_not_found_example()), content_type = "application/json")
    ),
    tag="images"
)]
#[get("/{id}")]
pub async fn get_image(img_id: web::Path<Uuid>, query: web::Query<ImageQuery>) -> impl Responder {
    todo!("Implement get_image method.");
    HttpResponse::build(http::StatusCode::OK)
        .content_type("image/jpeg")
        .body(Vec::new())
}

/// Get the images owned by or shared with the user
///
/// This method returns the metadata of the images not the effective images. The client must make a request for each image independently.
/// The list can be filtered by quality, and paginated.
#[allow(unused_variables)]
#[allow(unreachable_code)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("limit" = Option<u32>, Query, description="Number of images to return", example=10),
        ("offset" = Option<u32>, Query, description="Offset of the query in the image list to return", example=0),
        ("quality" = Option<ImageQuality>, Query, description="Image quality", example="low")
    ),
    responses(
        (status = StatusCode::OK, description = "Images retrieved successfully", body = ImagesMetaData, content_type = "application/json"),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
        (status = StatusCode::BAD_REQUEST, description = "Invalid query parameters", body = ApiError, example=json!(query_payload_error_example()), content_type = "application/json"),
    ),
    tag="images"
)]
#[get("")]
pub async fn get_images(query: web::Query<ImagesQuery>) -> Result<impl Responder, Error> {
    todo!("Implement get_images method.");
    Ok(web::Json(ImagesMetaData { images: vec![] }))
}

/// Upload an image
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (status = StatusCode::OK, description = "Successfully uploaded", body = ImageUploadResponse),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json")
    ),
    tag="images",
    request_body(
        description = "File to upload (binary data)",
        content_type = "multipart/form-data",
        content = Binary
    )
)]
#[post("")]
pub async fn upload_image(payload: Multipart) -> impl Responder {
    todo!("Implement upload_image method.");
    HttpResponse::Ok().json(ImageUploadResponse {
        id: uuid::Uuid::new_v4(),
    })
}

/// Set/modfiy image metadata, share/unshare, ...
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = Uuid, Path, description="Image to edit", example="e58ed763-928c-4155-bee9-fdbaaadc15f3"),
    ),
    responses(
        (status = StatusCode::OK, description = "Successfully patched", body = ImageMetaData),
        (status = StatusCode::BAD_REQUEST, body = ApiError, examples(
            ("Invalid path parameters" = (value = json!(path_error_example()))),
            ("Invalid payload" = (value = json!(json_payload_error_example())))),
            content_type = "application/json"
        ),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
        (status = StatusCode::FORBIDDEN, description = "User has read only rights on the image (shared image)", body = ApiError, example = json!(ApiError::forbidden_error()), content_type = "application/json"),
        (status = StatusCode::NOT_FOUND, description = "Image not found (or user is forbidden to see it)", body = ApiError, example = json!(image_not_found_example()), content_type = "application/json")
    ),
    tag="images",
    request_body(
        description = "Image to edit",
        content_type = "application/json",
        content = ImagePatch
    )
)]
#[patch("/{id}")]
pub async fn edit_image(img_id: web::Path<Uuid>, patch: web::Json<ImagePatch>) -> impl Responder {
    todo!("Implement edit_image method.");
    HttpResponse::Ok().json(ImageMetaData {
        id: img_id.into_inner(),
        owner_id: Uuid::new_v4(),
        caption: "my_image".to_string(),
        tags: vec![],
        shared_with: vec![],
        url: "/images/1".to_string(),
    })
}

/// Delete an image
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = Uuid, Path, description="Image to delete", example="e58ed763-928c-4155-bee9-fdbaaadc15f3"),
    ),
    responses(
        (status = StatusCode::NO_CONTENT, description = "Successfully deleted"),
        (status = StatusCode::BAD_REQUEST, description = "Invalid path parameters", body = ApiError, example=json!(path_error_example()), content_type = "application/json"),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
        (status = StatusCode::FORBIDDEN, description = "User has read only rights on the image (shared image)", body = ApiError, example = json!(ApiError::forbidden_error()), content_type = "application/json"),
        (status = StatusCode::NOT_FOUND, description = "Image not found (or user is forbidden to see it)", body = ApiError, example = json!(image_not_found_example()), content_type = "application/json")
    ),
    tag="images"
)]
#[delete("/{id}")]
pub async fn delete_image(img_id: web::Path<Uuid>) -> impl Responder {
    todo!("Implement delete_image method.");
    HttpResponse::NoContent().finish()
}

pub fn configure(cfg: &mut web::ServiceConfig) {
    //define your methods here
    cfg.service(get_image)
        .service(get_images)
        .service(upload_image)
        .service(edit_image)
        .service(delete_image);
}
