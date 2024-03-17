//! Common utilities for OAuth2 clients.

use std::{borrow::Cow, error::Error as StdError, fmt::Debug};

use actix_session::Session;
use actix_web::{
    error::{ErrorUnauthorized, Result as ActixResult},
    HttpResponse,
};
use oauth2::{
    basic::{BasicErrorResponse, BasicTokenResponse, BasicTokenType},
    AccessToken, AuthorizationCode, AuthorizationRequest, CodeTokenRequest, PkceCodeChallenge,
    RequestTokenError, TokenResponse,
};
use serde::{de::DeserializeOwned, Deserialize, Serialize};
use tracing::{error, info, warn};

use crate::error::JsonHttpError;

pub trait OAuth2Client {
    fn new_authorization_request(&self, pkce_challenge: PkceCodeChallenge) -> AuthorizationRequest;

    fn new_code_token_request(
        &self,
        code: AuthorizationCode,
    ) -> CodeTokenRequest<BasicErrorResponse, BasicTokenResponse, BasicTokenType>;

    fn new_user_info_request(&self) -> UserInfoRequest;
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
/// See [](https://www.oauth.com/oauth2-servers/authorization/the-authorization-response).
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
#[tracing::instrument(skip(response, session))]
pub async fn finish_authorization<C>(
    client: &C,
    response: OAuth2AuthorizationResponse,
    session: Session,
) -> ActixResult<HttpResponse>
where
    C: OAuth2Client + Debug + ?Sized,
{
    let saved_state: String = read_from_session(&session, STATE_TOKEN_SESSION_KEY)?;
    let pkce_secret: String = read_from_session(&session, PKCE_SECRET_SESSION_KEY)?;

    let code = handle_authorization_response(response, &saved_state)?;
    let token_result = fetch_tokens(client, pkce_secret, code).await?;
    let user_info = fetch_user_info(client, token_result.access_token()).await?;

    info!(?user_info, "user info fetched");

    // FIXME: return all the token as-is for now, figure out what to do with them later
    Ok(HttpResponse::Ok().json(CallbackResponse {
        access_token: token_result.access_token().secret().clone(),
        refresh_token: token_result.refresh_token().map(|t| t.secret().clone()),
        expires_in: token_result.expires_in().map(|d| d.as_millis() as u64),
    }))
}

/// Handle the response from an OAuth2 authorization request.
/// Returns the authorization code if the request was successful.
/// Otherwise, returns an error response.
#[tracing::instrument(skip_all)]
fn handle_authorization_response(
    response: OAuth2AuthorizationResponse,
    expected_state: &str,
) -> Result<AuthorizationCode, JsonHttpError> {
    match response {
        OAuth2AuthorizationResponse {
            error: Some(error), ..
        } if error == "access_denied" => Err(JsonHttpError::unauthorized(
            "OAUTH2_ACCESS_DENIED",
            "access denied by user",
        )),
        OAuth2AuthorizationResponse {
            error: Some(error),
            error_description,
            error_uri,
            ..
        } => {
            warn!(
                ?error,
                error_description, error_uri, "Authorization provider returned an error"
            );
            Err(JsonHttpError::internal_server_error(
                "OAUTH2_PROVIDER_ERROR",
                "an error occurred while processing the authorization request",
            ))
        }
        OAuth2AuthorizationResponse { code: None, .. } => {
            warn!("Missing code in authorization response");
            Err(JsonHttpError::internal_server_error(
                "OAUTH2_PROVIDER_ERROR",
                "an error occurred while processing the authorization request",
            ))
        }
        OAuth2AuthorizationResponse {
            code: Some(code),
            state,
            ..
        } => {
            if state != expected_state {
                Err(JsonHttpError::forbidden(
                    "OAUTH2_INVALID_STATE",
                    "invalid state token",
                ))
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
) -> Result<BasicTokenResponse, JsonHttpError>
where
    C: OAuth2Client + Debug + ?Sized,
{
    let pkce_verifier = oauth2::PkceCodeVerifier::new(pkce_secret.clone());

    client
        .new_code_token_request(code)
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
            JsonHttpError::internal_server_error(
                "OAUTH2_PROVIDER_ERROR",
                "an error occurred while processing the authorization request",
            )
        })
}

#[tracing::instrument(skip(token))]
async fn fetch_user_info<C>(client: &C, token: &AccessToken) -> Result<UserInfo, JsonHttpError>
where
    C: OAuth2Client + Debug + ?Sized,
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
            JsonHttpError::internal_server_error("INTERNAL_ERROR", "internal error")
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
            JsonHttpError::internal_server_error("INTERNAL_ERROR", "internal error")
        })?
        .error_for_status()
        .map_err(|error| {
            warn!(
                error = &error as &dyn StdError,
                "recieved error response from OAuth2 provider"
            );
            JsonHttpError::forbidden(
                "OAUTH2_FORBIDDEN",
                "unsufficient permissions from OAuth2 provider",
            )
        })?
        .json::<UserInfo>()
        .await
        .map_err(|error| {
            warn!(
                error = &error as &dyn StdError,
                "could not parse user info response"
            );
            JsonHttpError::internal_server_error(
                "OAUTH2_PROVIDER_ERROR",
                "an error occurred while processing the authorization request",
            )
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
struct UserInfo {
    sub: String,
    name: Option<String>,
    given_name: Option<String>,
    family_name: Option<String>,
    picture: Option<String>,
    email: Option<String>,
    email_verified: Option<bool>,
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
            handle_authorization_response(response, "state").map(|c| c.secret().clone()),
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
            handle_authorization_response(response, "invalid").map(|c| c.secret().clone()),
            Err(JsonHttpError::forbidden(
                "OAUTH2_INVALID_STATE",
                "invalid state token"
            ))
        );

        let response = OAuth2AuthorizationResponse {
            code: Some(AuthorizationCode::new("code".to_owned())),
            state: "state".to_string(),
            error: Some("access_denied".to_string()),
            error_description: None,
            error_uri: None,
        };
        assert_eq!(
            handle_authorization_response(response, "state").map(|c| c.secret().clone()),
            Err(JsonHttpError::unauthorized(
                "OAUTH2_ACCESS_DENIED",
                "access denied by user"
            ))
        );

        let response = OAuth2AuthorizationResponse {
            code: None,
            state: "state".to_string(),
            error: None,
            error_description: None,
            error_uri: None,
        };
        assert_eq!(
            handle_authorization_response(response, "state").map(|c| c.secret().clone()),
            Err(JsonHttpError::internal_server_error(
                "OAUTH2_PROVIDER_ERROR",
                "an error occurred while processing the authorization request"
            ))
        );

        let response = OAuth2AuthorizationResponse {
            code: Some(AuthorizationCode::new("code".to_owned())),
            state: "state".to_string(),
            error: Some("server_error".to_string()),
            error_description: Some("description".to_string()),
            error_uri: Some("uri".to_string()),
        };
        assert_eq!(
            handle_authorization_response(response, "state").map(|c| c.secret().clone()),
            Err(JsonHttpError::internal_server_error(
                "OAUTH2_PROVIDER_ERROR",
                "an error occurred while processing the authorization request"
            ))
        );
    }
}
