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
    pub session_key: String,
    pub jwt_secret: Box<[u8]>,
    pub google_client_id: Option<oauth2::ClientId>,
    pub google_client_secret: Option<oauth2::ClientSecret>,
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
            session_key: env::var("SESSION_KEY")?,
            jwt_secret: env::var("JWT_SECRET").map(|s| s.into_bytes().into())?,
            google_client_id: env::var("GOOGLE_CLIENT_ID").ok().map(oauth2::ClientId::new),
            google_client_secret: env::var("GOOGLE_CLIENT_SECRET")
                .ok()
                .map(oauth2::ClientSecret::new),
        })
    }
}
