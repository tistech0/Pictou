use crate::api::images::ImageMetaData;
use crate::api::json_payload_error_example;
use crate::api::{
    album_not_found_example, json_payload_error_example_missing_field, path_error_example,
    process_tags, query_payload_error_example,
};
use crate::auth::AuthContext;
use crate::config::AppConfiguration;
use crate::database::{self, Database, DatabaseError, SimpleDatabaseError};
use crate::error_handler::ApiError;
use actix_web::{delete, get, patch, post, web, HttpResponse, Result as ActixResult};
use diesel::{AsChangeset, Insertable};
use serde::{Deserialize, Serialize};
use tracing::info;
use utoipa::ToSchema;
use uuid::Uuid;

const CONTEXT_PATH: &str = "/albums";

#[derive(Deserialize, Serialize, ToSchema)]
pub struct AlbumPost {
    name: String,
    tags: Vec<String>,
}

#[derive(Deserialize, Serialize, ToSchema, AsChangeset, PartialEq, Eq)]
#[diesel(table_name = crate::schema::albums)]
pub struct AlbumPatch {
    name: Option<String>,
    tags: Option<Vec<String>>,
}

const EMPTY_ALBUM_PATCH: AlbumPatch = AlbumPatch {
    name: None,
    tags: None,
};

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

#[derive(Debug, Insertable)]
#[diesel(table_name = crate::schema::albums)]
struct NewAlbum {
    owner_id: Uuid,
    name: String,
    tags: Vec<String>,
}

#[derive(Deserialize)]
pub struct AlbumsQuery {
    limit: Option<u32>,
    offset: Option<u32>,
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
pub async fn get_album(
    auth: AuthContext,
    album_id: web::Path<Uuid>,
    db: web::Data<Database>,
) -> ActixResult<HttpResponse> {
    // Corresponds to the following SQL:
    /*SELECT
      albums.id,
      albums.owner_id,
      albums.name,
      albums.tags,
      array_agg(users.email) AS shared_with,
      user_images.id,
      user_images.user_id    AS owner_id,
      user_images.caption,
      user_images.tags
    FROM public.albums
      LEFT JOIN public.shared_albums ON shared_albums.album_id = albums.id
      LEFT JOIN public.users ON users.id = shared_albums.user_id
      LEFT JOIN public.album_images ON album_images.album_id = albums.id
      LEFT JOIN public.user_images ON user_images.id = album_images.image_id
    WHERE
      albums.id = '5761efa1-cd8d-445e-a53c-ea6c824a8b77'
    GROUP BY
      albums.id,
      user_images.id */

    let album = database::open(db, move |conn| {
        use crate::schema::{album_images, albums, shared_albums, user_images, users};
        use diesel::prelude::*;

        // Get the album meta data
        let (id, owner_id, name, tags): (Uuid, Uuid, String, Vec<Option<String>>) = albums::table
            .select((albums::id, albums::owner_id, albums::name, albums::tags))
            .filter(albums::id.eq(album_id.clone()))
            .get_result(conn)
            .optional()
            .map_err(SimpleDatabaseError::from)?
            .expect("Album not found");

        // Get the list of users the album is shared with
        let shared_with = users::table
            .inner_join(shared_albums::table.on(shared_albums::user_id.eq(users::id)))
            .select(users::email)
            .filter(shared_albums::album_id.eq(album_id.clone()))
            .load::<String>(conn)
            .map_err(SimpleDatabaseError::from)?;

        // Get the list of images on the album
        let images = user_images::table
            .left_outer_join(album_images::table)
            .left_outer_join(
                shared_albums::table.on(album_images::album_id.eq(shared_albums::album_id)),
            )
            .left_outer_join(users::table.on(shared_albums::user_id.eq(users::id)))
            .group_by(user_images::id)
            .select((
                user_images::id,
                user_images::user_id,
                user_images::caption,
                user_images::tags,
                crate::database::array_agg(users::email.nullable()),
            ))
            .filter(album_images::album_id.eq(album_id.clone()))
            .load::<ImageMetaData>(conn)
            .map_err(SimpleDatabaseError::from)?;

        // Create the album object
        let album = Album {
            id,
            owner_id,
            name,
            tags: tags.into_iter().filter_map(|t| t).collect(),
            shared_with,
            images,
        };
        Ok(album)
    })
    .await?;
    Ok(HttpResponse::Ok().json(album))
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
pub async fn get_albums(
    auth: AuthContext,
    query: web::Query<AlbumsQuery>,
    app_cfg: web::Data<AppConfiguration>,
    db: web::Data<Database>,
) -> ActixResult<HttpResponse> {
    let limit = query
        .limit
        .unwrap_or(app_cfg.albums_query_default_limit)
        .min(app_cfg.albums_query_max_limit);
    let offset = query.offset.unwrap_or(0);

    let albums = database::open(db, move |conn| {
        use crate::schema::{albums, shared_albums};
        use diesel::prelude::*;

        // Get the list of albums
        let albums = albums::table
            .select((albums::id, albums::owner_id, albums::name, albums::tags))
            .left_join(shared_albums::table.on(shared_albums::user_id.eq(auth.user_id)))
            .filter(
                albums::owner_id
                    .eq(auth.user_id)
                    .or(shared_albums::user_id.eq(auth.user_id)),
            )
            .offset(offset as i64)
            .limit(limit as i64)
            .load::<(Uuid, Uuid, String, Vec<Option<String>>)>(conn)
            .map_err(SimpleDatabaseError::from)?;

        // Return the list of albums
        Ok(albums
            .into_iter()
            .map(|(id, owner_id, name, tags)| Album {
                id,
                owner_id,
                name,
                tags: tags.into_iter().filter_map(|t| t).collect(),
                shared_with: vec![],
                images: vec![],
            })
            .collect::<Vec<Album>>())
    })
    .await?;

    Ok(HttpResponse::Ok().json(AlbumList { albums }))
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
pub async fn create_album(
    auth: AuthContext,
    album: web::Json<AlbumPost>,
    db: web::Data<Database>,
) -> ActixResult<HttpResponse> {
    let new_album = database::open(db, move |conn| {
        use crate::schema::albums;
        use diesel::prelude::*;

        // add to albums table
        let (id, owner_id, name, tags): (Uuid, Uuid, String, Vec<Option<String>>) =
            diesel::insert_into(albums::table)
                .values(NewAlbum {
                    owner_id: auth.user_id,
                    name: album.name.clone(),
                    tags: album.tags.clone(),
                })
                .returning((albums::id, albums::owner_id, albums::name, albums::tags))
                .get_result(conn)
                .map_err(SimpleDatabaseError::from)?;
        info!(%id, "Created new album");

        let new_album = Album {
            id,
            owner_id,
            name,
            tags: tags.into_iter().filter_map(|t| t).collect(),
            shared_with: vec![],
            images: vec![],
        };
        Ok(new_album)
    })
    .await?;
    Ok(HttpResponse::Ok().json(new_album))
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
        content = AlbumPatch
    ),
    security(
        ("JWT Access Token" = [])
    )
)]
#[patch("/{id}")]
pub async fn edit_album(
    auth: AuthContext,
    album_id: web::Path<Uuid>,
    patch: web::Json<AlbumPatch>,
    db: web::Data<Database>,
    app_cfg: web::Data<AppConfiguration>,
) -> ActixResult<HttpResponse, ApiError> {
    let mut patch = patch.into_inner();

    if let Some(tags) = &mut patch.tags {
        process_tags(tags, app_cfg.max_tags_per_resource);
    }

    let edited_album = database::open(db, move |conn| {
        use crate::schema::{album_images, albums, shared_albums, user_images, users};
        use diesel::prelude::*;

        //Get the owner of the album
        let owner_id = albums::table
            .select(albums::owner_id)
            .filter(albums::id.eq(album_id.clone()))
            .get_result::<Uuid>(conn)
            .map_err(DatabaseError::<ApiError>::from)?;
        //Check if the user is the owner of the album
        if owner_id != auth.user_id {
            return Err(DatabaseError::Custom(ApiError::read_only()));
        }

        if patch != EMPTY_ALBUM_PATCH {
            diesel::update(albums::table)
                .filter(albums::id.eq(album_id.clone()))
                .set(patch)
                .execute(conn)
                .map_err(DatabaseError::<ApiError>::from)?;
        }

        // Fetch the album
        // see the comment int GET /album
        let (id, owner_id, name, tags): (Uuid, Uuid, String, Vec<Option<String>>) = albums::table
            .select((albums::id, albums::owner_id, albums::name, albums::tags))
            .filter(albums::id.eq(album_id.clone()))
            .get_result(conn)
            .optional()
            .map_err(DatabaseError::<ApiError>::from)?
            .expect("Album not found");
        let shared_with = users::table
            .inner_join(shared_albums::table.on(shared_albums::user_id.eq(users::id)))
            .select(users::email)
            .filter(shared_albums::album_id.eq(album_id.clone()))
            .load::<String>(conn)
            .map_err(DatabaseError::<ApiError>::from)?;
        let images = user_images::table
            .left_outer_join(album_images::table)
            .left_outer_join(
                shared_albums::table.on(album_images::album_id.eq(shared_albums::album_id)),
            )
            .left_outer_join(users::table.on(shared_albums::user_id.eq(users::id)))
            .group_by(user_images::id)
            .select((
                user_images::id,
                user_images::user_id,
                user_images::caption,
                user_images::tags,
                crate::database::array_agg(users::email.nullable()),
            ))
            .filter(album_images::album_id.eq(album_id.clone()))
            .load::<ImageMetaData>(conn)
            .map_err(DatabaseError::<ApiError>::from)?;

        // Create the album object
        let album = Album {
            id,
            owner_id,
            name,
            tags: tags.into_iter().filter_map(|t| t).collect(),
            shared_with,
            images,
        };
        Ok(album)
    })
    .await?;
    Ok(HttpResponse::Ok().json(edited_album))
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
pub async fn delete_album(
    auth: AuthContext,
    album_id: web::Path<Uuid>,
    db: web::Data<Database>,
) -> ActixResult<HttpResponse> {
    database::open(db, move |conn| {
        use crate::schema::albums;
        use diesel::prelude::*;

        diesel::delete(albums::table.filter(albums::id.eq(album_id.clone())))
            .execute(conn)
            .map_err(SimpleDatabaseError::from)?;
        Ok(())
    })
    .await?;
    Ok(HttpResponse::NoContent().finish())
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
    db: web::Data<Database>,
) -> ActixResult<HttpResponse, ApiError> {
    let new_album = database::open(db, move |conn| {
        use crate::schema::{album_images, albums, shared_albums, user_images, users};
        use diesel::prelude::*;

        //Get the owner of the album
        let owner_album_id = albums::table
            .select(albums::owner_id)
            .filter(albums::id.eq(path.0))
            .get_result::<Uuid>(conn)
            .map_err(DatabaseError::<ApiError>::from)?;
        //Check if the user is the owner of the album
        if owner_album_id != auth.user_id {
            return Err(DatabaseError::Custom(ApiError::read_only()));
        }

        //Get the owner of the image
        let owner_image_id = user_images::table
            .select(user_images::user_id)
            .filter(user_images::id.eq(path.1))
            .get_result::<Uuid>(conn)
            .map_err(DatabaseError::<ApiError>::from)?;

        //Check if the user is the owner of the image
        if owner_image_id != auth.user_id {
            return Err(DatabaseError::Custom(ApiError::read_only()));
        }

        // Add the image to the album
        diesel::insert_into(album_images::table)
            .values((
                album_images::album_id.eq(path.0),
                album_images::image_id.eq(path.1),
            ))
            .execute(conn)
            .map_err(DatabaseError::<ApiError>::from)?;

        // Fetch the album
        // see the comment int GET /album
        let (id, owner_id, name, tags): (Uuid, Uuid, String, Vec<Option<String>>) = albums::table
            .select((albums::id, albums::owner_id, albums::name, albums::tags))
            .filter(albums::id.eq(path.0))
            .get_result(conn)
            .optional()
            .map_err(DatabaseError::<ApiError>::from)?
            .expect("Album not found");
        let shared_with = users::table
            .inner_join(shared_albums::table.on(shared_albums::user_id.eq(users::id)))
            .select(users::email)
            .filter(shared_albums::album_id.eq(path.0))
            .load::<String>(conn)
            .map_err(DatabaseError::<ApiError>::from)?;
        let images = user_images::table
            .left_outer_join(album_images::table)
            .left_outer_join(
                shared_albums::table.on(album_images::album_id.eq(shared_albums::album_id)),
            )
            .left_outer_join(users::table.on(shared_albums::user_id.eq(users::id)))
            .group_by(user_images::id)
            .select((
                user_images::id,
                user_images::user_id,
                user_images::caption,
                user_images::tags,
                crate::database::array_agg(users::email.nullable()),
            ))
            .filter(album_images::album_id.eq(path.0))
            .load::<ImageMetaData>(conn)
            .map_err(DatabaseError::<ApiError>::from)?;

        // Create the album object
        let album = Album {
            id,
            owner_id,
            name,
            tags: tags.into_iter().filter_map(|t| t).collect(),
            shared_with,
            images,
        };
        Ok(album)
    })
    .await?;

    Ok(HttpResponse::Ok().json(new_album))
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
    db: web::Data<Database>,
) -> ActixResult<HttpResponse, ApiError> {
    let new_album = database::open(db, move |conn| {
        use crate::schema::{album_images, albums, shared_albums, user_images, users};
        use diesel::prelude::*;

        //Get the owner of the album
        let owner_album_id = albums::table
            .select(albums::owner_id)
            .filter(albums::id.eq(path.0))
            .get_result::<Uuid>(conn)
            .map_err(DatabaseError::<ApiError>::from)?;
        //Check if the user is the owner of the album
        if owner_album_id != auth.user_id {
            return Err(DatabaseError::Custom(ApiError::read_only()));
        }

        //Get the owner of the image
        let owner_image_id = user_images::table
            .select(user_images::user_id)
            .filter(user_images::id.eq(path.1))
            .get_result::<Uuid>(conn)
            .map_err(DatabaseError::<ApiError>::from)?;

        //Check if the user is the owner of the image
        if owner_image_id != auth.user_id {
            return Err(DatabaseError::Custom(ApiError::read_only()));
        }

        // Remove the image from the album
        diesel::delete(
            album_images::table.filter(
                album_images::album_id
                    .eq(path.0)
                    .and(album_images::image_id.eq(path.1)),
            ),
        )
        .execute(conn)
        .map_err(DatabaseError::<ApiError>::from)?;

        // Fetch the album
        // see the comment int GET /album
        let (id, owner_id, name, tags): (Uuid, Uuid, String, Vec<Option<String>>) = albums::table
            .select((albums::id, albums::owner_id, albums::name, albums::tags))
            .filter(albums::id.eq(path.0))
            .get_result(conn)
            .optional()
            .map_err(DatabaseError::<ApiError>::from)?
            .expect("Album not found");
        let shared_with = users::table
            .inner_join(shared_albums::table.on(shared_albums::user_id.eq(users::id)))
            .select(users::email)
            .filter(shared_albums::album_id.eq(path.0))
            .load::<String>(conn)
            .map_err(DatabaseError::<ApiError>::from)?;
        let images = user_images::table
            .left_outer_join(album_images::table)
            .left_outer_join(
                shared_albums::table.on(album_images::album_id.eq(shared_albums::album_id)),
            )
            .left_outer_join(users::table.on(shared_albums::user_id.eq(users::id)))
            .group_by(user_images::id)
            .select((
                user_images::id,
                user_images::user_id,
                user_images::caption,
                user_images::tags,
                crate::database::array_agg(users::email.nullable()),
            ))
            .filter(album_images::album_id.eq(path.0))
            .load::<ImageMetaData>(conn)
            .map_err(DatabaseError::<ApiError>::from)?;

        // Create the album object
        let album = Album {
            id,
            owner_id,
            name,
            tags: tags.into_iter().filter_map(|t| t).collect(),
            shared_with,
            images,
        };
        Ok(album)
    })
    .await?;
    Ok(HttpResponse::Ok().json(new_album))
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
