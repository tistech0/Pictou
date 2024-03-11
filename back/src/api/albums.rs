use crate::api::images::ImageMetaData;
use actix_web::{delete, get, patch, post, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use utoipa::ToSchema;

const CONTEXT_PATH: &str = "/albums";

#[allow(dead_code)]
#[derive(Deserialize)]
pub struct PaginationQuery {
    limit: Option<i32>,
    offset: Option<i32>,
}

#[derive(Deserialize, Serialize, ToSchema)]
pub struct AlbumPost {
    name: String,
    tags: Vec<String>,
    shared_with: Vec<String>,
    images: Vec<u32>,
}

#[derive(Deserialize, Serialize, ToSchema)]
pub struct Album {
    id: u32,
    owner_id: u32,
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
        ("id" = u16, Path, description="Identifier of the album", example=1)
    ),
    responses(
        (status = 200, description = "Album retrieved successfully", body = Album, content_type = "application/json")
    ),
    tag="albums"
)]
#[get("/{id}")]
pub async fn get_album(album_id: web::Path<u16>) -> impl Responder {
    todo!("Implement get_album method.");
    HttpResponse::Ok().json(Album {
        id: 1,
        owner_id: 1,
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
        ("limit" = Option<u16>, Query, description="Number of albums to return", example=10),
        ("offset" = Option<u16>, Query, description="Offset of the query in the albums list to return", example=0),
    ),
    responses(
        (status = 200, description = "Albums retrieved successfully", body = AlbumList, content_type = "application/json")
    ),
    tag="albums"
)]
#[get("")]
pub async fn get_albums(query: web::Query<PaginationQuery>) -> impl Responder {
    todo!("Implement get_albums method.");
    HttpResponse::Ok().json(AlbumList { albums: vec![] })
}

/// Create a new album
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (status = 200, description = "Successfully created", body = Album, content_type = "application/json")
    ),
    tag="albums",
    request_body(
        description = "Album to create",
        content_type = "application/json",
        content = AlbumPost
    )
)]
#[post("")]
pub async fn create_album(album: web::Json<AlbumPost>) -> impl Responder {
    todo!("Implement create_album method.");
    HttpResponse::Ok().json(Album {
        id: 1,
        owner_id: 1,
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
        ("id" = u16, Path, description="Album to edit", example=1),
    ),
    responses(
        (status = 200, description = "Successfully patched", body = Album)
    ),
    tag="albums",
    request_body(
        description = "Album to edit",
        content_type = "application/json",
        content = AlbumPost
    )
)]
#[patch("/{id}")]
pub async fn edit_album(album_id: web::Path<u16>, patch: web::Json<AlbumPost>) -> impl Responder {
    todo!("Implement edit_album method.");
    HttpResponse::Ok().json(Album {
        id: 1,
        owner_id: 1,
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
        ("id" = u16, Path, description="Album to delete", example=1),
    ),
    responses(
        (status = 204, description = "Successfully deleted")
    ),
    tag="albums"
)]
#[delete("/{id}")]
pub async fn delete_album(album_id: web::Path<u16>) -> impl Responder {
    todo!("Implement delete_album method.");
    HttpResponse::NoContent().finish()
}

/// Add an image to an album
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = u16, Path, description="Album to add the image to", example=1),
        ("image_id" = u16, Path, description="Image to add", example=1),
    ),
    responses(
        (status = 200, description = "Successfully added", body = Album, content_type = "application/json")
    ),
    tag="albums"
)]
#[post("/{id}/images/{image_id}")]
pub async fn add_image_to_album(path: web::Path<(u16, u16)>) -> impl Responder {
    todo!("Implement add_image_to_album method.");
    HttpResponse::Ok().json(Album {
        id: 1,
        owner_id: 1,
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
        ("id" = u16, Path, description="Album to remove the image from", example=1),
        ("image_id" = u16, Path, description="Image to remove", example=1),
    ),
    responses(
        (status = 200, description = "Successfully removed", body = Album, content_type = "application/json")
    ),
    tag="albums"
)]
#[delete("/{id}/images/{image_id}")]
pub async fn remove_image_from_album(path: web::Path<(u16, u16)>) -> impl Responder {
    todo!("Implement remove_image_from_album method.");
    HttpResponse::Ok().json(Album {
        id: 1,
        owner_id: 1,
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
