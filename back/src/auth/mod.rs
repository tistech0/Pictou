use std::{error::Error as StdError, sync::OnceLock};

use actix_web::{
    dev::Payload, error::ErrorInternalServerError, http::header, web, Error as ActixError,
    FromRequest, HttpRequest, Result as ActixResult,
};
use diesel::{Queryable, Selectable};
use futures_util::future::LocalBoxFuture;
use jsonwebtoken as jwt;
use oauth2::RefreshToken;
use serde::{Deserialize, Serialize};
use time::OffsetDateTime;
use tracing::{error, info, warn};
use utoipa::ToSchema;
use uuid::Uuid;

use crate::{
    auth::{error::AuthErrorKind, oauth2_client::DynOAuth2Client},
    config::AppConfiguration,
};

pub mod error;
pub mod google;
mod oauth2_client;
pub mod routes;

pub use oauth2_client::{ClientType, OAuth2Clients};
pub use routes::configure;

/// Sends a request to the OAuth2 provider to check if the user is still authorized.
#[tracing::instrument(skip(clients, oauth_token))]
async fn check_user_authorized_oauth2(
    clients: web::Data<OAuth2Clients>,
    client_type: Option<ClientType>,
    oauth_token: Option<String>,
    expected_email: &str,
) -> ActixResult<()> {
    let Some(client): Option<&DynOAuth2Client> =
        client_type.and_then(|t| clients.get(t).map(|c| c.as_ref()))
    else {
        return Ok(());
    };

    info!("checking user authorization with OAuth2 provider");

    let access_token =
        oauth2_client::refresh_token(client, &RefreshToken::new(oauth_token.unwrap_or_default()))
            .await?;
    let user_info = oauth2_client::fetch_user_info(client, &access_token).await?;

    if user_info.email.as_deref() != Some(expected_email) {
        warn!(
            email = user_info.email,
            "user email does not match the one in the database"
        );
        Err(AuthErrorKind::InvalidCredentials.to_error().into())
    } else {
        Ok(())
    }
}

#[derive(Debug, Deserialize, ToSchema)]
pub struct RefreshTokenParams {
    user_id: Uuid,
    /// Base64-encoded opaque binary token, preferably very long
    refresh_token: String,
}

#[derive(Debug, Serialize, Deserialize, ToSchema)]
pub struct AuthenticationResponse {
    #[serde(flatten)]
    pub user: PersistedUserInfo,
    pub access_token: String,
    #[schema(value_type = String, format = "date-time")]
    pub access_token_exp: OffsetDateTime,
}

#[derive(Debug, Serialize, Deserialize, Selectable, Queryable, ToSchema)]
#[diesel(table_name = crate::schema::users)]
pub struct PersistedUserInfo {
    #[diesel(column_name = "id")]
    pub user_id: Uuid,
    pub email: String,
    pub refresh_token: Option<String>,
    #[schema(value_type = String, format = "date-time")]
    pub refresh_token_exp: OffsetDateTime,
    pub name: Option<String>,
    pub given_name: Option<String>,
    pub family_name: Option<String>,
}

/// When present, this extractor ensures that the annotated route will require authentication.
/// Also provides the authenticated user's ID.
#[derive(Debug)]
#[non_exhaustive]
pub struct AuthContext {
    pub user_id: Uuid,
}

/// Allows [`AuthContext`] to be used as an Actix extractor.
impl FromRequest for AuthContext {
    type Error = ActixError;
    type Future = LocalBoxFuture<'static, ActixResult<Self>>;

    fn from_request(req: &HttpRequest, _payload: &mut Payload) -> Self::Future {
        Box::pin(Self::authenticate_request(req.clone()))
    }
}

impl AuthContext {
    #[tracing::instrument]
    async fn authenticate_request(req: HttpRequest) -> ActixResult<Self> {
        let app_cfg = req
            .app_data::<web::Data<AppConfiguration>>()
            .ok_or_else(|| {
                error!("AppConfiguration not found in app data");
                ErrorInternalServerError("")
            })?;

        let token = Self::parse_bearer_token(&req)?;
        let auth_token = Self::decode_jwt(token, &app_cfg.app_name, &app_cfg.jwt_secret)?;

        Ok(AuthContext {
            user_id: auth_token.claims.sub,
        })
    }

    /// Extracts the authorization header from the HTTP request and returns the bearer token if possible.
    fn parse_bearer_token(req: &HttpRequest) -> ActixResult<&str> {
        req.headers()
            .get(header::AUTHORIZATION)
            .and_then(|auth| auth.to_str().ok())
            .and_then(|auth| auth.strip_prefix("Bearer "))
            .ok_or_else(|| AuthErrorKind::InvalidAuthorizationHeader.to_error())
            .map_err(ActixError::from)
    }

    /// Attempts to decode a JWT token using the provided secret.
    fn decode_jwt(
        token: &str,
        app_name: &str,
        secret: &[u8],
    ) -> ActixResult<jwt::TokenData<AuthenticationToken>> {
        let key = jwt::DecodingKey::from_secret(secret);

        static CACHED_JWT_VALIDATION: OnceLock<jwt::Validation> = OnceLock::new();

        let jwt_validation: &'static jwt::Validation = CACHED_JWT_VALIDATION.get_or_init(|| {
            let mut validation = jwt::Validation::new(jwt::Algorithm::HS256);

            validation.validate_exp = true;
            validation.validate_aud = true;

            validation.set_audience(&[app_name]);
            validation.set_issuer(&[app_name]);

            validation
        });

        jwt::decode::<AuthenticationToken>(token, &key, jwt_validation)
            .map_err(|error| AuthErrorKind::InvalidToken.with_cause(error))
            .map_err(ActixError::from)
    }

    #[tracing::instrument(skip(secret))]
    fn encode_jwt(
        subject: Uuid,
        expires_at: OffsetDateTime,
        app_name: &str,
        secret: &[u8],
    ) -> ActixResult<String> {
        let header = jwt::Header::new(jwt::Algorithm::HS256);
        let key = jwt::EncodingKey::from_secret(secret);

        let claims = AuthenticationToken {
            aud: app_name.to_owned(),
            iss: app_name.to_owned(),
            exp: expires_at.unix_timestamp(),
            sub: subject,
        };

        jwt::encode(&header, &claims, &key).map_err(|error| {
            error!(error = &error as &dyn StdError, "failed to encode JWT");
            ErrorInternalServerError("")
        })
    }

    /// Generates a new random refresh token.
    fn generate_refresh_token() -> String {
        use base64::prelude::*;
        use rand::prelude::*;

        let mut rng = rand::thread_rng();
        let mut buf = [0u8; 128];
        rng.fill_bytes(&mut buf);

        BASE64_STANDARD.encode(buf)
    }
}

/// JWT claims
#[derive(Debug, Serialize, Deserialize)]
struct AuthenticationToken {
    aud: String,
    iss: String,
    exp: i64,
    sub: Uuid,
}

#[cfg(test)]
mod tests {
    use super::*;
    use actix_web::{http::StatusCode, test::TestRequest, App, HttpResponse, Responder};
    use time::Duration;
    use tracing_test::traced_test;

    // {
    //   "sub": "f09d493d-a117-465d-84de-96fb4469dd40",
    //   "exp": 1916239022,
    //   "iss": "pictou",
    //   "aud": "pictou"
    // }
    const VALID_JWT: &str = "\
        eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJz\
        dWIiOiJmMDlkNDkzZC1hMTE3LTQ2NWQtODRkZS05N\
        mZiNDQ2OWRkNDAiLCJleHAiOjE5MTYyMzkwMjIsIm\
        lzcyI6InBpY3RvdSIsImF1ZCI6InBpY3RvdSJ9.7s\
        9spRPknrCpPLxLloVpUkPrmFxEyFklY7Bq-aF3d6I";

    // {
    //   "sub": "f09d493d-a117-465d-84de-96fb4469dd40",
    //   "exp": 1516239022,
    //   "iss": "pictou",
    //   "aud": "pictou"
    // }
    const EXPIRED_JWT: &str = "\
        eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJz\
        dWIiOiJmMDlkNDkzZC1hMTE3LTQ2NWQtODRkZS05N\
        mZiNDQ2OWRkNDAiLCJleHAiOjE1MTYyMzkwMjIsIm\
        lzcyI6InBpY3RvdSIsImF1ZCI6InBpY3RvdSJ9.zI\
        UtLivXOklBsSNbFcGgMS1uE9FSdd9E_qYm41c3gwQ";

    // {
    //   "sub": "f09d493d-a117-465d-84de-96fb4469dd40",
    //   "exp": 1916239022,
    //   "iss": "pictou",
    //   "aud": "picsou"
    // }
    const WRONG_AUD_JWT: &str = "\
        eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJz\
        dWIiOiJmMDlkNDkzZC1hMTE3LTQ2NWQtODRkZS05N\
        mZiNDQ2OWRkNDAiLCJleHAiOjE5MTYyMzkwMjIsIm\
        lzcyI6InBpY3RvdSIsImF1ZCI6InBpY3NvdSJ9.VX\
        PbzH1-JVM_-anGEMx7WK_u9_7GfGRTYwlnzARbAR8";

    #[test]
    fn test_parse_bearer_token() {
        assert!(AuthContext::parse_bearer_token(&TestRequest::get().to_http_request()).is_err());
        assert!(AuthContext::parse_bearer_token(
            &TestRequest::get()
                .insert_header(("Authorization", ""))
                .to_http_request()
        )
        .is_err());
        assert!(AuthContext::parse_bearer_token(
            &TestRequest::get()
                .insert_header(("Authorization", "Basic dGVzdA=="))
                .to_http_request()
        )
        .is_err());
        assert!(AuthContext::parse_bearer_token(
            &TestRequest::get()
                .insert_header(("Authorization", "Bearer"))
                .to_http_request()
        )
        .is_err());
        assert!(matches!(
            AuthContext::parse_bearer_token(
                &TestRequest::get()
                    .insert_header(("Authorization", "Bearer token"))
                    .to_http_request()
            ),
            Ok("token")
        ));
    }

    #[test]
    fn test_decode_jwt() {
        assert!(AuthContext::decode_jwt("invalid token", "pictou", &[]).is_err());
        assert!(
            AuthContext::decode_jwt(EXPIRED_JWT, "pictou", b"secret").is_err(),
            "expired token should fail"
        );
        assert!(
            AuthContext::decode_jwt(WRONG_AUD_JWT, "pictou", b"secret").is_err(),
            "token with wrong audience should fail"
        );
        assert!(
            AuthContext::decode_jwt(VALID_JWT, "pictou", b"wrong secret").is_err(),
            "invalid secret should fail"
        );

        let Ok(valid_token) = AuthContext::decode_jwt(VALID_JWT, "pictou", b"secret") else {
            panic!("valid token failed to decode")
        };
        assert_eq!(
            valid_token.claims.sub,
            Uuid::parse_str("f09d493d-a117-465d-84de-96fb4469dd40").unwrap()
        );
    }

    #[test]
    fn test_encode_decode_jwt() {
        let secret = b"secret";

        let expires_at = OffsetDateTime::now_utc() + Duration::seconds(60);
        let encodded = AuthContext::encode_jwt(
            Uuid::parse_str("f09d493d-a117-465d-84de-96fb4469dd40").unwrap(),
            expires_at,
            "pictou",
            secret,
        )
        .expect("failed to encode token");

        let decoded =
            AuthContext::decode_jwt(&encodded, "pictou", secret).expect("failed to decode token");

        assert_eq!(decoded.header.alg, jwt::Algorithm::HS256);
        assert_eq!(
            decoded.claims.sub,
            Uuid::parse_str("f09d493d-a117-465d-84de-96fb4469dd40").unwrap()
        );
        assert_eq!(decoded.claims.aud, "pictou");
        assert_eq!(decoded.claims.iss, "pictou");
        assert_eq!(decoded.claims.exp, expires_at.unix_timestamp());
    }

    #[test]
    fn test_generate_refresh_token() {
        let token_a = AuthContext::generate_refresh_token();
        let token_b = AuthContext::generate_refresh_token();

        assert!(token_a.len() >= 128);
        assert!(token_b.len() >= 128);
        assert_ne!(token_a, token_b);
    }

    #[traced_test]
    #[actix_rt::test]
    async fn test_authenticate() {
        async fn authenticated_route(AuthContext { user_id }: AuthContext) -> impl Responder {
            HttpResponse::Ok().json(user_id)
        }

        let config = web::Data::new(AppConfiguration {
            jwt_secret: b"secret".as_ref().into(),
            ..Default::default()
        });

        let app = actix_web::test::init_service(
            App::new()
                .app_data(config.clone())
                .route("/authenticated", web::get().to(authenticated_route)),
        )
        .await;

        let no_auth_req = TestRequest::get().uri("/authenticated").to_request();
        let expired_token_req = TestRequest::get()
            .uri("/authenticated")
            .insert_header(("Authorization", format!("Bearer {EXPIRED_JWT}")))
            .to_request();
        let valid_token_req = TestRequest::get()
            .uri("/authenticated")
            .insert_header(("Authorization", format!("Bearer {VALID_JWT}")))
            .to_request();

        let no_auth_resp = actix_web::test::call_service(&app, no_auth_req).await;
        let expired_token_resp = actix_web::test::call_service(&app, expired_token_req).await;
        let valid_token_resp = actix_web::test::call_service(&app, valid_token_req).await;

        assert_eq!(no_auth_resp.status(), StatusCode::UNAUTHORIZED);
        assert_eq!(expired_token_resp.status(), StatusCode::UNAUTHORIZED);
        assert_eq!(valid_token_resp.status(), StatusCode::OK);
    }
}
