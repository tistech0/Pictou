use actix_web::{get, http, post, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use utoipa::ToSchema;

const CONTEXT_PATH: &str = "/images/";

#[derive(Clone, Deserialize, Serialize, ToSchema)]
pub enum ImageQuality {
    Low,
    Medium,
    High,
}

#[derive(Deserialize)]
struct ImageQuery {
    limit: Option<i32>,
    offset: Option<i32>,
    quality: Option<ImageQuality>,
}

/// Get an image by its id.
///
///
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = u16, Path, description="Identifier of the image", example=1),
        ("limit" = Option<u16>, Query, description="Number of images to return", example=10),
        ("offset" = Option<u16>, Query, description="Offset of the query in the image list to return", example=0),
        ("quality" = Option<ImageQuality>, Query, description="Image quality", example="Low")
    ),
    responses(
        (status = 200, description = "Image retrieved successfully", body = String, content_type = "image/jpeg")
    ),
    tag="images"
)]
#[get("{id}")]
pub async fn get_image(img_id: web::Path<u16>, query: web::Query<ImageQuery>) -> impl Responder {
    !todo!("Implement get_image method.");
    HttpResponse::build(http::StatusCode::OK)
        .content_type("image/jpeg")
        .body(Vec::new())
}


pub fn configure(cfg: &mut web::ServiceConfig) {
    //define your methods here
    cfg.service(get_image);
}
