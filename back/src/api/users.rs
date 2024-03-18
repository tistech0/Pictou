use crate::{api::json_payload_error_example, auth::AuthContext, error_handler::ApiError};
use actix_web::{delete, get, patch, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use utoipa::ToSchema;
use uuid::Uuid;

const CONTEXT_PATH: &str = "/users";

#[derive(Deserialize, Serialize, ToSchema)]
pub struct UserPost {
    name: String,
}

#[derive(Deserialize, Serialize, ToSchema)]
pub struct User {
    id: Uuid,
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
        (status = StatusCode::OK, description = "User's properties retrieved successfully", body = User, content_type = "application/json"),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
    ),
    tag="users",
    security(
        ("JWT Access Token" = [])
    )
)]
#[get("/self")]
pub async fn get_self(auth: AuthContext) -> impl Responder {
    todo!("Implement get_self method.");
    HttpResponse::Ok().json(User {
        id: Uuid::new_v4(),
        name: "John Doe".to_string(),
    })
}

/// Get a list of users
#[allow(unused_variables)]
#[allow(unreachable_code)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (status = StatusCode::OK, description = "Users retrieved successfully", body = UserList, content_type = "application/json"),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
    ),
    tag="users",
    security(
        ("JWT Access Token" = [])
    )
)]
#[get("")]
pub async fn get_users(auth: AuthContext) -> impl Responder {
    todo!("Implement get_users method.");
    HttpResponse::Ok().json(UserList { users: vec![] })
}

/// Modify user (self) properties
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (status = StatusCode::OK, description = "Successfully patched", body = User),
        (status = StatusCode::BAD_REQUEST, description = "Invalid request data", body = ApiError, example = json!(json_payload_error_example()), content_type = "application/json"),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
    ),
    tag="users",
    request_body(
        description = "User to edit",
        content_type = "application/json",
        content = UserPost
    ),
    security(
        ("JWT Access Token" = [])
    )
)]
#[patch("/self")]
pub async fn edit_self(auth: AuthContext, patch: web::Json<UserPost>) -> impl Responder {
    todo!("Implement edit_self method.");
    HttpResponse::Ok().json(User {
        id: Uuid::new_v4(),
        name: "John Doe".to_string(),
    })
}

/// Delete the user account
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        ("id" = Uuid, Path, description="User to delete", example="e58ed763-928c-4155-bee9-fdbaaadc15f3"),
    ),
    responses(
        (status = StautsCode::NO_CONTENT, description = "Successfully deleted"),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
    ),
    tag="users",
    security(
        ("JWT Access Token" = [])
    )
)]
#[delete("/self")]
pub async fn delete_user(auth: AuthContext) -> impl Responder {
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
