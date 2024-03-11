use std::env;

/// Holds the initial configuration of the application.
/// Meant to be created from environment variables and used via [`actix_web::web::Data`].
#[derive(Debug, Default)]
pub struct AppConfiguration {
    pub postgres_host: String,
    pub postgres_user: String,
    pub postgres_password: String,
    pub postgres_db: String,
    pub address: String,
    pub port: u16,
}

impl AppConfiguration {
    /// Creates a new instance of `AppConfiguration` from environment variables.
    /// If any of the required environment variables are missing, an error is returned.
    /// Use [`dotenv::dotenv`] to load environment variables from a file.
    pub fn from_env() -> anyhow::Result<AppConfiguration> {
        Ok(AppConfiguration {
            postgres_host: env::var("POSTGRES_HOST")?,
            postgres_user: env::var("POSTGRES_USER")?,
            postgres_password: env::var("POSTGRES_PASSWORD")?,
            postgres_db: env::var("POSTGRES_DB")?,
            address: env::var("ADDRESS")?,
            port: env::var("PORT")?.parse()?,
        })
    }
}
