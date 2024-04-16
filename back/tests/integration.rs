use actix_web::web;
use diesel::prelude::Insertable;
use pictou::{config::AppConfiguration, database::TestingDatabase};
use tokio::task::JoinHandle;

#[derive(Insertable)]
#[diesel(table_name = pictou::schema::users)]
struct NewUser {
    email: String,
    name: Option<String>,
}

#[allow(dead_code)]
struct IntegrationTestScope {
    log_guard: pictou::log::Guard,
    app_cfg: web::Data<AppConfiguration>,
    server: JoinHandle<()>,
    db: TestingDatabase,
}

impl IntegrationTestScope {
    /// Sets up a full integration test environment.
    async fn enter() -> anyhow::Result<Self> {
        let log_guard = pictou::log::init();
        dotenv::from_filename("test.env")?;

        let app_cfg = web::Data::from(AppConfiguration::from_env()?);
        let db = TestingDatabase::get(&app_cfg).await?;
        db.truncate_all().await?;

        let server = tokio::task::spawn({
            let app_cfg = app_cfg.clone();
            async {
                pictou::start_server(app_cfg).await.unwrap();
            }
        });

        Ok(Self {
            log_guard,
            app_cfg,
            server,
            db,
        })
    }
}

#[actix_rt::test]
#[tracing::instrument]
async fn experimental_test() -> anyhow::Result<()> {
    let _scope = IntegrationTestScope::enter().await?;

    tokio::time::sleep(std::time::Duration::from_secs(1)).await;

    Ok(())
}
