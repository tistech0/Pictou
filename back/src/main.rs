use std::{io, sync::Arc};

use actix_web::web;
use anyhow::Context;
use dotenv::dotenv;
use tokio::sync::Notify;
use tracing::debug;

use pictou::{config::AppConfiguration, log};

#[tracing::instrument]
async fn init() -> anyhow::Result<()> {
    let _guard = log::init();

    dotenv().context("failed to read environment from .env")?;

    let app_cfg = web::Data::from(AppConfiguration::from_env()?);
    debug!(?app_cfg, "loaded configuration from environment");

    pictou::start_server(app_cfg, Arc::new(Notify::new())).await
}

#[actix_web::main]
async fn main() -> io::Result<()> {
    if let Err(err) = init().await {
        eprintln!("{err:?}");
        std::process::exit(1);
    }
    Ok(())
}
