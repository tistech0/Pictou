use actix_session::Session;
use actix_web::{
    error::Error,
    get,
    web::Query,
    web::{self, ServiceConfig},
    HttpResponse,
};
use anyhow::anyhow;
use oauth2::{
    basic::{BasicClient, BasicErrorResponse, BasicTokenResponse, BasicTokenType},
    AuthUrl, AuthorizationCode, AuthorizationRequest, CodeTokenRequest, CsrfToken,
    PkceCodeChallenge, RedirectUrl, TokenUrl,
};
use tracing::{error, info, warn};

use crate::{
    auth::oauth2_client::{self, OAuth2AuthorizationResponse},
    config::AppConfiguration,
};

use super::oauth2_client::OAuth2Client;

/// Exposes all HTTP routes of this module.
#[tracing::instrument(skip_all)]
pub fn routes(service_cfg: &mut ServiceConfig, app_cfg: web::Data<AppConfiguration>) {
    match GoogleOAuth2Client::new(app_cfg) {
        Err(error) => {
            error!(%error, "failed to create Google OAuth2 client, Google login is now disabled!")
        }
        Ok(google_client) => {
            service_cfg
                .service(authorize)
                .service(callback)
                .app_data(web::Data::new(google_client));
        }
    }
}

#[get("/auth/google/authorize")]
async fn authorize(
    client: web::Data<GoogleOAuth2Client>,
    session: Session,
) -> Result<HttpResponse, Error> {
    info!("Received request for Google OAuth2 authorization");
    oauth2_client::begin_authorization(client.as_ref(), session)
}

#[get("/auth/google/callback")]
async fn callback(
    client: web::Data<GoogleOAuth2Client>,
    session: Session,
    query: Query<OAuth2AuthorizationResponse>,
) -> Result<HttpResponse, Error> {
    info!("Received callback request for Google OAuth2 authorization");
    oauth2_client::finish_authorization(client.as_ref(), query.into_inner(), session).await
}

struct GoogleOAuth2Client {
    client: BasicClient,
}

impl GoogleOAuth2Client {
    pub fn new(app_cfg: web::Data<AppConfiguration>) -> anyhow::Result<Self> {
        let client_id = app_cfg
            .google_client_id
            .as_ref()
            .ok_or_else(|| anyhow!("Google client ID not found"))?;
        let client_secret = app_cfg
            .google_client_secret
            .as_ref()
            .ok_or_else(|| anyhow!("Google client secret not found"))?;

        let client = BasicClient::new(
            client_id.clone(),
            Some(client_secret.clone()),
            AuthUrl::new("https://accounts.google.com/o/oauth2/v2/auth".to_owned())?,
            Some(TokenUrl::new(
                "https://oauth2.googleapis.com/token".to_owned(),
            )?),
        )
        .set_redirect_uri(
            RedirectUrl::new("http://localhost:8000/auth/google/callback".to_string()).unwrap(),
        );

        Ok(Self { client })
    }
}

impl OAuth2Client for GoogleOAuth2Client {
    fn new_authorization_request(&self, pkce_challenge: PkceCodeChallenge) -> AuthorizationRequest {
        self.client
            .authorize_url(CsrfToken::new_random)
            // Set the desired scopes.
            .add_scope(oauth2::Scope::new(
                "https://www.googleapis.com/auth/userinfo.email".to_owned(),
            ))
            .add_scope(oauth2::Scope::new(
                "https://www.googleapis.com/auth/userinfo.profile".to_owned(),
            ))
            // Set the PKCE code challenge.
            .set_pkce_challenge(pkce_challenge)
            // Tells Google to add the "refresh_token" field
            .add_extra_param("access_type", "offline")
    }

    fn new_code_token_request(
        &self,
        code: AuthorizationCode,
    ) -> CodeTokenRequest<BasicErrorResponse, BasicTokenResponse, BasicTokenType> {
        self.client.exchange_code(code)
    }
}
