use std::{
    error::Error as StdError,
    ops::Deref,
    sync::{Arc, OnceLock},
};

use crate::{
    config::AppConfiguration,
    database::{Database, SimpleDatabaseError},
};
use actix_web::web;
use anyhow::{anyhow, Context};
use diesel::{deserialize::QueryableByName, migration::MigrationSource, pg::Pg, row::NamedRow};
use diesel_migrations::FileBasedMigrations;
use tracing::{debug, error, info};

use super::{DatabaseError, DatabaseResult, ToDatabasePointer};

/// Singleton database connection used by integration tests.
#[derive(Clone)]
#[repr(transparent)]
pub struct TestingDatabase(Arc<Database>);

impl Deref for TestingDatabase {
    type Target = Database;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl TestingDatabase {
    /// Fetch a reference to the test database, initializing it if needed.
    #[tracing::instrument(skip_all)]
    pub async fn get(app_cfg: &AppConfiguration) -> anyhow::Result<TestingDatabase> {
        static INSTANCE: OnceLock<TestingDatabase> = OnceLock::new();

        match INSTANCE.get() {
            Some(db) => Ok(db.clone()),
            None => {
                info!("Creating new database instance");
                let db = TestingDatabase(Arc::new(Database::new(app_cfg)?));
                db.run_migrations().await?;
                INSTANCE
                    .set(db.clone())
                    .map_err(|_| anyhow!("Failed to set instance"))?;
                Ok(db)
            }
        }
    }

    /// Truncates **ALL** the tables in the schema
    pub async fn truncate_all(&self) -> anyhow::Result<()> {
        crate::database::open(self.0.clone(), |conn| {
            use diesel::prelude::*;

            let names: Vec<TableName> = diesel::sql_query(
                r#"
                SELECT table_name
                FROM information_schema.tables
                where table_type = 'BASE TABLE'
                  AND table_schema = 'public'
                  AND table_name <> '__diesel_schema_migrations'"#,
            )
            .get_results(conn)
            .map_err(SimpleDatabaseError::from)?;

            if names.is_empty() {
                return Ok(());
            }

            let query = diesel::sql_query("TRUNCATE TABLE ")
                .sql(
                    names
                        .iter()
                        .map(|n| &n.0 as &str)
                        .collect::<Vec<_>>()
                        .join(", "),
                )
                .sql(" RESTART IDENTITY CASCADE");

            debug!(
                "truncating test DB: {}",
                diesel::debug_query::<Pg, _>(&query)
            );

            query.execute(conn).map_err(SimpleDatabaseError::from)?;

            Ok(())
        })
        .await
        .context("Failed to reset database")
    }

    pub async fn run_migrations(&self) -> anyhow::Result<()> {
        let source = FileBasedMigrations::find_migrations_directory()?;
        run_migrations(self.0.clone(), source)
            .await
            .map_err(|err| anyhow!(err))
    }

    pub async fn start() -> anyhow::Result<TestingDatabase> {
        let app_cfg = AppConfiguration::from_env()?;
        let db = TestingDatabase::get(&app_cfg).await?;
        db.truncate_all().await?;
        Ok(db)
    }
}

impl ToDatabasePointer for TestingDatabase {
    fn to_database_ptr(&self) -> Arc<Database> {
        self.0.clone()
    }
}

/// Runs all pending migrations on the given database.
pub async fn run_migrations<S>(
    db: impl ToDatabasePointer + Send + 'static,
    source: S,
) -> DatabaseResult<(), Box<dyn StdError + Send + Sync>>
where
    S: MigrationSource<diesel::pg::Pg> + Send + 'static,
{
    let db = db.to_database_ptr();

    web::block(move || {
        let mut conn = db.pool.get().map_err(DatabaseError::R2d2)?;

        match ::diesel_migrations::MigrationHarness::run_pending_migrations(&mut conn, source) {
            Ok(_) => Ok(()),
            Err(err) => Err(DatabaseError::Custom(err)),
        }
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

struct TableName(String);

impl QueryableByName<Pg> for TableName {
    fn build<'a>(row: &impl NamedRow<'a, Pg>) -> diesel::deserialize::Result<Self> {
        NamedRow::get::<_, String>(row, "table_name").map(TableName)
    }
}
