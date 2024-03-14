use actix_session::Session;
use actix_web::{
    error::{Error, ErrorUnauthorized},
    get,
    web::Query,
    web::{self, ServiceConfig},
    HttpResponse,
};
use anyhow::anyhow;
use oauth2::{
    basic::BasicClient, AuthUrl, AuthorizationCode, CsrfToken, PkceCodeChallenge, RedirectUrl,
    RequestTokenError, TokenResponse, TokenUrl,
};
use serde::{de::DeserializeOwned, Serialize};
use tracing::{error, info, warn};

use crate::{
    auth::oauth2_client::{self, OAuth2AuthorizationResponse},
    config::AppConfiguration,
};

/// Exposes all HTTP routes of this module.
#[tracing::instrument(skip(service_cfg, app_cfg))]
pub fn routes(service_cfg: &mut ServiceConfig, app_cfg: web::Data<AppConfiguration>) {
    match google_oauth_client(app_cfg) {
        Err(error) => {
            error!(%error, "failed to create Google OAuth2 client, Google login is now disabled!")
        }
        Ok(google_client) => {
            service_cfg
                .service(index)
                .service(callback)
                .app_data(web::Data::new(google_client));
        }
    }
}

fn google_oauth_client(app_cfg: web::Data<AppConfiguration>) -> anyhow::Result<BasicClient> {
    let client_id = app_cfg
        .google_client_id
        .as_ref()
        .ok_or_else(|| anyhow!("Google client ID not found"))?;
    let client_secret = app_cfg
        .google_client_secret
        .as_ref()
        .ok_or_else(|| anyhow!("Google client secret not found"))?;

    let google_client = BasicClient::new(
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

    Ok(google_client)
}

const PKCE_SECRET_SESSION_KEY: &str = "pkce_secret";
const STATE_TOKEN_SESSION_KEY: &str = "OAUTH2_STATE_TOKEN";

#[get("/auth/google")]
async fn index(client: web::Data<BasicClient>, session: Session) -> Result<HttpResponse, Error> {
    let span = tracing::info_span!("index");
    let _guard = span.enter();
    info!(parent: &span, "Received request for Google OAuth2 authorization");
    // Generate a PKCE challenge.
    let (pkce_challenge, pkce_verifier) = PkceCodeChallenge::new_random_sha256();
    let pkce_secret = pkce_verifier.secret();

    // Generate the full authorization URL.
    let (auth_url, state_token) = client
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
        .url();

    // Store CSRF state and PKCE secret in the session
    store_in_session(&session, STATE_TOKEN_SESSION_KEY, state_token.secret())?;
    store_in_session(&session, PKCE_SECRET_SESSION_KEY, pkce_secret)?;

    // Let the user browse to `auth_url`
    Ok(HttpResponse::Found()
        .append_header(("Location", auth_url.to_string()))
        .finish())
}

#[derive(Serialize)]
struct CallbackResponse {
    access_token: String,
    /// Not present on subsequent auth requests.
    refresh_token: Option<String>,
    /// expiry time, in milliseconds.
    expires_in: Option<u64>,
}

#[get("/auth/google/callback")]
async fn callback(
    client: web::Data<BasicClient>,
    session: Session,
    query: Query<OAuth2AuthorizationResponse>,
) -> Result<HttpResponse, Error> {
    info!("Received callback request for Google OAuth2 authorization");

    let saved_state: String = read_from_session(&session, STATE_TOKEN_SESSION_KEY)?;
    let pkce_secret: String = read_from_session(&session, PKCE_SECRET_SESSION_KEY)?;

    let code = oauth2_client::handle_authorization_response(query.into_inner(), &saved_state)?;

    // Retrieve the PKCE verifier from the session
    let pkce_verifier = oauth2::PkceCodeVerifier::new(pkce_secret.clone());

    let token_result = client
        .exchange_code(AuthorizationCode::new(code))
        // Set the PKCE code verifier.
        .set_pkce_verifier(pkce_verifier)
        .request_async(oauth2::reqwest::async_http_client)
        .await
        .map_err(|error| {
            match error {
                RequestTokenError::ServerResponse(error) => {
                    warn!(%error, "oauth2 provider returned error")
                }
                RequestTokenError::Request(error) => {
                    warn!(%error, "error while requesting oauth code exchange")
                }
                RequestTokenError::Parse(error, _) => {
                    warn!(%error, "failed to parse oauth2 provider response")
                }
                RequestTokenError::Other(error) => {
                    warn!(%error, "error while exchanging oauth code")
                }
            }
            ErrorUnauthorized("failed to authenticate with provider")
        })?;

    // FIXME: return all the token as-is for now, figure out what to do with them later
    Ok(HttpResponse::Ok().json(CallbackResponse {
        access_token: token_result.access_token().secret().clone(),
        refresh_token: token_result.refresh_token().map(|t| t.secret().clone()),
        expires_in: token_result.expires_in().map(|d| d.as_millis() as u64),
    }))
}

fn store_in_session<T: Serialize>(session: &Session, key: &str, value: T) -> Result<(), Error> {
    session.insert(key, value).map_err(|error| {
        error!(%error, "failed to insert {} to session", key);
        ErrorUnauthorized("failed to retrieve session")
    })
}

fn read_from_session<T: DeserializeOwned>(session: &Session, key: &str) -> Result<T, Error> {
    match session.get::<T>(key) {
        Err(error) => {
            error!(%error, "failed to retrieve {} from session", key);
            Err(ErrorUnauthorized("failed to retrieve session"))
        }
        Ok(None) => {
            error!("missing {} key from session", key);
            Err(ErrorUnauthorized("failed to retrieve session"))
        }
        Ok(Some(secret)) => Ok(secret),
    }
}
