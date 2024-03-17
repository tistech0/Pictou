use std::sync::Arc;

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
    PkceCodeChallenge, RedirectUrl, RevocationUrl, TokenUrl,
};
use serde::Deserialize;
use tracing::info;

use crate::{
    auth::oauth2_client::{self, OAuth2AuthorizationResponse},
    config::AppConfiguration,
};

use super::oauth2_client::OAuth2Client;

/// Exposes all HTTP routes of this module.
#[tracing::instrument(skip_all)]
pub fn routes(client: Arc<GoogleOAuth2Client>, service_cfg: &mut ServiceConfig) {
    service_cfg
        .service(authorize)
        .service(callback)
        .app_data(web::Data::from(client));
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

pub struct GoogleOAuth2Client {
    client: BasicClient,
}

impl GoogleOAuth2Client {
    pub async fn new(app_cfg: web::Data<AppConfiguration>) -> anyhow::Result<Self> {
        let client_id = app_cfg
            .google_client_id
            .as_ref()
            .ok_or_else(|| anyhow!("Google client ID not found"))?;
        let client_secret = app_cfg
            .google_client_secret
            .as_ref()
            .ok_or_else(|| anyhow!("Google client secret not found"))?;

        let open_id_config =
            reqwest::get("https://accounts.google.com/.well-known/openid-configuration")
                .await?
                .json::<GooogleOpenIdConfiguration>()
                .await?;

        if open_id_config.issuer != "https://accounts.google.com" {
            return Err(anyhow!(
                "Invalid OpenID issuer for Google, expected https://accounts.google.com, got {}",
                open_id_config.issuer
            ));
        }

        let client = BasicClient::new(
            client_id.clone(),
            Some(client_secret.clone()),
            open_id_config.authorization_endpoint,
            Some(open_id_config.token_endpoint),
        )
        .set_revocation_uri(open_id_config.revocation_endpoint)
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
            .add_scope(oauth2::Scope::new("email".to_owned()))
            .add_scope(oauth2::Scope::new("openid".to_owned()))
            .add_scope(oauth2::Scope::new("profile".to_owned()))
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

/// Represents the OpenID Connect discovery document with a Google twist.
///
/// OpenID spec: https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderMetadata
/// Google's discovery document: https://accounts.google.com/.well-known/openid-configuration
#[derive(Deserialize)]
struct GooogleOpenIdConfiguration {
    issuer: String,
    authorization_endpoint: AuthUrl,
    token_endpoint: TokenUrl,
    /// not part of the standard, but Google's discovery document includes it.
    revocation_endpoint: RevocationUrl,
}
