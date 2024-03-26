use utoipa::{
    openapi::security::{
        ClientCredentials, Flow, HttpAuthScheme, HttpBuilder, OAuth2, Scopes, SecurityScheme,
    },
    Modify, OpenApi,
};
use utoipa_auto_discovery::utoipa_auto_discovery;

use crate::{
    api::{
        albums::{Album, AlbumList, AlbumPost},
        images::{
            ImageMetaData, ImagePatch, ImagePayload, ImageQuality, ImageUploadResponse,
            ImagesMetaData,
        },
        users::{User, UserList, UserPost},
        Binary, OpenapiUuid,
    },
    auth::{
        error::{AuthError, AuthErrorKind},
        AuthenticationResponse, PersistedUserInfo, RefreshTokenParams,
    },
    config::AppConfiguration,
    error_handler::{ApiError, ApiErrorCode},
};

struct SecuritySchemas;

impl Modify for SecuritySchemas {
    fn modify(&self, openapi: &mut utoipa::openapi::OpenApi) {
        let components = openapi.components.as_mut().unwrap();
        let app_cfg = AppConfiguration::from_env().expect("Failed to load app configuration");

        components.add_security_scheme(
            "Google OAuth2",
            SecurityScheme::OAuth2(OAuth2::with_description(
                [Flow::ClientCredentials(ClientCredentials::new(
                    app_cfg
                        .base_url
                        .join("api/auth/login/google")
                        .expect("Failed to build Google authorization URL"),
                    Scopes::default(),
                ))],
                "Google OAuth2 flow (no need to fill client id)",
            )),
        );

        components.add_security_scheme(
            "JWT Access Token",
            SecurityScheme::Http(
                HttpBuilder::new()
                    .scheme(HttpAuthScheme::Bearer)
                    .bearer_format("JWT")
                    .description(Some(
                        "Bearer token for JWT access, retrieved from /auth/login/[provider]",
                    ))
                    .build(),
            ),
        );
    }
}

#[utoipa_auto_discovery(paths = "( crate::api::images => ./src/api/images.rs );
            ( crate::api::albums => ./src/api/albums.rs );
            ( crate::api::users => ./src/api/users.rs );
            ( crate::auth::routes => ./src/auth/routes.rs )")]
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
        schemas(ImageQuality, Binary, ImageUploadResponse, ImagePatch, ImagePayload, ImageMetaData, ImagesMetaData,
            Album, AlbumList, AlbumPost,
            User, UserList, UserPost,
            ApiErrorCode, ApiError, OpenapiUuid,
            AuthenticationResponse, PersistedUserInfo, AuthError, AuthErrorKind, RefreshTokenParams),
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
