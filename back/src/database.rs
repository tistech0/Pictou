use std::{
    convert::Infallible,
    error::Error as StdError,
    fmt::{self, Display},
    ops::Deref,
    sync::Arc,
    time::Duration,
};

use ::r2d2::PooledConnection;
use actix_web::{error::BlockingError, http::StatusCode, web, HttpResponse, ResponseError};
use diesel::{
    r2d2::{self, ConnectionManager},
    PgConnection,
};
use tracing::{debug, error, info};

use crate::config::AppConfiguration;

pub struct Database {
    pool: r2d2::Pool<ConnectionManager<PgConnection>>,
}

/// The error type used by the database module.
#[derive(Debug)]
#[non_exhaustive]
pub enum DatabaseError<E = Infallible> {
    R2d2(::r2d2::Error),
    Blocking(BlockingError),
    Diesel(diesel::result::Error),
    #[allow(dead_code)]
    Custom(E),
}

/// The result type used by the database module.
pub type DatabaseResult<T, E = Infallible> = Result<T, DatabaseError<E>>;

impl Database {
    #[tracing::instrument(skip(app_cfg))]
    pub fn new(app_cfg: &AppConfiguration) -> DatabaseResult<Database> {
        let host = &app_cfg.postgres_host;
        let user = &app_cfg.postgres_user;
        let password = &app_cfg.postgres_password;
        let db = &app_cfg.postgres_db;

        let database_url = Self::make_database_url(user, password, host, db);
        let timeout = Duration::from_secs(5);

        info!(
            database_url = Self::make_database_url(user, "REDACTED", host, db),
            timeout_secs = timeout.as_secs(),
            "connecting to Postgres database"
        );
        let manager = ConnectionManager::<PgConnection>::new(database_url);
        let pool = r2d2::Pool::builder()
            .connection_timeout(timeout)
            .build(manager)
            .map_err(DatabaseError::R2d2)?;

        Ok(Database { pool })
    }
}

/// Opens a connection to the database and runs the given function with it.
///
/// This function is a wrapper around [`actix_web::web::block`] that automatically
/// handles the connection to the database and the error types.
///
/// # Parameters
/// The `db` parameter is a reference to the database pool, such as a [`web::Data<Database>`].
///
/// # Example
///
/// Within an Actix route:
/// ```rust,ignore
/// #[post("/example")]
/// async fn example_route(db: web::Data<Database>) -> ActixResult<HttpResponse> {
///     use crate::schema::users::dsl::*;
///
///     let first_username = database::open(db, |conn| {
///         Ok(users.select(username).limit(1).load::<String>(conn)?)
///     }).await?;
///
///     Ok(HttpResponse::Ok().body(first_username[0].clone()))
/// }
/// ```
///
/// [`web::Data<Database>`]: actix_web::web::Data
#[allow(dead_code)] // FIXME
pub async fn open<F, R, E>(
    db: impl Deref<Target = Arc<Database>> + Send + 'static,
    scope: F,
) -> DatabaseResult<R, E>
where
    F: FnOnce(&mut PooledConnection<ConnectionManager<PgConnection>>) -> DatabaseResult<R, E>
        + Send
        + 'static,
    R: Send + 'static,
    E: StdError + Send + 'static,
{
    web::block(move || {
        debug!("acquiring a connection from the pool");
        let mut conn = db.pool.get().map_err(|error| {
            debug!("here is it");
            error!(
                error = &error as &dyn StdError,
                "failed to get a connection from the pool"
            );
            DatabaseError::R2d2(error)
        })?;
        debug!("after effect");
        scope(&mut conn)
    })
    .await
    .unwrap_or_else(|err| {
        error!(
            error = &err as &dyn StdError,
            "blocking database operation failed"
        );
        Err(DatabaseError::Blocking(err))
    })
}

impl Database {
    fn make_database_url(user: &str, password: &str, host: &str, db: &str) -> String {
        format!(
            "postgres://{}:{}@{}:5432/{}",
            urlencoding::encode(user),
            urlencoding::encode(password),
            urlencoding::encode(host),
            urlencoding::encode(db)
        )
    }
}

impl<E: Display> Display for DatabaseError<E> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            DatabaseError::R2d2(err) => err.fmt(f),
            DatabaseError::Blocking(err) => err.fmt(f),
            DatabaseError::Diesel(err) => err.fmt(f),
            DatabaseError::Custom(err) => err.fmt(f),
        }
    }
}

impl<E: StdError + 'static> StdError for DatabaseError<E> {
    fn source(&self) -> Option<&(dyn StdError + 'static)> {
        match self {
            DatabaseError::R2d2(err) => Some(err),
            DatabaseError::Blocking(err) => Some(err),
            DatabaseError::Diesel(err) => Some(err),
            DatabaseError::Custom(err) => Some(err),
        }
    }
}

/// Allows `DatabaseError` to be directly converted to an HTTP response,
/// provided the wrapped Error implements [`ResponseError`] as well.
impl<E: ResponseError> ResponseError for DatabaseError<E> {
    fn status_code(&self) -> StatusCode {
        match self {
            DatabaseError::Custom(err) => err.status_code(),
            _ => StatusCode::INTERNAL_SERVER_ERROR,
        }
    }

    fn error_response(&self) -> HttpResponse<actix_web::body::BoxBody> {
        match self {
            DatabaseError::Custom(err) => err.error_response(),
            _ => HttpResponse::NotFound().finish(),
        }
    }
}

impl From<::r2d2::Error> for DatabaseError {
    fn from(err: ::r2d2::Error) -> Self {
        DatabaseError::R2d2(err)
    }
}

impl From<BlockingError> for DatabaseError {
    fn from(err: BlockingError) -> Self {
        DatabaseError::Blocking(err)
    }
}

impl From<diesel::result::Error> for DatabaseError {
    fn from(err: diesel::result::Error) -> Self {
        DatabaseError::Diesel(err)
    }
}
