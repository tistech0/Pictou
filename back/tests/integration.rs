use std::{collections::HashMap, sync::Arc};

use actix_web::web;
use anyhow::Context;
use diesel::{prelude::Insertable, RunQueryDsl};
use pictou::{
    auth::{AuthenticationResponse, ClientType},
    config::AppConfiguration,
    database::{self, SimpleDatabaseError, TestingDatabase},
};
use reqwest::header::HeaderValue;
use time::ext::NumericalDuration;
use time::OffsetDateTime;
use tokio::{sync::Notify, task::JoinHandle};
use uuid::Uuid;

#[derive(Insertable, Clone)]
#[diesel(table_name = pictou::schema::users)]
struct NewUser {
    id: Uuid,
    email: String,
    name: String,
    auth_type: Option<ClientType>,
    refresh_token: String,
    refresh_token_exp: OffsetDateTime,
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
    /// Launches the server and wait for it to be ready.
    pub async fn enter() -> anyhow::Result<Self> {
        let log_guard = pictou::log::init();
        dotenv::from_filename("test.env")?;

        let app_cfg = web::Data::from(AppConfiguration::from_env()?);
        let db = TestingDatabase::get(&app_cfg).await?;
        db.truncate_all().await?;

        let server_ready = Arc::new(Notify::new());

        let server = tokio::task::spawn({
            let app_cfg = app_cfg.clone();
            let server_ready = server_ready.clone();
            async {
                pictou::start_server(app_cfg, server_ready).await.unwrap();
            }
        });

        // Wait for the server
        server_ready.notified().await;

        Ok(Self {
            log_guard,
            app_cfg,
            server,
            db,
        })
    }

    pub fn app_cfg(&self) -> &AppConfiguration {
        &self.app_cfg
    }

    pub async fn add_user(&self, user: NewUser) -> anyhow::Result<()> {
        database::open(self.db.clone(), move |conn| {
            diesel::insert_into(pictou::schema::users::table)
                .values(&user)
                .execute(conn)
                .map_err(SimpleDatabaseError::from)
        })
        .await
        .context("failed to add testing user")?;
        Ok(())
    }

    pub async fn add_default_user(&self) -> anyhow::Result<NewUser> {
        let user = NewUser {
            id: Uuid::parse_str("6670f9f0-77d4-41bd-99b0-5daf6a925b63").unwrap(),
            email: "test@example.com".to_owned(),
            name: "Test User".to_owned(),
            auth_type: None,
            refresh_token: "test".to_owned(),
            refresh_token_exp: OffsetDateTime::now_utc() + 1.days(),
        };
        self.add_user(user.clone()).await?;
        Ok(user)
    }

    pub async fn login(
        &self,
        client: &reqwest::Client,
        user: &NewUser,
    ) -> anyhow::Result<AuthenticationResponse> {
        let mut body = HashMap::new();
        body.insert("user_id", user.id.to_string());
        body.insert("refresh_token", user.refresh_token.clone());

        let res = client
            .post(self.app_cfg.base_url.join("api/auth/refresh")?)
            .json(&body)
            .send()
            .await
            .context("failed to send login request")?;

        assert_eq!(res.status(), 200);

        res.json::<AuthenticationResponse>().await.context("")
    }
}

#[actix_rt::test]
#[tracing::instrument]
async fn experimental_test() -> anyhow::Result<()> {
    let scope = IntegrationTestScope::enter().await?;
    let user = scope.add_default_user().await?;

    let client = reqwest::Client::new();

    let login = scope.login(&client, &user).await?;
    let token = HeaderValue::from_str(&format!("Bearer {}", login.access_token))?;

    let self_user_res = client
        .get(scope.app_cfg().base_url.join("api/users/self")?)
        .header("Authorization", token)
        .send()
        .await?;
    assert_eq!(self_user_res.status(), 200);

    Ok(())
}
