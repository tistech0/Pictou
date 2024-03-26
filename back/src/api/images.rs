use std::{
    error::Error as StdError,
    future,
    io::{self, Cursor},
    pin::Pin,
};

use crate::{
    api::{
        image_not_found_example, image_payload_too_large_example, json_payload_error_example,
        path_error_example, query_payload_error_example,
    },
    auth::AuthContext,
    config::AppConfiguration,
    database::{self, Database, DatabaseError, SimpleDatabaseError},
    error_handler::{ApiError, ApiErrorCode},
    image::{self, ImageType},
    storage::{ImageHash, ImageStorage, StoredImageKind},
};
use actix_multipart::Multipart;
use actix_web::{
    delete, error::ErrorInternalServerError, get, http::header, patch, post, web,
    Error as ActixError, HttpResponse, Responder, Result as ActixResult,
};
use diesel::{deserialize::Queryable, prelude::Insertable, query_builder::AsChangeset, Selectable};
use futures::prelude::stream::*;
use serde::{Deserialize, Serialize};
use tokio::io::{AsyncWriteExt, BufReader};
use tokio_util::io::{ReaderStream, StreamReader};
use tracing::{debug, error, info};
use utoipa::ToSchema;
use uuid::Uuid;

use super::{process_tags, Binary};

const CONTEXT_PATH: &str = "/images";

#[derive(Clone, Copy, Deserialize, Serialize, ToSchema)]
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

#[derive(Deserialize)]
pub struct ImagesQuery {
    limit: Option<u32>,
    offset: Option<u32>,
    quality: Option<ImageQuality>,
}

#[derive(Deserialize, Serialize, ToSchema, AsChangeset, PartialEq, Eq)]
#[diesel(table_name = crate::schema::user_images)]
pub struct ImagePatch {
    caption: Option<String>,
    tags: Option<Vec<String>>,
}

const EMPTY_IMAGE_PATCH: ImagePatch = ImagePatch {
    caption: None,
    tags: None,
};

#[derive(ToSchema)]
pub struct ImagePayload {
    #[allow(dead_code)]
    image: Binary,
}

#[derive(Deserialize, Serialize, ToSchema, Queryable)]
pub struct ImageMetaData {
    id: Uuid,
    owner_id: Uuid,
    caption: String,
    #[diesel(deserialize_as = crate::database::VecOfNonNull<String>)]
    tags: Vec<String>,
    #[diesel(deserialize_as = crate::database::VecOfNonNull<String>)]
    shared_with: Vec<String>,
}

#[derive(Deserialize, Serialize, ToSchema)]
pub struct ImagesMetaData {
    images: Vec<ImageMetaData>,
}

#[derive(Serialize, Deserialize, ToSchema)]
pub struct ImageUploadResponse {
    id: Uuid,
}

#[derive(Debug, Insertable, Selectable, Queryable, ToSchema)]
#[diesel(table_name = crate::schema::stored_images)]
struct NewStoredImage {
    hash: ImageHash,
    compression_alg: String,
    size: i64,
    width: i64,
    height: i64,
    orignal_mime_type: String,
}

#[derive(Debug, Insertable)]
#[diesel(table_name = crate::schema::user_images)]
struct NewUserImage {
    user_id: Uuid,
    image_id: ImageHash,
}

/// Get an image by its id.
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        (
            "id" = Uuid,
            Path,
            description = "Identifier of the image",
            example = "e58ed763-928c-4155-bee9-fdbaaadc15f3"
        ),
        (
            "quality" = Option<ImageQuality>,
            Query,
            description = "Image quality",
            example = "Low"
        )
    ),
    responses(
        (
            status = StatusCode::OK,
            description = "Image retrieved successfully",
            body = Binary,
            content_type = "image/jpeg"
        ),
        (
            status = StatusCode::BAD_REQUEST,
            body = ApiError,
            examples(
                ("Invalid query parameters" = (value = json!(query_payload_error_example()))),
                ("Invalid path parameters" = (value = json!(path_error_example())))
            ),
            content_type = "application/json"
        ),
        (
            status = StatusCode::UNAUTHORIZED,
            description = "User not authenticated",
            body = ApiError,
            example = json!(ApiError::unauthorized_error()),
            content_type = "application/json"
        ),
        (
            status = StatusCode::NOT_FOUND,
            description = "Image not found (or user is forbidden to see it)",
            body = ApiError,
            example = json!(image_not_found_example()),
            content_type = "application/json"
        )
    ),
    tag="images",
    security(
        ("JWT Access Token" = [])
    )
)]
#[get("/{id}")]
#[tracing::instrument(skip_all)]
pub async fn get_image(
    auth: AuthContext,
    img_id: web::Path<Uuid>,
    query: web::Query<ImageQuery>,
    db: web::Data<Database>,
    image_storage: web::Data<dyn ImageStorage>,
) -> ActixResult<HttpResponse> {
    let user_id = auth.user_id;
    let img_id = img_id.into_inner();

    let _ = query; // FIXME: image quality is ignored for now

    let (hash, mime_type) = database::open(db, move |conn| {
        use crate::schema::{stored_images, user_images};
        use diesel::prelude::*;

        user_images::table
            .inner_join(stored_images::table)
            .filter(
                user_images::id
                    .eq(img_id)
                    .and(user_images::user_id.eq(user_id)),
            )
            .select((stored_images::hash, stored_images::orignal_mime_type))
            .get_result::<(ImageHash, String)>(conn)
            .map_err(SimpleDatabaseError::from)
    })
    .await?;

    debug!(%hash, mime_type, "opening image for reading");
    let image_source = image_storage
        .load(hash, StoredImageKind::Original)
        .await
        .map_err(|error| {
            error!(%hash, error = &error as &dyn StdError, "failed to load image from storage");
            ErrorInternalServerError("")
        })?;
    let image_stream = ReaderStream::new(image_source);

    Ok(HttpResponse::Ok()
        .content_type(mime_type)
        .streaming(image_stream))
}

/// Get the images owned by or shared with the user
///
/// This method returns the metadata of the images not the effective images. The client must make a request for each image independently.
/// The list can be filtered by quality, and paginated.
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        (
            "limit" = Option<u32>,
            Query,
            description = "Number of images to return",
            example = 10
        ),
        (
            "offset" = Option<u32>,
            Query,
            description = "Offset of the query in the image list to return",
            example = 0
        ),
        (
            "quality" = Option<ImageQuality>,
            Query,
            description = "Image quality",
            example = "low"
        )
    ),
    responses(
        (
            status = StatusCode::OK,
            description = "Images retrieved successfully",
            body = ImagesMetaData,
            content_type = "application/json"
        ),
        (
            status = StatusCode::UNAUTHORIZED,
            description = "User not authenticated",
            body = ApiError,
            example = json!(ApiError::unauthorized_error()),
            content_type = "application/json"
        ),
        (
            status = StatusCode::BAD_REQUEST,
            description = "Invalid query parameters",
            body = ApiError,
            example = json!(query_payload_error_example()),
            content_type = "application/json"
        ),
    ),
    tag = "images",
    security(
        ("JWT Access Token" = [])
    )
)]
#[get("")]
pub async fn get_images(
    auth: AuthContext,
    query: web::Query<ImagesQuery>,
    app_cfg: web::Data<AppConfiguration>,
    db: web::Data<Database>,
) -> Result<impl Responder, ActixError> {
    let limit = query
        .limit
        .unwrap_or(app_cfg.images_query_default_limit)
        .min(app_cfg.images_query_max_limit);
    let offset = query.offset.unwrap_or(0);
    let _quality = query.quality.unwrap_or(ImageQuality::Medium); // FIXME: image quality is ignored for now

    let images: Vec<ImageMetaData> = database::open(db, move |conn| {
        use crate::schema::{album_images, shared_albums, user_images, users};
        use diesel::prelude::*;

        // Corresponds to the following SQL:
        /*
            SELECT public.user_images.id,
                   public.user_images.user_id    AS owner_id,
                   public.user_images.caption,
                   public.user_images.tags,
            array_agg(public.users.email) AS shared_with
            FROM public.user_images
                     LEFT JOIN public.album_images ON user_images.id = album_images.image_id
                     LEFT JOIN public.shared_albums ON shared_albums.album_id = album_images.album_id
                     LEFT JOIN public.users ON shared_albums.user_id = users.id
            WHERE public.user_images.user_id = {auth.user_id}
            GROUP BY user_images.id
            LIMIT {limit} OFFSET {offset};
        */
        user_images::table
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
            .filter(user_images::user_id.eq(auth.user_id))
            .limit(limit as i64)
            .offset(offset as i64)
            .load::<ImageMetaData>(conn)
            .map_err(SimpleDatabaseError::from)
    })
    .await?;

    Ok(web::Json(ImagesMetaData { images }))
}

/// Upload an image
#[utoipa::path(
    context_path = CONTEXT_PATH,
    responses(
        (
            status = StatusCode::OK,
            description = "Successfully uploaded",
            body = ImageUploadResponse
        ),
        (
            status = StatusCode::UNAUTHORIZED,
            description = "User not authenticated",
            body = ApiError,
            example = json!(ApiError::unauthorized_error()),
            content_type = "application/json"
        ),
        (
            status = StatusCode::BAD_REQUEST,
            description = "Invalid image payload / encoding",
            body = ApiError,
            example = json!(image_payload_too_large_example()),
            content_type = "application/json"
        ),
        (
            status = StatusCode::UNSUPPORTED_MEDIA_TYPE,
            description = "Unsupported image format",
            body = ApiError,
            example = json!(ApiError::unsupported_image_type()),
            content_type = "application/json"
        ),
    ),
    tag = "images",
    request_body(
        description = "File to upload (binary data)",
        content_type = "multipart/form-data",
        content = ImagePayload
    ),
    security(
        ("JWT Access Token" = [])
    )
)]
#[post("")]
#[tracing::instrument(skip(size, payload, app_cfg, db, storage))]
pub async fn upload_image(
    auth: AuthContext,
    size: web::Header<header::ContentLength>,
    payload: Multipart,
    app_cfg: web::Data<AppConfiguration>,
    db: web::Data<Database>,
    storage: web::Data<dyn ImageStorage>,
) -> ActixResult<HttpResponse> {
    let size = size.into_inner().into_inner();

    if size > app_cfg.max_image_size {
        return Err(ApiError::image_too_big(app_cfg.max_image_size))?;
    }

    info!("decoding uploaded image");

    let mut payload = payload.try_skip_while(|field| future::ready(Ok(field.name() != "image")));
    let image_payload = payload
        .try_next()
        .await?
        .ok_or_else(ApiError::missing_image_payload)?;

    let image_type = image_payload
        .content_type()
        .and_then(|content_type| ImageType::from_mime(content_type.essence_str()))
        .ok_or_else(ApiError::unsupported_image_type)?;

    // wrap multipart errors as IO errors to pass them to the StreamReader
    let image_payload = image_payload.map_err(|error| {
        error!(
            error = &error as &dyn StdError,
            "failed to read image payload"
        );
        io::Error::other(ApiError::invalid_encoding(error))
    });

    let mut input = BufReader::new(StreamReader::new(image_payload));

    let decoded = image::decode(image_type, Pin::new(&mut input), size)
        .await
        .map_err(|error| {
            error!(
                error = AsRef::<dyn StdError>::as_ref(&error),
                "failed to decode image"
            );
            ApiError::invalid_encoding(error)
        })?;
    drop(input);

    // consume the rest of the payload stream, not doing so would result in an error
    while let Some(_extra_field) = payload.next().await.transpose()? {}

    let to_store = NewStoredImage {
        hash: decoded.hash(),
        compression_alg: "none".to_owned(),
        size: decoded.size(),
        width: decoded.width(),
        height: decoded.height(),
        orignal_mime_type: image_type.as_mime().to_owned(),
    };

    let (user_image_id, need_storage): (Uuid, bool) = database::open(db, move |conn| {
        use crate::schema::{stored_images, user_images};
        use diesel::prelude::*;

        info!(?to_store, "decoding complete, storing image in database");

        // insert stored image if not already present
        let stored: Option<NewStoredImage> = diesel::insert_into(stored_images::table)
            .values(&to_store)
            .on_conflict_do_nothing()
            .returning(NewStoredImage::as_returning())
            .get_result(conn)
            .optional()
            .map_err(DatabaseError::<ApiError>::from)?;

        let need_storage = match stored {
            None => {
                debug!(hash = %to_store.hash, "image already present, no storage needed");
                false
            }
            Some(stored) => {
                debug!(?stored, "updated stored_image record in database");

                // check for hash collision
                if to_store.size != stored.size
                    || to_store.width != stored.width
                    || to_store.height != stored.height
                    || to_store.orignal_mime_type != stored.orignal_mime_type
                {
                    error!(hash = %to_store.hash, "hash collision detected");
                    return Err(DatabaseError::Custom(ApiError::new(
                        actix_web::http::StatusCode::INTERNAL_SERVER_ERROR,
                        ApiErrorCode::Unknown,
                        "",
                    )));
                }
                debug!("no hash collision detected");
                true
            }
        };

        debug!("inserting user_image record");

        // insert user image, do nothing if already present
        let user_image_id = diesel::insert_into(user_images::table)
            .values(NewUserImage {
                user_id: auth.user_id,
                image_id: to_store.hash,
            })
            .on_conflict((user_images::user_id, user_images::image_id))
            .do_update()
            // INSERT .. ON CONFLICT .. DO NOTHING does not return the orignal row in Postgres,
            // so we do a useless SET operation to get the row back
            .set(user_images::user_id.eq(user_images::user_id))
            .returning(user_images::id)
            .get_result(conn)
            .map_err(DatabaseError::<ApiError>::from)?;
        Ok((user_image_id, need_storage))
    })
    .await
    .map_err(ApiError::from)?;

    if need_storage {
        info!(hash = %decoded.hash(), %user_image_id, "compressing and storing image in storage");

        // TODO: it would be wise to do these operations in a separate thread in order to not block
        // the client
        let mut output = storage
            .store(decoded.hash(), StoredImageKind::Original)
            .await?;
        let mut to_write_buf = Cursor::new(decoded.original_bytes());
        output.write_all_buf(&mut to_write_buf).await?;
    }

    info!(hash = %decoded.hash(), %user_image_id, "image upload complete");

    Ok(HttpResponse::Ok().json(ImageUploadResponse { id: user_image_id }))
}

/// Set/modfiy image metadata, share/unshare, ...
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        (
            "id" = Uuid,
            Path,
            description = "Image to edit",
            example = "e58ed763-928c-4155-bee9-fdbaaadc15f3"
        ),
    ),
    responses(
        (
            status = StatusCode::OK,
            description = "Successfully patched",
            body = ImageMetaData
        ),
        (
            status = StatusCode::BAD_REQUEST,
            body = ApiError,
            examples(
                ("Invalid path parameters" = (value = json!(path_error_example()))),
                ("Invalid payload" = (value = json!(json_payload_error_example())))
            ),
            content_type = "application/json"
        ),
        (
            status = StatusCode::UNAUTHORIZED,
            description = "User not authenticated",
            body = ApiError,
            example = json!(ApiError::unauthorized_error()),
            content_type = "application/json"
        ),
        (
            status = StatusCode::FORBIDDEN,
            description = "User has read only rights on the image (shared image)",
            body = ApiError,
            example = json!(ApiError::read_only()),
            content_type = "application/json"
        ),
        (
            status = StatusCode::NOT_FOUND,
            description = "Image not found (or user is forbidden to see it)",
            body = ApiError,
            example = json!(image_not_found_example()),
            content_type = "application/json"
        )
    ),
    tag = "images",
    request_body(
        description = "Image to edit",
        content_type = "application/json",
        content = ImagePatch
    ),
    security(
        ("JWT Access Token" = [])
    )
)]
#[patch("/{id}")]
pub async fn edit_image(
    auth: AuthContext,
    img_id: web::Path<Uuid>,
    patch: web::Json<ImagePatch>,
    db: web::Data<Database>,
    app_cfg: web::Data<AppConfiguration>,
) -> Result<HttpResponse, ApiError> {
    let img_id = img_id.into_inner();
    let mut patch = patch.into_inner();

    if let Some(tags) = &mut patch.tags {
        process_tags(tags, app_cfg.max_tags_per_resource);
    }

    let metadata: ImageMetaData = database::open(db, move |conn| {
        use crate::schema::{album_images, shared_albums, user_images, users};
        use diesel::prelude::*;

        // Check if the user has read only rights on the image.
        // This is the case if the image is shared with the user, but the user is not the owner.
        let is_read_only: i64 = user_images::table
            .inner_join(album_images::table)
            .inner_join(shared_albums::table.on(album_images::album_id.eq(shared_albums::album_id)))
            .filter(
                user_images::id.eq(img_id).and(
                    shared_albums::user_id
                        .eq(auth.user_id)
                        .and(user_images::user_id.ne(auth.user_id)),
                ),
            )
            .count()
            .get_result(conn)
            .map_err(DatabaseError::<ApiError>::from)?;

        if is_read_only > 0 {
            return Err(DatabaseError::Custom(ApiError::read_only()));
        }

        // Updating nothing is not an error
        if patch != EMPTY_IMAGE_PATCH {
            diesel::update(user_images::table)
                .set(patch)
                .filter(
                    user_images::id
                        .eq(img_id)
                        .and(user_images::user_id.eq(auth.user_id)),
                )
                .execute(conn)
                .map_err(DatabaseError::<ApiError>::from)?;
        }

        // Fetch the full image metadata,
        // see the comment in GET /images
        user_images::table
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
            .filter(
                user_images::id
                    .eq(img_id)
                    .and(user_images::user_id.eq(auth.user_id)),
            )
            .get_result::<ImageMetaData>(conn)
            .map_err(DatabaseError::<ApiError>::from)
    })
    .await?;

    Ok(HttpResponse::Ok().json(metadata))
}

/// Delete an image
#[utoipa::path(
    context_path = CONTEXT_PATH,
    params(
        (
            "id" = Uuid,
            Path,
            description="Image to delete",
            example="e58ed763-928c-4155-bee9-fdbaaadc15f3"
        ),
    ),
    responses(
        (
            status = StatusCode::NO_CONTENT,
            description = "Successfully deleted"
        ),
        (
            status = StatusCode::BAD_REQUEST,
            description = "Invalid path parameters",
            body = ApiError,
            example = json!(path_error_example()),
            content_type = "application/json"
        ),
        (
            status = StatusCode::UNAUTHORIZED,
            description = "User not authenticated",
            body = ApiError,
            example = json!(ApiError::unauthorized_error()),
            content_type = "application/json"
        ),
        (
            status = StatusCode::FORBIDDEN,
            description = "User has read only rights on the image (shared image)",
            body = ApiError,
            example = json!(ApiError::forbidden_error()),
            content_type = "application/json"
        ),
        (
            status = StatusCode::NOT_FOUND,
            description = "Image not found (or user is forbidden to see it)",
            body = ApiError,
            example = json!(image_not_found_example()),
            content_type = "application/json"
        )
    ),
    tag = "images",
    security(
        ("JWT Access Token" = [])
    )
)]
#[delete("/{id}")]
pub async fn delete_image(
    auth: AuthContext,
    img_id: web::Path<Uuid>,
    db: web::Data<Database>,
    storage: web::Data<dyn ImageStorage>,
) -> ActixResult<HttpResponse> {
    let img_id = img_id.into_inner();
    let user_id = auth.user_id;

    let hash: ImageHash = database::open(db, move |conn| {
        use crate::schema::{stored_images, user_images};
        use diesel::prelude::*;

        let hash = diesel::delete(
            user_images::table.filter(
                user_images::id
                    .eq(img_id)
                    .and(user_images::user_id.eq(user_id)),
            ),
        )
        .returning(user_images::image_id)
        .get_result(conn)
        .map_err(DatabaseError::<ApiError>::from)?;

        // Check if there are any other user_images with the same hash
        let count = user_images::table
            .filter(user_images::image_id.eq(&hash))
            .count()
            .get_result::<i64>(conn)?;

        // If there are no other user_images, delete the stored_image
        if count == 0 {
            diesel::delete(stored_images::table.filter(stored_images::hash.eq(hash)))
                .execute(conn)?;
        }

        Ok(hash)
    })
    .await?;

    storage.delete_all_kinds(hash).await?;
    Ok(HttpResponse::NoContent().finish())
}

pub fn configure(cfg: &mut web::ServiceConfig) {
    //define your methods here
    cfg.service(get_image)
        .service(get_images)
        .service(upload_image)
        .service(edit_image)
        .service(delete_image);
}
