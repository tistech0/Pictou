use crate::api::images::ImageMetaData;
use crate::api::{
    album_not_found_example, json_payload_error_example_missing_field, path_error_example,
    query_payload_error_example,
};
use crate::api::{json_payload_error_example, PaginationQuery};
use crate::auth::AuthContext;
use crate::error_handler::ApiError;
use actix_web::{delete, get, patch, post, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use utoipa::ToSchema;
use uuid::Uuid;

const CONTEXT_PATH: &str = "/albums";

#[derive(Deserialize, Serialize, ToSchema)]
pub struct AlbumPost {
    name: String,
    tags: Vec<String>,
    shared_with: Vec<String>,
    images: Vec<Uuid>,
}

#[derive(Deserialize, Serialize, ToSchema)]
pub struct Album {
    id: Uuid,
    owner_id: Uuid,
    name: String,
    tags: Vec<String>,
    shared_with: Vec<String>,
    images: Vec<ImageMetaData>,
}

#[derive(Deserialize, Serialize, ToSchema)]
pub struct AlbumList {
    albums: Vec<Album>,
}

/// Get an album by its id.
#[allow(unused_variables)]
#[allow(unreachable_code)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = Uuid, Path, description="Identifier of the album", example="e58ed763-928c-4155-bee9-fdbaaadc15f3")
    ),
    responses(
        (status = StatusCode::OK, description = "Album retrieved successfully", body = Album, content_type = "application/json"),
        (status = StatusCode::BAD_REQUEST, description = "Invalid path parameters", body = ApiError, example = json!(path_error_example()), content_type = "application/json"),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
        (status = StatusCode::NOT_FOUND, description = "Album not found (or user is forbidden to see it)", body = ApiError, example = json!(album_not_found_example()), content_type = "application/json")
    ),
    tag="albums",
    security(
        ("JWT Access Token" = [])
    )
)]
#[get("/{id}")]
pub async fn get_album(auth: AuthContext, album_uuid: web::Path<Uuid>) -> impl Responder {
    todo!("Implement get_album method.");
    HttpResponse::Ok().json(Album {
        id: album_uuid.into_inner(),
        owner_id: Uuid::new_v4(),
        name: "My Album".to_string(),
        tags: vec!["tag1".to_string(), "tag2".to_string()],
        shared_with: vec!["user1".to_string()],
        images: vec![],
    })
}

/// Get a list of albums
#[allow(unused_variables)]
#[allow(unreachable_code)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("limit" = Option<u32>, Query, description="Number of albums to return", example=10),
        ("offset" = Option<u32>, Query, description="Offset of the query in the albums list to return", example=0),
    ),
    responses(
        (status = StatusCode::OK, description = "Albums retrieved successfully", body = AlbumList, content_type = "application/json"),
        (status = StatusCode::BAD_REQUEST, description = "Invalid query parameters", body = ApiError, example=json!(query_payload_error_example()), content_type = "application/json"),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json")
    ),
    tag="albums",
    security(
        ("JWT Access Token" = [])
    )
)]
#[get("")]
pub async fn get_albums(auth: AuthContext, query: web::Query<PaginationQuery>) -> impl Responder {
    todo!("Implement get_albums method.");
    HttpResponse::Ok().json(AlbumList { albums: vec![] })
}

/// Create a new album
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (status = StatusCode::OK, description = "Successfully created", body = Album, content_type = "application/json"),
        (status = StatusCode::BAD_REQUEST, description = "Invalid request data", body = ApiError, example = json!(json_payload_error_example_missing_field()), content_type = "application/json"),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json")
    ),
    tag="albums",
    request_body(
        description = "Album to create",
        content_type = "application/json",
        content = AlbumPost
    ),
    security(
        ("JWT Access Token" = [])
    )
)]
#[post("")]
pub async fn create_album(auth: AuthContext, album: web::Json<AlbumPost>) -> impl Responder {
    todo!("Implement create_album method.");
    HttpResponse::Ok().json(Album {
        id: Uuid::new_v4(),
        owner_id: Uuid::new_v4(),
        name: "My Album".to_string(),
        tags: vec!["tag1".to_string(), "tag2".to_string()],
        shared_with: vec!["user1".to_string()],
        images: vec![],
    })
}

/// Modify an album
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = Uuid, Path, description="Album to edit", example="e58ed763-928c-4155-bee9-fdbaaadc15f3"),
    ),
    responses(
        (status = StatusCode::OK, description = "Successfully patched", body = Album),
        (status = StatusCode::BAD_REQUEST, body = ApiError, examples(
            ("Invalid path parameters" = (value = json!(path_error_example()))),
            ("Invalid payload" = (value = json!(json_payload_error_example())))),
            content_type = "application/json"
        ),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
        (status = StatusCode::FORBIDDEN, description = "User has read only rights on the album (shared album)", body = ApiError, example = json!(ApiError::forbidden_error()), content_type = "application/json"),
        (status = StatusCode::NOT_FOUND, description = "Album not found (or user is forbidden to see it)", body = ApiError, example = json!(album_not_found_example()), content_type = "application/json")
    ),
    tag="albums",
    request_body(
        description = "Album to edit",
        content_type = "application/json",
        content = AlbumPost
    ),
    security(
        ("JWT Access Token" = [])
    )
)]
#[patch("/{id}")]
pub async fn edit_album(
    auth: AuthContext,
    album_id: web::Path<Uuid>,
    patch: web::Json<AlbumPost>,
) -> impl Responder {
    todo!("Implement edit_album method.");
    HttpResponse::Ok().json(Album {
        id: album_id.into_inner(),
        owner_id: Uuid::new_v4(),
        name: "My Album".to_string(),
        tags: vec!["tag1".to_string(), "tag2".to_string()],
        shared_with: vec!["user1".to_string()],
        images: vec![],
    })
}

/// Delete an album
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = Uuid, Path, description="Album to delete", example="e58ed763-928c-4155-bee9-fdbaaadc15f3"),
    ),
    responses(
        (status = StatusCode::NO_CONTENT, description = "Successfully deleted"),
        (status = StatusCode::BAD_REQUEST, description = "Invalid path parameters", body = ApiError, example=json!(path_error_example()), content_type = "application/json"),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
        (status = StatusCode::FORBIDDEN, description = "User has read only rights on the album (shared album)", body = ApiError, example = json!(ApiError::forbidden_error()), content_type = "application/json"),
        (status = StatusCode::NOT_FOUND, description = "Album not found (or user is forbidden to see it)", body = ApiError, example = json!(album_not_found_example()), content_type = "application/json")
    ),
    tag="albums",
    security(
        ("JWT Access Token" = [])
    )
)]
#[delete("/{id}")]
pub async fn delete_album(auth: AuthContext, album_id: web::Path<Uuid>) -> impl Responder {
    todo!("Implement delete_album method.");
    HttpResponse::NoContent().finish()
}

/// Add an image to an album
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = Uuid, Path, description="Album to add the image to", example="e58ed763-928c-4155-bee9-fdbaaadc15f3"),
        ("image_id" = Uuid, Path, description="Image to add", example="e58ed763-928c-4155-bee9-fdbaaadc15f3"),
    ),
    responses(
        (status = StatusCode::OK, description = "Successfully added", body = Album, content_type = "application/json"),
        (status = StatusCode::BAD_REQUEST, description = "Invalid path parameters", body = ApiError, example =json!(path_error_example()), content_type = "application/json"),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
        (status = StatusCode::FORBIDDEN, description = "User has read only rights on the image/album (shared image/album)", body = ApiError, example = json!(ApiError::forbidden_error()), content_type = "application/json"),
        (status = StatusCode::NOT_FOUND, description = "Album or image not found (or user is forbidden to see it)", body = ApiError, example = json!(album_not_found_example()), content_type = "application/json")
    ),
    tag="albums",
    security(
        ("JWT Access Token" = [])
    )
)]
#[post("/{id}/images/{image_id}")]
pub async fn add_image_to_album(
    auth: AuthContext,
    path: web::Path<(Uuid, Uuid)>,
) -> impl Responder {
    todo!("Implement add_image_to_album method.");
    HttpResponse::Ok().json(Album {
        id: path.0,
        owner_id: Uuid::new_v4(),
        name: "My Album".to_string(),
        tags: vec!["tag1".to_string(), "tag2".to_string()],
        shared_with: vec!["user1".to_string()],
        images: vec![],
    })
}

/// Remove an image from an album
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = Uuid, Path, description="Album to remove the image from", example="e58ed763-928c-4155-bee9-fdbaaadc15f3"),
        ("image_id" = Uuid, Path, description="Image to remove", example="e58ed763-928c-4155-bee9-fdbaaadc15f3"),
    ),
    responses(
        (status = StatusCode::OK, description = "Successfully added", body = Album, content_type = "application/json"),
        (status = StatusCode::BAD_REQUEST, description = "Invalid path parameters", body = ApiError, example =json!(path_error_example()), content_type = "application/json"),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
        (status = StatusCode::FORBIDDEN, description = "User has read only rights on the image/album (shared image/album)", body = ApiError, example = json!(ApiError::forbidden_error()), content_type = "application/json"),
        (status = StatusCode::NOT_FOUND, description = "Album or image not found (or user is forbidden to see it)", body = ApiError, example = json!(album_not_found_example()), content_type = "application/json")
    ),
    tag="albums",
    security(
        ("JWT Access Token" = [])
    )
)]
#[delete("/{id}/images/{image_id}")]
pub async fn remove_image_from_album(
    auth: AuthContext,
    path: web::Path<(Uuid, Uuid)>,
) -> impl Responder {
    todo!("Implement remove_image_from_album method.");
    HttpResponse::Ok().json(Album {
        id: path.0,
        owner_id: Uuid::new_v4(),
        name: "My Album".to_string(),
        tags: vec!["tag1".to_string(), "tag2".to_string()],
        shared_with: vec!["user1".to_string()],
        images: vec![],
    })
}

pub fn configure(cfg: &mut web::ServiceConfig) {
    //define your methods here
    cfg.service(get_album)
        .service(get_albums)
        .service(create_album)
        .service(edit_album)
        .service(delete_album)
        .service(add_image_to_album)
        .service(remove_image_from_album);
}
