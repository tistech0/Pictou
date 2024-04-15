use std::error::Error as StdError;

use crate::{
    api::json_payload_error_example,
    auth::AuthContext,
    database::{self, Database, DatabaseError},
    error_handler::ApiError,
    storage::{ImageHash, ImageStorage},
};
use actix_web::{delete, get, patch, web, HttpResponse, Responder};
use diesel::{AsChangeset, Queryable, Selectable};
use futures::future;
use serde::{Deserialize, Serialize};
use tracing::{debug, error, info, trace};
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
    let user_id = auth.user_id;

    let user: User = database::open(db, move |conn| {
        use crate::schema::users;
        use diesel::prelude::*;

        users::table
            .filter(users::id.eq(user_id))
            .select(User::as_returning())
            .get_result::<User>(conn)
            .map_err(DatabaseError::<ApiError>::from)
    })
    .await
    .map_err(|error| {
        error!(error  = &error as &dyn StdError, %user_id, "failed to fetch user");
        ApiError::from(error)
    })?;

    trace!(%user_id, "successfully fetched user");
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
    let user_id = auth.user_id;

    let user: User = database::open(db, move |conn| {
        use crate::schema::users;
        use diesel::prelude::*;

        // Updating nothing is not an error
        if patch != EMPTY_USER_PATCH {
            diesel::update(users::table)
                .set(patch)
                .filter(users::id.eq(user_id))
                .returning(User::as_returning())
                .get_result::<User>(conn)
                .map_err(DatabaseError::<ApiError>::from)
        } else {
            users::table
                .filter(users::id.eq(user_id))
                .select(User::as_returning())
                .get_result::<User>(conn)
                .map_err(DatabaseError::<ApiError>::from)
        }
    })
    .await
    .map_err(|error| {
        error!(error  = &error as &dyn StdError, %user_id, "failed to update user");
        ApiError::from(error)
    })?;

    debug!(%user_id, "successfully updated user");
    Ok(HttpResponse::Ok().json(user))
}

/// Delete the user account
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (
            status = StautsCode::NO_CONTENT,
            description = "Successfully deleted"
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
#[delete("/self")]
#[tracing::instrument(skip_all)]
pub async fn delete_user(
    auth: AuthContext,
    db: web::Data<Database>,
    storage: web::Data<dyn ImageStorage>,
) -> Result<impl Responder, ApiError> {
    let user_id = auth.user_id;

    let images_to_delete: Vec<ImageHash> = database::open(db, move |conn| {
        use crate::schema::{stored_images, user_images, users};
        use diesel::prelude::*;

        diesel::delete(users::table)
            .filter(users::id.eq(user_id))
            .execute(conn)
            .map_err(DatabaseError::<ApiError>::from)?;

        stored_images::table
            .left_outer_join(user_images::table.on(stored_images::hash.eq(user_images::image_id)))
            .filter(user_images::user_id.is_null())
            .select(stored_images::hash)
            .get_results::<ImageHash>(conn)
            .map_err(DatabaseError::<ApiError>::from)
    })
    .await
    .map_err(|error| {
        error!(error = &error as &dyn StdError, %user_id, "failed to delete user");
        ApiError::from(error)
    })?;

    info!("removing {} images from storage", images_to_delete.len());
    future::join_all(images_to_delete.iter().map(|hash| {
        let storage = storage.clone();
        async move {
            if let Err(error) = storage.delete_all_kinds(*hash).await {
                error!(error = &error as &dyn StdError, %hash, "failed to delete stored image");
            }
        }
    }))
    .await;

    info!(%user_id, "successfully deleted user");
    Ok(HttpResponse::NoContent().finish())
}

pub fn configure(cfg: &mut web::ServiceConfig) {
    //define your methods here
    cfg.service(get_self)
        .service(edit_self)
        .service(delete_user);
}
