use actix_multipart::Multipart;
use actix_web::{delete, get, http, patch, post, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use utoipa::{schema, ToSchema};

const CONTEXT_PATH: &str = "/images";

#[derive(Clone, Deserialize, Serialize, ToSchema)]
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
    limit: Option<i32>,
    offset: Option<i32>,
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
    id: u32,
    owner_id: u32,
    name: String,
    tags: Vec<String>,
    shared_with: Vec<String>,
    url: String,
}

#[derive(Deserialize, Serialize, ToSchema)]
pub struct ImagesMetaData {
    images: Vec<ImageMetaData>,
}

#[derive(ToSchema)]
#[schema(value_type = String, format = Binary)]
pub struct Binary(String);

#[derive(Serialize, Deserialize, ToSchema)]
pub struct ImageUploadResponse {
    id: u32,
}

/// Get an image by its id.
#[allow(unused_variables)]
#[allow(unreachable_code)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = u16, Path, description="Identifier of the image", example=1),
        ("quality" = Option<ImageQuality>, Query, description="Image quality", example="Low")
    ),
    responses(
        (status = 200, description = "Image retrieved successfully", body = Binary, content_type = "image/jpeg")
    ),
    tag="images"
)]
#[get("/{id}")]
pub async fn get_image(img_id: web::Path<u16>, query: web::Query<ImageQuery>) -> impl Responder {
    todo!("Implement get_image method.");
    HttpResponse::build(http::StatusCode::OK)
        .content_type("image/jpeg")
        .body(Vec::new())
}

/// Get a list of images (metadata and url to download the image)
#[allow(unused_variables)]
#[allow(unreachable_code)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("limit" = Option<u16>, Query, description="Number of images to return", example=10),
        ("offset" = Option<u16>, Query, description="Offset of the query in the image list to return", example=0),
        ("quality" = Option<ImageQuality>, Query, description="Image quality", example="Low")
    ),
    responses(
        (status = 200, description = "Images retrieved successfully", body = ImagesMetaData, content_type = "application/json")
    ),
    tag="images"
)]
#[get("")]
pub async fn get_images(query: web::Query<ImagesQuery>) -> impl Responder {
    todo!("Implement get_images method.");
    HttpResponse::Ok().json(ImagesMetaData { images: vec![] })
}

/// Upload an image
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (status = 200, description = "Successfully uploaded", body = ImageUploadResponse)
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
    HttpResponse::Ok().json(ImageUploadResponse { id: 1 })
}

/// Set/modfiy image metadata, share/unshare, ...
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = u16, Path, description="Image to edit", example=1),
    ),
    responses(
        (status = 200, description = "Successfully patched", body = ImageMetaData)
    ),
    tag="images",
    request_body(
        description = "Image to edit",
        content_type = "application/json",
        content = ImagePatch
    )
)]
#[patch("/{id}")]
pub async fn edit_image(img_id: web::Path<u16>, patch: web::Json<ImagePatch>) -> impl Responder {
    todo!("Implement edit_image method.");
    HttpResponse::Ok().json(ImageMetaData {
        id: 1,
        owner_id: 1,
        name: "my_image".to_string(),
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
        ("id" = u16, Path, description="Image to delete", example=1),
    ),
    responses(
        (status = 2004, description = "Successfully deleted")
    ),
    tag="images"
)]
#[delete("/{id}")]
pub async fn delete_image(img_id: web::Path<u16>) -> impl Responder {
    // todo!("Implement delete_image method.");
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
