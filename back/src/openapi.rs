use utoipa::OpenApi;
use utoipa_auto_discovery::utoipa_auto_discovery;

use crate::api::images::ImageQuality;

#[utoipa_auto_discovery(paths = "( crate::api::images => ./src/api/images.rs )")]
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
        schemas(ImageQuality)
    ),
    tags(
        (name = "images", description = "Images management endpoints.")
    )
    )]
pub struct ApiDoc;
