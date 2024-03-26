use std::{
    env,
    fmt::{self, Debug, Formatter},
    sync::{Arc, OnceLock},
};

use time::Duration;
use url::Url;

/// Holds the initial configuration of the application.
/// Meant to be created from environment variables and used via [`actix_web::web::Data`].
pub struct AppConfiguration {
    pub app_name: String,
    pub postgres_host: String,
    pub postgres_user: String,
    pub postgres_password: String,
    pub postgres_db: String,
    pub address: String,
    pub port: u16,
    pub session_key: String,
    pub jwt_secret: Box<[u8]>,
    pub base_url: Url,
    pub google_client_id: Option<oauth2::ClientId>,
    pub google_client_secret: Option<oauth2::ClientSecret>,
    pub refresh_token_lifetime: Duration,
    pub access_token_lifetime: Duration,
    pub max_image_size: usize,
    pub images_query_default_limit: u32,
    pub images_query_max_limit: u32,
    pub albums_query_default_limit: u32,
    pub albums_query_max_limit: u32,
    pub max_tags_per_resource: u32,
}

impl AppConfiguration {
    /// Creates a new instance of `AppConfiguration` from environment variables.
    /// If any of the required environment variables are missing, an error is returned.
    /// Use [`dotenv::dotenv`] to load environment variables from a file.
    ///
    /// Re-uses the same instance if called multiple times.
    pub fn from_env() -> anyhow::Result<Arc<AppConfiguration>> {
        static INSTANCE: OnceLock<Arc<AppConfiguration>> = OnceLock::new();

        match INSTANCE.get() {
            Some(app_cfg) => Ok(app_cfg.clone()),
            None => {
                let app_cfg = Self::_from_env()?;
                Ok(INSTANCE.get_or_init(move || Arc::new(app_cfg)).clone())
            }
        }
    }

    fn _from_env() -> anyhow::Result<AppConfiguration> {
        Ok(AppConfiguration {
            app_name: env::var("APP_NAME")?,
            postgres_host: env::var("POSTGRES_HOST")?,
            postgres_user: env::var("POSTGRES_USER")?,
            postgres_password: env::var("POSTGRES_PASSWORD")?,
            postgres_db: env::var("POSTGRES_DB")?,
            address: env::var("ADDRESS")?,
            port: env::var("PORT")?.parse()?,
            session_key: env::var("SESSION_KEY")?,
            jwt_secret: env::var("JWT_SECRET").map(|s| s.into_bytes().into())?,
            base_url: Url::parse(&env::var("BASE_URL")?)?,
            google_client_id: env::var("GOOGLE_CLIENT_ID").ok().map(oauth2::ClientId::new),
            google_client_secret: env::var("GOOGLE_CLIENT_SECRET")
                .ok()
                .map(oauth2::ClientSecret::new),
            refresh_token_lifetime: Duration::seconds(env::var("REFRESH_TOKEN_LIFETIME")?.parse()?),
            access_token_lifetime: Duration::seconds(env::var("ACCESS_TOKEN_LIFETIME")?.parse()?),
            max_image_size: env::var("MAX_IMAGE_SIZE").map_or(Ok(20_000_000), |s| s.parse())?,
            images_query_default_limit: env::var("IMAGES_QUERY_DEFAULT_LIMIT")
                .map_or(Ok(50), |s| s.parse())?,
            images_query_max_limit: env::var("IMAGES_QUERY_MAX_LIMIT")
                .map_or(Ok(1024), |s| s.parse())?,
            albums_query_default_limit: env::var("ALBUMS_QUERY_DEFAULT_LIMIT")
                .map_or(Ok(25), |s| s.parse())?,
            albums_query_max_limit: env::var("ALBUMS_QUERY_MAX_LIMIT")
                .map_or(Ok(50), |s| s.parse())?,
            max_tags_per_resource: env::var("MAX_TAGS_PER_RESOURCE")
                .map_or(Ok(32), |s| s.parse())?,
        })
    }
}

impl Default for AppConfiguration {
    fn default() -> Self {
        AppConfiguration {
            app_name: "Pictou".to_owned(),
            postgres_host: Default::default(),
            postgres_user: Default::default(),
            postgres_password: Default::default(),
            postgres_db: Default::default(),
            address: "localhost".to_owned(),
            port: 8000,
            session_key: Default::default(),
            jwt_secret: Default::default(),
            base_url: Url::parse("http://localhost:8000").unwrap(),
            google_client_id: Default::default(),
            google_client_secret: Default::default(),
            refresh_token_lifetime: Duration::days(30),
            access_token_lifetime: Duration::minutes(3),
            max_image_size: 20_000_000,
            images_query_default_limit: 50,
            images_query_max_limit: 1024,
            albums_query_default_limit: 25,
            albums_query_max_limit: 50,
            max_tags_per_resource: 32,
        }
    }
}

impl Debug for AppConfiguration {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        f.debug_struct("AppConfiguration")
            .field("app_name", &self.app_name)
            .field("postgres_host", &self.postgres_host)
            .field("postgres_user", &self.postgres_user)
            .field("postgres_password", &"<redacted>")
            .field("postgres_db", &self.postgres_db)
            .field("address", &self.address)
            .field("port", &self.port)
            .field("session_key", &"<redacted>")
            .field("jwt_secret", &"<redacted>")
            .field("base_url", &self.base_url)
            .field("google_client_id", &self.google_client_id)
            .field("google_client_secret", &"<redacted>")
            .field("refresh_token_lifetime", &self.refresh_token_lifetime)
            .field("access_token_lifetime", &self.access_token_lifetime)
            .field("max_image_size", &self.max_image_size)
            .field(
                "images_query_default_limit",
                &self.images_query_default_limit,
            )
            .field("images_query_max_limit", &self.images_query_max_limit)
            .field(
                "albums_query_default_limit",
                &self.albums_query_default_limit,
            )
            .field("albums_query_max_limit", &self.albums_query_max_limit)
            .field("max_tags_per_resource", &self.max_tags_per_resource)
            .finish()
    }
}
