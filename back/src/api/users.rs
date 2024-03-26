use crate::{
    api::json_payload_error_example,
    auth::AuthContext,
    database::{self, Database, DatabaseError},
    error_handler::ApiError,
};
use actix_web::{delete, get, patch, web, HttpResponse, Responder};
use diesel::{AsChangeset, Queryable, Selectable};
use serde::{Deserialize, Serialize};
use utoipa::ToSchema;
use uuid::Uuid;

const CONTEXT_PATH: &str = "/users";

#[derive(Deserialize, Serialize, ToSchema, Queryable, Selectable)]
#[diesel(table_name = crate::schema::users)]
pub struct User {
    id: Uuid,
    email: String,
    name: Option<String>,
    given_name: Option<String>,
    family_name: Option<String>,
}

#[derive(Deserialize, Serialize, ToSchema, AsChangeset, PartialEq, Eq)]
#[diesel(table_name = crate::schema::users)]
pub struct UserPatch {
    name: Option<String>,
    given_name: Option<String>,
    family_name: Option<String>,
}

const EMPTY_USER_PATCH: UserPatch = UserPatch {
    name: None,
    given_name: None,
    family_name: None,
};

/// Get user (self) properties
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (
            status = StatusCode::OK,
            description = "User's properties retrieved successfully",
            body = User,
            content_type = "application/json"
        ),
        (
            status = StatusCode::UNAUTHORIZED,
            description = "User not authenticated",
            body = ApiError,
            example = json!(ApiError::unauthorized_error()),
            content_type = "application/json"
        ),
    ),
    tag = "users",
    security(
        ("JWT Access Token" = [])
    )
)]
#[get("/self")]
pub async fn get_self(
    auth: AuthContext,
    db: web::Data<Database>,
) -> Result<HttpResponse, ApiError> {
    let user: User = database::open(db, move |conn| {
        use crate::schema::users;
        use diesel::prelude::*;

        users::table
            .filter(users::id.eq(auth.user_id))
            .select(User::as_returning())
            .get_result::<User>(conn)
            .map_err(DatabaseError::<ApiError>::from)
    })
    .await
    .map_err(ApiError::from)?;

    Ok(HttpResponse::Ok().json(user))
}

/// Modify user (self) properties
#[allow(unreachable_code)]
#[allow(unused_variables)]
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (
            status = StatusCode::OK,
            description = "Successfully patched",
            body = User
        ),
        (
            status = StatusCode::BAD_REQUEST,
            description = "Invalid request data",
            body = ApiError,
            example = json!(json_payload_error_example()),
            content_type = "application/json"
        ),
        (
            status = StatusCode::UNAUTHORIZED,
            description = "User not authenticated",
            body = ApiError,
            example = json!(ApiError::unauthorized_error()),
            content_type = "application/json"
        ),
    ),
    tag = "users",
    request_body(
        description = "User to edit",
        content_type = "application/json",
        content = UserPatch
    ),
    security(
        ("JWT Access Token" = [])
    )
)]
#[patch("/self")]
pub async fn edit_self(
    auth: AuthContext,
    patch: web::Json<UserPatch>,
    db: web::Data<Database>,
) -> Result<impl Responder, ApiError> {
    let patch = patch.into_inner();

    let user: User = database::open(db, move |conn| {
        use crate::schema::users;
        use diesel::prelude::*;

        // Updating nothing is not an error
        if patch != EMPTY_USER_PATCH {
            diesel::update(users::table)
                .set(patch)
                .filter(users::id.eq(auth.user_id))
                .returning(User::as_returning())
                .get_result::<User>(conn)
                .map_err(DatabaseError::<ApiError>::from)
        } else {
            users::table
                .filter(users::id.eq(auth.user_id))
                .select(User::as_returning())
                .get_result::<User>(conn)
                .map_err(DatabaseError::<ApiError>::from)
        }
    })
    .await
    .map_err(ApiError::from)?;

    Ok(HttpResponse::Ok().json(user))
}

/// Delete the user account
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (status = StautsCode::NO_CONTENT, description = "Successfully deleted"),
        (status = StatusCode::UNAUTHORIZED, description = "User not authenticated", body = ApiError, example = json!(ApiError::unauthorized_error()), content_type = "application/json"),
    ),
    tag = "users",
    security(
        ("JWT Access Token" = [])
    )
)]
#[delete("/self")]
pub async fn delete_user(auth: AuthContext, db: web::Data<Database>) -> impl Responder {
    todo!("Implement delete_user method.");
    HttpResponse::NoContent().finish()
}

pub fn configure(cfg: &mut web::ServiceConfig) {
    //define your methods here
    cfg.service(get_self)
        .service(edit_self)
        .service(delete_user);
}
