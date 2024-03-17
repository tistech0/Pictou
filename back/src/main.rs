use std::io;

use actix_session::{storage::CookieSessionStore, SessionMiddleware};
use actix_web::{
    cookie, get, middleware::ErrorHandlers, middleware::NormalizePath, post, web, App,
    HttpResponse, HttpServer, Responder,
};
use anyhow::Context;
use dotenv::dotenv;
use tracing::{info, warn};
use tracing_actix_web::TracingLogger;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

mod auth;
mod api;
mod config;
mod database;
// FIXME: remove when OpenAPI-compatible error handling is merged
mod error;
mod error_handler;
mod log;
mod openapi;
mod schema;

use crate::{auth::AuthContext, config::AppConfiguration, database::Database};

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hello world!")
}

#[post("/echo")]
#[tracing::instrument]
async fn echo(req_body: String) -> impl Responder {
    warn!("somebody echoed us!");
    HttpResponse::Ok().body(req_body)
}

#[get("/auth-only")]
#[tracing::instrument]
async fn auth_only(auth: AuthContext) -> impl Responder {
    HttpResponse::Ok().body(format!("You are authorized as user ID {}!", auth.user_id))
}

async fn manual_hello() -> impl Responder {
    HttpResponse::Ok().body("Hey there!")
}

#[tracing::instrument]
async fn init() -> anyhow::Result<()> {
    let _guard = log::init();

    dotenv().context("failed to read environment from .env")?;

    let app_cfg = web::Data::new(AppConfiguration::from_env()?);
    let address = app_cfg.address.to_owned();
    let port = app_cfg.port;
    let database = web::Data::new(Database::new(&app_cfg)?);

    let auth_clients = auth::Clients::new(app_cfg.clone()).await;

    let server = HttpServer::new(move || {
        App::new()
            .app_data(app_cfg.clone())
            .app_data(database.clone())
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
            .service(hello)
            .service(echo)
            .service(web::scope("/api").configure(api::configure))
            .service(
                SwaggerUi::new("/swagger-ui/{_:.*}")
                    .url("/api-docs/openapi.json", openapi::ApiDoc::openapi()),
            )
            .service(auth_only)
            .configure(|cfg| auth::routes(&auth_clients, cfg))
            .route("/hey", web::get().to(manual_hello))
    })
    .bind((address.clone(), port))?;

    info!(address, port, "starting Pictou server");
    server.run().await?;
    info!(address, port, "server stopped");
    Ok(())
}

#[actix_web::main]
async fn main() -> io::Result<()> {
    if let Err(err) = init().await {
        eprintln!("{err:?}");
        std::process::exit(1);
    }
    Ok(())
}
