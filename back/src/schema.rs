// @generated automatically by Diesel CLI.

pub mod sql_types {
    #[derive(diesel::query_builder::QueryId, diesel::sql_types::SqlType)]
    #[diesel(postgres_type(name = "auth_type"))]
    pub struct AuthType;
}

diesel::table! {
    album_images (id) {
        id -> Uuid,
        album_id -> Uuid,
        image_id -> Bytea,
    }
}

diesel::table! {
    albums (id) {
        id -> Uuid,
        owner_id -> Uuid,
        #[max_length = 255]
        name -> Varchar,
        tags -> Array<Nullable<Text>>,
    }
}

diesel::table! {
    shared_albums (id) {
        id -> Uuid,
        album_id -> Uuid,
        user_id -> Uuid,
    }
}

diesel::table! {
    stored_images (hash) {
        hash -> Bytea,
        #[max_length = 255]
        compression_alg -> Varchar,
        size -> Int4,
        width -> Int4,
        height -> Int4,
    }
}

diesel::table! {
    user_images (id) {
        id -> Uuid,
        user_id -> Uuid,
        image_id -> Bytea,
        tags -> Array<Nullable<Text>>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use super::sql_types::AuthType;

    users (id) {
        id -> Uuid,
        #[max_length = 255]
        email -> Varchar,
        #[max_length = 255]
        refresh_token -> Varchar,
        auth_type -> AuthType,
        token_exp -> Timestamp,
        #[max_length = 255]
        oauth_token -> Nullable<Varchar>,
    }
}

diesel::joinable!(album_images -> albums (album_id));
diesel::joinable!(album_images -> stored_images (image_id));
diesel::joinable!(albums -> users (owner_id));
diesel::joinable!(shared_albums -> albums (album_id));
diesel::joinable!(shared_albums -> users (user_id));
diesel::joinable!(user_images -> stored_images (image_id));
diesel::joinable!(user_images -> users (user_id));

diesel::allow_tables_to_appear_in_same_query!(
    album_images,
    albums,
    shared_albums,
    stored_images,
    user_images,
    users,
);
