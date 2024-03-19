//! This module was split off `mod.rs` because `utoipa_auto_discovery` crashes when you have a `mod.rs` file.

use actix_session::Session;
use actix_web::{
    get, post,
    web::{self, ServiceConfig},
    HttpResponse, Result as ActixResult,
};
use serde::Deserialize;
use time::OffsetDateTime;
use tracing::{info, warn};
use utoipa::IntoParams;

use crate::{
    api::{json_payload_error_example, path_error_example},
    auth::{
        check_user_authorized_oauth2,
        error::AuthErrorKind,
        oauth2_client::{self, ClientType, OAuth2AuthorizationResponse},
        AuthContext, AuthenticationResponse, PersistedUserInfo, RefreshTokenParams,
    },
    config::AppConfiguration,
    database::{self, Database, DatabaseError},
    error_handler::ApiError,
};

use super::OAuth2Clients;

/// Exposes all HTTP routes of this module.
pub fn configure(clients: web::Data<OAuth2Clients>, service_cfg: &mut ServiceConfig) {
    service_cfg
        .app_data(clients)
        .service(login)
        .service(callback)
        .service(refresh_token)
        .service(logout);
}

#[derive(Debug, Deserialize, IntoParams)]
#[into_params(style = Form, parameter_in = Path)]
struct AuthPathParameters {
    #[param(inline)]
    provider: ClientType,
}

/// *The* Authorization/Authentication endpoint.
///
/// User information is sent to /auth/callback/{provider} when the user is authenticated.
#[utoipa::path(
    responses(
        (status = StatusCode::FOUND, description = "Redirected to google authentication or to /auth/callback/<provider>"),
    ),
    params(AuthPathParameters),
    tag="auth"
)]
#[get("/auth/login/{provider}")]
#[tracing::instrument(skip_all)]
pub async fn login(
    clients: web::Data<OAuth2Clients>,
    session: Session,
    path_params: web::Path<AuthPathParameters>,
) -> ActixResult<HttpResponse> {
    let client_type = path_params.into_inner().provider;
    info!(?client_type, "Received login request");
    let client = clients.get(client_type).ok_or_else(|| {
        warn!(
            ?client_type,
            "tried to authenticate with an disabled provider"
        );
        AuthErrorKind::UnknownProvider.to_error()
    })?;
    oauth2_client::begin_authorization(client.as_ref(), session)
}

/// OAuth2 callback endpoint. Must not be called directly.
///
/// This endpoint is called by the OAuth provider after the user has authenticated.
/// This documentation is here to show the structure of the body received by this endpoint, not to call this endpoint.
#[utoipa::path(
    responses(
        (
            status = StatusCode::OK,
            body = AuthenticationResponse,
            description = "Google authentication succeeded and user can use the access token as a bearer."
        ),
    ),
    params(AuthPathParameters),
    tag="auth"
)]
#[get("/auth/callback/{provider}")]
#[tracing::instrument(skip_all)]
pub async fn callback(
    clients: web::Data<OAuth2Clients>,
    session: Session,
    query: web::Query<OAuth2AuthorizationResponse>,
    db: web::Data<Database>,
    app_cfg: web::Data<AppConfiguration>,
    path_params: web::Path<AuthPathParameters>,
) -> ActixResult<HttpResponse> {
    let client_type = path_params.into_inner().provider;
    info!(?client_type, "Received authorization callback request");
    let client = clients.get(client_type).ok_or_else(|| {
        warn!(
            ?client_type,
            "tried to authenticate with an disabled provider"
        );
        AuthErrorKind::UnknownProvider.to_error()
    })?;
    oauth2_client::finish_authorization(
        client.as_ref(),
        query.into_inner(),
        session,
        db.into_inner(),
        app_cfg.as_ref(),
    )
    .await
}

/// Allows the user to request another access token after it expired.
/// This route checks the opaque refresh token against the database before granting (or not) the new access token.
#[utoipa::path(
    responses(
        (status = StatusCode::OK, description = "Successfully refreshed", body = AuthenticationResponse),
        (status = StatusCode::BAD_REQUEST, body = ApiError, examples(
            ("Invalid path parameters" = (value = json!(path_error_example()))),
            ("Invalid payload" = (value = json!(json_payload_error_example())))),
            content_type = "application/json"
        ),
        (
            status = StatusCode::UNAUTHORIZED,
            description = "Credentials are invalid",
            body = AuthError,
            content_type = "application/json"
        ),
        (
            status = StatusCode::FORBIDDEN,
            description = "OAuth provider rejected the request",
            body = AuthError,
            content_type = "application/json"
        ),
    ),
    tag="auth",
    request_body(
        description = "User id and refresh token",
        content_type = "application/json",
        content = RefreshTokenParams
    )
)]
#[post("/auth/refresh")]
#[tracing::instrument(skip_all)]
pub async fn refresh_token(
    db: web::Data<Database>,
    json: web::Json<RefreshTokenParams>,
    app_cfg: web::Data<AppConfiguration>,
    clients: web::Data<OAuth2Clients>,
) -> ActixResult<HttpResponse> {
    let RefreshTokenParams {
        user_id,
        refresh_token,
    } = json.into_inner();

    // check in DB that there is a user that satisfies the following conditions:
    // - user_id matches the one in the request
    // - refresh_token matches the one in the request
    // - refresh_token_exp is not expired
    let result: Option<(String, Option<ClientType>, Option<String>)> =
        database::open(db.clone(), move |conn| {
            use crate::schema::users;
            use diesel::dsl::now;
            use diesel::prelude::*;

            users::table
                .filter(
                    users::id.eq(user_id).and(
                        users::refresh_token
                            .eq(&refresh_token)
                            .and(users::refresh_token_exp.ge(now)),
                    ),
                )
                .select((users::email, users::auth_type, users::oauth_token))
                .get_result(conn)
                .optional()
                .map_err(DatabaseError::from)
        })
        .await?;

    let (email, client_type, oauth_token) =
        result.ok_or_else(|| AuthErrorKind::InvalidCredentials.to_error())?;

    check_user_authorized_oauth2(clients, client_type, oauth_token, &email).await?;

    info!(%email, %user_id, lifetime_secs = app_cfg.access_token_lifetime.whole_seconds(), "refreshing access token of user");
    let access_token_exp = OffsetDateTime::now_utc() + app_cfg.access_token_lifetime;
    let access_token = AuthContext::encode_jwt(
        user_id,
        access_token_exp,
        &app_cfg.app_name,
        &app_cfg.jwt_secret,
    )?;

    // Regenerate a new refresh token and update the database
    let user_info = database::open(db, move |conn| {
        use crate::schema::users;
        use diesel::prelude::*;

        diesel::update(users::table.filter(users::id.eq(user_id)))
            .set((
                users::refresh_token.eq(&AuthContext::generate_refresh_token()),
                users::refresh_token_exp
                    .eq(OffsetDateTime::now_utc() + app_cfg.refresh_token_lifetime),
            ))
            .returning(PersistedUserInfo::as_returning())
            .get_result(conn)
            .map_err(DatabaseError::from)
    })
    .await?;

    Ok(HttpResponse::Ok().json(AuthenticationResponse {
        user: user_info,
        access_token,
        access_token_exp,
    }))
}

/// Revoke the refresh token of the user.
/// The user may still be authenticated with the access token (for up to 3 minutes, by default),
/// but the refresh token is invalidated.
#[utoipa::path(
    responses(
        (status = StatusCode::OK, description = "Successfully logged out"),
        (
            status = StatusCode::UNAUTHORIZED,
            description = "User not authenticated",
            body = ApiError,
            example = json!(ApiError::unauthorized_error()), content_type = "application/json"
        ),
    ),
    params(AuthPathParameters),
    tag="auth"
)]
#[get("/auth/logout")]
#[tracing::instrument(skip_all)]
pub async fn logout(db: web::Data<Database>, auth: AuthContext) -> ActixResult<HttpResponse> {
    database::open(db, move |conn| {
        use crate::schema::users;
        use diesel::prelude::*;

        diesel::update(users::table.filter(users::id.eq(auth.user_id)))
            .set((
                users::refresh_token.eq(""),
                users::refresh_token_exp.eq(OffsetDateTime::now_utc()),
            ))
            .execute(conn)
            .map_err(DatabaseError::from)
    })
    .await?;

    Ok(HttpResponse::Ok().finish())
}
