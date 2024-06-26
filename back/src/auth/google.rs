use std::{
    borrow::Cow,
    fmt::{self, Debug},
};

use actix_web::web;
use anyhow::anyhow;
use oauth2::{
    basic::{BasicClient, BasicErrorResponse, BasicTokenResponse, BasicTokenType},
    AuthUrl, AuthorizationCode, AuthorizationRequest, CodeTokenRequest, CsrfToken,
    PkceCodeChallenge, RedirectUrl, RefreshToken, RefreshTokenRequest, RevocationUrl, TokenUrl,
};
use serde::Deserialize;

use crate::{auth::oauth2_client::UserInfoRequest, config::AppConfiguration};

use super::oauth2_client::{ClientType, OAuth2Client};

pub struct GoogleOAuth2Client {
    client: BasicClient,
    userinfo_endpoint: String,
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

        let http_client = reqwest::Client::builder()
            .redirect(reqwest::redirect::Policy::none())
            .build()?;

        let open_id_config = http_client
            .get("https://accounts.google.com/.well-known/openid-configuration")
            .send()
            .await?
            .error_for_status()?
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
        .set_redirect_uri(RedirectUrl::from_url(
            app_cfg.base_url.join("api/auth/callback/google").unwrap(),
        ));

        Ok(Self {
            client,
            userinfo_endpoint: open_id_config.userinfo_endpoint,
        })
    }
}

impl OAuth2Client for GoogleOAuth2Client {
    fn client_type(&self) -> ClientType {
        ClientType::Google
    }

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

    fn new_user_info_request(&self) -> UserInfoRequest {
        UserInfoRequest::new(Cow::from(&self.userinfo_endpoint))
    }

    fn new_refresh_token_request<'a>(
        &'a self,
        refresh_token: &'a RefreshToken,
    ) -> RefreshTokenRequest<'a, BasicErrorResponse, BasicTokenResponse, BasicTokenType> {
        self.client.exchange_refresh_token(refresh_token)
    }
}

impl Debug for GoogleOAuth2Client {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("GoogleOAuth2Client").finish_non_exhaustive()
    }
}

/// Represents the OpenID Connect discovery document with a Google twist.
///
/// OpenID spec: `https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderMetadata`
/// Google's discovery document: `https://accounts.google.com/.well-known/openid-configuration`
#[derive(Deserialize)]
struct GooogleOpenIdConfiguration {
    issuer: String,
    authorization_endpoint: AuthUrl,
    token_endpoint: TokenUrl,
    userinfo_endpoint: String,
    /// not part of the standard, but Google's discovery document includes it.
    revocation_endpoint: RevocationUrl,
}
