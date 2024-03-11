use actix_web::{delete, get, patch, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use utoipa::ToSchema;

const CONTEXT_PATH: &str = "/users";

#[derive(Deserialize, Serialize, ToSchema)]
pub struct UserPost {
    name: String,
}

#[derive(Deserialize, Serialize, ToSchema)]
pub struct User {
    id: u32,
    name: String,
}

#[derive(Deserialize, Serialize, ToSchema)]
pub struct UserList {
    users: Vec<User>,
}

/// Get user (self) properties
#[allow(unused_variables)]
#[allow(unreachable_code)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (status = 200, description = "User's properties retrieved successfully", body = User, content_type = "application/json")
    ),
    tag="users"
)]
#[get("/self")]
pub async fn get_self() -> impl Responder {
    todo!("Implement get_self method.");
    HttpResponse::Ok().json(User {
        id: 1,
        name: "John Doe".to_string(),
    })
}

/// Get a list of users
#[allow(unused_variables)]
#[allow(unreachable_code)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (status = 200, description = "Users retrieved successfully", body = UserList, content_type = "application/json")
    ),
    tag="users"
)]
#[get("")]
pub async fn get_users() -> impl Responder {
    todo!("Implement get_users method.");
    HttpResponse::Ok().json(UserList { users: vec![] })
}

/// Modify user (self) properties
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (status = 200, description = "Successfully patched", body = User)
    ),
    tag="users",
    request_body(
        description = "User to edit",
        content_type = "application/json",
        content = UserPost
    )
)]
#[patch("/self")]
pub async fn edit_self(patch: web::Json<UserPost>) -> impl Responder {
    todo!("Implement edit_self method.");
    HttpResponse::Ok().json(User {
        id: 1,
        name: "John Doe".to_string(),
    })
}

/// Delete a user
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = u16, Path, description="User to delete", example=1),
    ),
    responses(
        (status = 204, description = "Successfully deleted")
    ),
    tag="users"
)]
#[delete("/{id}")]
pub async fn delete_user(album_id: web::Path<u16>) -> impl Responder {
    todo!("Implement delete_user method.");
    HttpResponse::NoContent().finish()
}

pub fn configure(cfg: &mut web::ServiceConfig) {
    //define your methods here
    cfg.service(get_self)
        .service(edit_self)
        .service(get_users)
        .service(delete_user);
}
