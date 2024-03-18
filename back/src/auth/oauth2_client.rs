//! Common utilities for OAuth2 clients.

use std::{borrow::Cow, error::Error as StdError, fmt::Debug, sync::Arc};

use actix_session::Session;
use actix_web::{
    error::{Error as ActixError, ErrorUnauthorized, Result as ActixResult},
    web, HttpResponse,
};
use anyhow::anyhow;
use diesel::{prelude::Insertable, query_builder::AsChangeset};
use diesel_derive_enum::DbEnum;
use oauth2::{
    basic::{BasicErrorResponse, BasicTokenResponse, BasicTokenType},
    AccessToken, AuthorizationCode, AuthorizationRequest, CodeTokenRequest, PkceCodeChallenge,
    RefreshToken, RefreshTokenRequest, RequestTokenError, TokenResponse,
};
use serde::{de::DeserializeOwned, Deserialize, Serialize};
use time::OffsetDateTime;
use tracing::{error, info, warn};

use crate::{
    auth::{
        error::AuthErrorKind, google::GoogleOAuth2Client, AuthContext, AuthenticationResponse,
        PersistedUserInfo,
    },
    config::AppConfiguration,
    database::{self, Database, DatabaseError},
};

use super::error::AuthError;

/// Provides references to all currently loaded clients.
#[derive(Clone)]
pub struct OAuth2Clients {
    google: Option<Arc<GoogleOAuth2Client>>,
    /// Same pointer as `google`, but as a trait object.
    google_dyn: Option<Arc<DynOAuth2Client>>,
}

pub type DynOAuth2Client = dyn OAuth2Client + Send + Sync + 'static;

impl OAuth2Clients {
    #[tracing::instrument(skip_all)]
    pub async fn new(app_cfg: web::Data<AppConfiguration>) -> Self {
        let google = match GoogleOAuth2Client::new(app_cfg).await {
            Err(error) => {
                error!(%error, "failed to create Google OAuth2 client, Google login is now disabled!");
                None
            }
            Ok(google) => Some(Arc::new(google)),
        };
        let google_dyn = google.clone().map(|c| c as Arc<DynOAuth2Client>);
        OAuth2Clients { google, google_dyn }
    }

    /// Returns a reference to the Google client, if enabled.
    pub fn google(&self) -> Option<&Arc<GoogleOAuth2Client>> {
        self.google.as_ref()
    }

    /// Returns the coresponding OAuth2 client for the given `ClientType` as a trait object
    /// pointer.
    pub fn get(&self, client_type: ClientType) -> Option<&Arc<DynOAuth2Client>> {
        match client_type {
            ClientType::Google => self.google_dyn.as_ref(),
        }
    }
}

#[derive(DbEnum, Debug, Clone, Copy, PartialEq, Eq)]
#[ExistingTypePath = "crate::schema::sql_types::AuthType"]
pub enum ClientType {
    Google,
}

pub trait OAuth2Client: Debug {
    fn client_type(&self) -> ClientType;

    fn new_authorization_request(&self, pkce_challenge: PkceCodeChallenge) -> AuthorizationRequest;

    fn new_code_token_request(
        &self,
        code: AuthorizationCode,
    ) -> CodeTokenRequest<BasicErrorResponse, BasicTokenResponse, BasicTokenType>;

    fn new_user_info_request(&self) -> UserInfoRequest;

    fn new_refresh_token_request<'a>(
        &'a self,
        refresh_token: &'a RefreshToken,
    ) -> RefreshTokenRequest<'a, BasicErrorResponse, BasicTokenResponse, BasicTokenType>;
}

#[derive(Serialize)]
struct CallbackResponse {
    access_token: String,
    /// Not present on subsequent auth requests.
    refresh_token: Option<String>,
    /// expiry time, in milliseconds.
    expires_in: Option<u64>,
}

/// Represent the response sent by OAuth2 servers as query parameters.
///
/// See `https://www.oauth.com/oauth2-servers/authorization/the-authorization-response`.
#[derive(Debug, Deserialize)]
pub struct OAuth2AuthorizationResponse {
    code: Option<AuthorizationCode>,
    #[serde(default)]
    state: String,
    error: Option<String>,
    error_description: Option<String>,
    error_uri: Option<String>,
}

/// Begins the OAuth2 authorization process by redirecting the user to the authorization URL.
pub fn begin_authorization<C>(client: &C, session: Session) -> ActixResult<HttpResponse>
where
    C: OAuth2Client + ?Sized,
{
    // Generate a PKCE challenge.
    let (pkce_challenge, pkce_verifier) = PkceCodeChallenge::new_random_sha256();
    let pkce_secret = pkce_verifier.secret();

    // Generate the full authorization URL.
    let (auth_url, state_token) = client.new_authorization_request(pkce_challenge).url();

    // Store CSRF state and PKCE secret in the session
    store_in_session(&session, STATE_TOKEN_SESSION_KEY, state_token.secret())?;
    store_in_session(&session, PKCE_SECRET_SESSION_KEY, pkce_secret)?;

    // Let the user browse to `auth_url`
    Ok(HttpResponse::Found()
        .append_header(("Location", auth_url.to_string()))
        .finish())
}

/// Finishes the OAuth2 authorization process by exchanging the authorization code for an access token.
/// Called by the OAuth2 provider after the user has authorized the application.
#[tracing::instrument(skip(response, session, db, app_cfg))]
pub async fn finish_authorization<C>(
    client: &C,
    response: OAuth2AuthorizationResponse,
    session: Session,
    db: Arc<Database>,
    app_cfg: &AppConfiguration,
) -> ActixResult<HttpResponse>
where
    C: OAuth2Client + ?Sized,
{
    let saved_state: String = read_from_session(&session, STATE_TOKEN_SESSION_KEY)?;
    let pkce_secret: String = read_from_session(&session, PKCE_SECRET_SESSION_KEY)?;

    let code = handle_authorization_response(response, &saved_state)?;
    let token_result = fetch_tokens(client, pkce_secret, code).await?;
    let user_info = fetch_user_info(client, token_result.access_token()).await?;

    let email = user_info.email.clone().ok_or_else(|| {
        error!("missing email in user info response");
        AuthErrorKind::OAuth2ProviderError.to_error()
    })?;
    let auth_type = client.client_type();
    let refresh_token = AuthContext::generate_refresh_token();
    let refresh_token_exp = OffsetDateTime::now_utc() + app_cfg.refresh_token_lifetime;

    info!(
        email,
        ?auth_type,
        "recieved user info from OAuth2 provider, saving user to database"
    );

    let user: PersistedUserInfo = database::open(db, move |conn| {
        use crate::schema::users;
        use diesel::prelude::*;

        let mut oauth_token: Option<String> =
            token_result.refresh_token().map(|t| t.secret().to_owned());

        if oauth_token.is_none() {
            // happens when the user authorizes again without revoking the previous authorization.
            info!(
                email,
                ?auth_type,
                "recieved null OAuth2 refresh token, using previous value from DB"
            );
            oauth_token = users::table
                .select(users::oauth_token)
                .filter(users::email.eq(&email).and(users::auth_type.eq(auth_type)))
                .get_result::<Option<String>>(conn)
                .optional()?
                .flatten();
        }

        let to_persist = NewUser {
            email,
            auth_type,
            refresh_token,
            refresh_token_exp,
            oauth_token,
            name: user_info.name,
            given_name: user_info.given_name,
            family_name: user_info.family_name,
        };

        // Try to insert a new user into the table, or update the existing one.
        diesel::insert_into(users::table)
            .values(&to_persist)
            .on_conflict(users::email)
            .do_update()
            .set(&to_persist)
            .returning(PersistedUserInfo::as_returning())
            .get_result(conn)
            .map_err(DatabaseError::from)
    })
    .await
    .map_err(ActixError::from)?;

    let access_token_exp = OffsetDateTime::now_utc() + app_cfg.access_token_lifetime;
    let access_token = AuthContext::encode_jwt(
        user.user_id,
        access_token_exp,
        &app_cfg.app_name,
        &app_cfg.jwt_secret,
    )?;

    Ok(HttpResponse::Ok().json(AuthenticationResponse {
        user,
        access_token,
        access_token_exp,
    }))
}

/// Handle the response from an OAuth2 authorization request.
/// Returns the authorization code if the request was successful.
/// Otherwise, returns an error response.
#[tracing::instrument(skip_all)]
fn handle_authorization_response(
    response: OAuth2AuthorizationResponse,
    expected_state: &str,
) -> Result<AuthorizationCode, AuthError> {
    match response {
        OAuth2AuthorizationResponse {
            error: Some(error), ..
        } if error == "access_denied" => Err(AuthErrorKind::OAuth2AuthorizationDenied.to_error()),
        OAuth2AuthorizationResponse {
            error: Some(error),
            error_description,
            error_uri,
            ..
        } => {
            warn!(
                error,
                error_description, error_uri, "Authorization provider returned an error"
            );
            Err(AuthErrorKind::OAuth2ProviderError.with_cause(anyhow!(error)))
        }
        OAuth2AuthorizationResponse { code: None, .. } => {
            warn!("Missing code in authorization response");
            Err(AuthErrorKind::OAuth2ProviderError.to_error())
        }
        OAuth2AuthorizationResponse {
            code: Some(code),
            state,
            ..
        } => {
            if state != expected_state {
                Err(AuthErrorKind::OAuth2InvalidState.to_error())
            } else {
                Ok(code)
            }
        }
    }
}

#[tracing::instrument(skip(code))]
async fn fetch_tokens<C>(
    client: &C,
    pkce_secret: String,
    code: AuthorizationCode,
) -> Result<BasicTokenResponse, AuthError>
where
    C: OAuth2Client + ?Sized,
{
    let pkce_verifier = oauth2::PkceCodeVerifier::new(pkce_secret.clone());

    client
        .new_code_token_request(code)
        .set_pkce_verifier(pkce_verifier)
        .request_async(oauth2::reqwest::async_http_client)
        .await
        .map_err(|error| {
            match &error {
                RequestTokenError::ServerResponse(error) => {
                    warn!(%error, "oauth2 provider returned error");
                }
                RequestTokenError::Request(error) => {
                    warn!(%error, "error while requesting oauth code exchange");
                }
                RequestTokenError::Parse(error, _) => {
                    warn!(%error, "failed to parse oauth2 provider response");
                }
                RequestTokenError::Other(error) => {
                    warn!(%error, "error while exchanging oauth code");
                }
            };
            AuthErrorKind::OAuth2ProviderError.with_cause(error)
        })
}

#[tracing::instrument(skip(token))]
pub async fn refresh_token<C>(client: &C, token: &RefreshToken) -> Result<AccessToken, AuthError>
where
    C: OAuth2Client + ?Sized,
{
    client
        .new_refresh_token_request(token)
        .request_async(oauth2::reqwest::async_http_client)
        .await
        .map(|r| r.access_token().clone())
        .map_err(|error| {
            match &error {
                RequestTokenError::ServerResponse(error) => {
                    warn!(%error, "oauth2 provider returned error");
                }
                RequestTokenError::Request(error) => {
                    warn!(%error, "error while requesting oauth token refresh");
                }
                RequestTokenError::Parse(error, _) => {
                    warn!(%error, "failed to parse oauth2 provider response");
                }
                RequestTokenError::Other(error) => {
                    warn!(%error, "error while exchanging oauth refresh token");
                }
            };
            AuthErrorKind::OAuth2ProviderError.with_cause(error)
        })
}

#[tracing::instrument(skip(token))]
pub async fn fetch_user_info<C>(client: &C, token: &AccessToken) -> Result<UserInfo, AuthError>
where
    C: OAuth2Client + ?Sized,
{
    let endpoint = client.new_user_info_request().endpoint;

    let http_client = reqwest::Client::builder()
        .redirect(reqwest::redirect::Policy::none())
        .build()
        .map_err(|error| {
            error!(
                error = &error as &dyn StdError,
                "failed to create HTTP client"
            );
            AuthErrorKind::InternalError.with_cause(error)
        })?;

    http_client
        .get(endpoint.as_ref())
        .bearer_auth(token.secret())
        .send()
        .await
        .map_err(|error| {
            error!(
                error = &error as &dyn StdError,
                "failed to send HTTP request"
            );
            AuthErrorKind::InternalError.with_cause(error)
        })?
        .error_for_status()
        .map_err(|error| {
            warn!(
                error = &error as &dyn StdError,
                "recieved error response from OAuth2 provider"
            );
            AuthErrorKind::OAuth2Forbidden.with_cause(error)
        })?
        .json::<UserInfo>()
        .await
        .map_err(|error| {
            warn!(
                error = &error as &dyn StdError,
                "could not parse user info response"
            );
            AuthErrorKind::OAuth2ProviderError.with_cause(error)
        })
}

pub struct UserInfoRequest<'a> {
    endpoint: Cow<'a, str>,
}

impl<'a> UserInfoRequest<'a> {
    pub fn new(endpoint: Cow<'a, str>) -> Self {
        Self { endpoint }
    }
}

#[derive(Deserialize, Debug)]
#[allow(dead_code)]
pub struct UserInfo {
    pub sub: String,
    pub name: Option<String>,
    pub given_name: Option<String>,
    pub family_name: Option<String>,
    pub picture: Option<String>,
    pub email: Option<String>,
    pub email_verified: Option<bool>,
}

#[derive(Insertable, AsChangeset)]
#[diesel(table_name = crate::schema::users)]
struct NewUser {
    email: String,
    auth_type: ClientType,
    refresh_token: String,
    refresh_token_exp: OffsetDateTime,
    oauth_token: Option<String>,
    name: Option<String>,
    given_name: Option<String>,
    family_name: Option<String>,
}

const PKCE_SECRET_SESSION_KEY: &str = "pkce_secret";
const STATE_TOKEN_SESSION_KEY: &str = "OAUTH2_STATE_TOKEN";

fn store_in_session<T: Serialize>(session: &Session, key: &str, value: T) -> ActixResult<()> {
    session.insert(key, value).map_err(|error| {
        error!(%error, "failed to insert {} to session", key);
        ErrorUnauthorized("failed to retrieve session")
    })
}

fn read_from_session<T: DeserializeOwned>(session: &Session, key: &str) -> ActixResult<T> {
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_handle_authorization_response() {
        let response = OAuth2AuthorizationResponse {
            code: Some(AuthorizationCode::new("code".to_owned())),
            state: "state".to_string(),
            error: None,
            error_description: None,
            error_uri: None,
        };
        assert_eq!(
            handle_authorization_response(response, "state")
                .map(|c| c.secret().clone())
                .map_err(|e| e.kind()),
            Ok("code".to_owned())
        );

        let response = OAuth2AuthorizationResponse {
            code: Some(AuthorizationCode::new("code".to_owned())),
            state: "state".to_string(),
            error: None,
            error_description: None,
            error_uri: None,
        };
        assert_eq!(
            handle_authorization_response(response, "invalid")
                .map(|c| c.secret().clone())
                .map_err(|e| e.kind()),
            Err(AuthErrorKind::OAuth2InvalidState)
        );

        let response = OAuth2AuthorizationResponse {
            code: Some(AuthorizationCode::new("code".to_owned())),
            state: "state".to_string(),
            error: Some("access_denied".to_string()),
            error_description: None,
            error_uri: None,
        };
        assert_eq!(
            handle_authorization_response(response, "state")
                .map(|c| c.secret().clone())
                .map_err(|e| e.kind()),
            Err(AuthErrorKind::OAuth2AuthorizationDenied)
        );

        let response = OAuth2AuthorizationResponse {
            code: None,
            state: "state".to_string(),
            error: None,
            error_description: None,
            error_uri: None,
        };
        assert_eq!(
            handle_authorization_response(response, "state")
                .map(|c| c.secret().clone())
                .map_err(|e| e.kind()),
            Err(AuthErrorKind::OAuth2ProviderError)
        );

        let response = OAuth2AuthorizationResponse {
            code: Some(AuthorizationCode::new("code".to_owned())),
            state: "state".to_string(),
            error: Some("server_error".to_string()),
            error_description: Some("description".to_string()),
            error_uri: Some("uri".to_string()),
        };
        assert_eq!(
            handle_authorization_response(response, "state")
                .map(|c| c.secret().clone())
                .map_err(|e| e.kind()),
            Err(AuthErrorKind::OAuth2ProviderError)
        );
    }
}
