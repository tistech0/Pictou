//! Common utilities for OAuth2 clients.

use serde::Deserialize;
use tracing::warn;

use crate::error::JsonHttpError;

/// Represent the response sent by OAuth2 servers as query parameters.
///
/// See [](https://www.oauth.com/oauth2-servers/authorization/the-authorization-response).
#[derive(Debug, Deserialize)]
pub struct OAuth2AuthorizationResponse {
    code: Option<String>,
    #[serde(default)]
    state: String,
    error: Option<String>,
    error_description: Option<String>,
    error_uri: Option<String>,
}

/// Handle the response from an OAuth2 authorization request.
/// Returns the authorization code if the request was successful.
/// Otherwise, returns an error response.
#[tracing::instrument(skip_all)]
pub fn handle_authorization_response(
    response: OAuth2AuthorizationResponse,
    expected_state: &str,
) -> Result<String, JsonHttpError> {
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_handle_authorization_response() {
        let response = OAuth2AuthorizationResponse {
            code: Some("code".to_string()),
            state: "state".to_string(),
            error: None,
            error_description: None,
            error_uri: None,
        };
        assert_eq!(
            handle_authorization_response(response, "state"),
            Ok("code".to_owned())
        );

        let response = OAuth2AuthorizationResponse {
            code: Some("code".to_string()),
            state: "state".to_string(),
            error: None,
            error_description: None,
            error_uri: None,
        };
        assert_eq!(
            handle_authorization_response(response, "invalid"),
            Err(JsonHttpError::forbidden(
                "OAUTH2_INVALID_STATE",
                "invalid state token"
            ))
        );

        let response = OAuth2AuthorizationResponse {
            code: Some("code".to_string()),
            state: "state".to_string(),
            error: Some("access_denied".to_string()),
            error_description: None,
            error_uri: None,
        };
        assert_eq!(
            handle_authorization_response(response, "state"),
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
            handle_authorization_response(response, "state"),
            Err(JsonHttpError::internal_server_error(
                "OAUTH2_PROVIDER_ERROR",
                "an error occurred while processing the authorization request"
            ))
        );

        let response = OAuth2AuthorizationResponse {
            code: Some("code".to_string()),
            state: "state".to_string(),
            error: Some("server_error".to_string()),
            error_description: Some("description".to_string()),
            error_uri: Some("uri".to_string()),
        };
        assert_eq!(
            handle_authorization_response(response, "state"),
            Err(JsonHttpError::internal_server_error(
                "OAUTH2_PROVIDER_ERROR",
                "an error occurred while processing the authorization request"
            ))
        );
    }
}
