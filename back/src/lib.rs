//! The backend of Pictou, as a library.

pub mod api;
pub mod auth;
pub mod classifier;
pub mod config;
pub mod database;
pub mod error_handler;
pub mod image;
pub mod log;
pub mod openapi;
pub mod schema;
pub mod storage;

use std::sync::Arc;

use actix_session::{storage::CookieSessionStore, SessionMiddleware};
use actix_web::{
    cookie,
    middleware::{ErrorHandlers, NormalizePath},
    web, App, HttpServer,
};
use tokio::sync::Notify;
use tracing::info;
use tracing_actix_web::TracingLogger;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use crate::{
    auth::OAuth2Clients,
    classifier::ImageClassifier,
    config::AppConfiguration,
    database::Database,
    storage::{ImageStorage, LocalImageStorage},
};

pub async fn start_server(
    app_cfg: web::Data<AppConfiguration>,
    server_started: Arc<Notify>,
) -> anyhow::Result<()> {
    let address = app_cfg.address.to_owned();
    let port = app_cfg.port;
    let database = web::Data::new(Database::new(&app_cfg)?);
    let image_storage =
        web::Data::from(Arc::new(LocalImageStorage::new("storage")) as Arc<dyn ImageStorage>);

    // lifted the call to HttpServer::new because it does not accept async
    let auth_clients = web::Data::new(OAuth2Clients::new(app_cfg.clone()).await);

    // Python interpreter is initialized here (if enabled)
    let classifier = web::Data::new(ImageClassifier::new(app_cfg.clone()).unwrap());

    let server = HttpServer::new(move || {
        let auth_clients = auth_clients.clone();
        App::new()
            .app_data(app_cfg.clone())
            .app_data(database.clone())
            .app_data(image_storage.clone())
            .app_data(classifier.clone())
            .wrap(TracingLogger::default())
            .wrap(NormalizePath::trim())
            .wrap(
                SessionMiddleware::builder(
                    CookieSessionStore::default(),
                    cookie::Key::from(&[0; 64]),
                )
                .cookie_secure(false)
                .build(),
            )
            .wrap(ErrorHandlers::new().default_handler(error_handler::json_error_handler))
            .app_data(
                actix_web::web::PathConfig::default()
                    .error_handler(error_handler::path_error_handler),
            )
            .service(
                web::scope("/api")
                    .configure(api::configure)
                    .configure(|cfg| auth::configure(auth_clients, cfg)),
            )
            .service(
                SwaggerUi::new("/swagger-ui/{_:.*}")
                    .url("/api-docs/openapi.json", openapi::ApiDoc::openapi()),
            )
    })
    .bind((address.clone(), port))?;

    info!(address, port, "starting Pictou server");
    server_started.notify_waiters();

    server.run().await?;
    info!(address, port, "server stopped");
    Ok(())
}
