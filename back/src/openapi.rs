use utoipa::OpenApi;
use utoipa_auto_discovery::utoipa_auto_discovery;

use crate::api::albums::{Album, AlbumList, AlbumPost};
use crate::api::images::{
    ImageMetaData, ImagePatch, ImageQuality, ImageUploadResponse, ImagesMetaData,
};
use crate::api::users::{User, UserList, UserPost};
use crate::api::Binary;
use crate::error_handler::{APIError, ApiErrorCode};

#[utoipa_auto_discovery(paths = "( crate::api::images => ./src/api/images.rs );
            ( crate::api::albums => ./src/api/albums.rs );
            ( crate::api::users => ./src/api/users.rs )")]
#[derive(OpenApi)]
#[openapi(
    info(
        title = "Pictou API",
        version = "0.1.0",
        description = "Pictou is a picture management application."
    ),
    servers(
        (url = "/api")
    ),
    components(
        schemas(ImageQuality, Binary, ImageUploadResponse, ImagePatch, ImageMetaData, ImagesMetaData,
            Album, AlbumList, AlbumPost,
            User, UserList, UserPost,
            ApiErrorCode, APIError),
    ),
    tags(
        (name = "images", description = "Images management endpoints."),
        (name = "albums", description = "Albums management endpoints."),
        (name = "users", description = "Users management endpoints.")
    )
    )]
pub struct ApiDoc;
