use utoipa::openapi::security::{
    Flow, HttpAuthScheme, HttpBuilder, Implicit, OAuth2, Scopes, SecurityScheme,
};
use utoipa::{Modify, OpenApi};
use utoipa_auto_discovery::utoipa_auto_discovery;

use crate::api::albums::{Album, AlbumList, AlbumPost};
use crate::api::images::{
    ImageMetaData, ImagePatch, ImageQuality, ImageUploadResponse, ImagesMetaData,
};
use crate::api::users::{User, UserList, UserPost};
use crate::api::{Binary, OpenapiUuid};
use crate::error_handler::{ApiError, ApiErrorCode};

struct SecuritySchemas;

impl Modify for SecuritySchemas {
    fn modify(&self, openapi: &mut utoipa::openapi::OpenApi) {
        let components = openapi.components.as_mut().unwrap();

        components.add_security_scheme(
            "Google OAuth2",
            SecurityScheme::OAuth2(OAuth2::with_description(
                [Flow::Implicit(Implicit::with_refresh_url(
                    "http://localhost:8000/auth/google/authorize",
                    Scopes::new(),
                    "http://localhost:8000/auth/refresh",
                ))],
                "Google OAuth2 flow (no need to fill client id)",
            )),
        );

        components.add_security_scheme(
            "Jwt Access Token",
            SecurityScheme::Http(
                HttpBuilder::new()
                    .scheme(HttpAuthScheme::Bearer)
                    .bearer_format("JWT")
                    .description(Some(
                        "Bearer token for JWT access, retrieved from /auth/[provider]/authorize",
                    ))
                    .build(),
            ),
        );
    }
}

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
            ApiErrorCode, ApiError, OpenapiUuid),
    ),
    tags(
        (name = "images", description = "Images management endpoints."),
        (name = "albums", description = "Albums management endpoints."),
        (name = "users", description = "Users management endpoints."),
        (name = "auth", description = "Authentication management endpoints.")
    ),
    modifiers(&SecuritySchemas)
)
]
pub struct ApiDoc;
