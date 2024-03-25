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
        created_at -> Timestamptz,
    }
}

diesel::table! {
    albums (id) {
        id -> Uuid,
        owner_id -> Uuid,
        #[max_length = 255]
        name -> Varchar,
        tags -> Array<Nullable<Text>>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
    }
}

diesel::table! {
    shared_albums (id) {
        id -> Uuid,
        album_id -> Uuid,
        user_id -> Uuid,
        created_at -> Timestamptz,
    }
}

diesel::table! {
    stored_images (hash) {
        hash -> Bytea,
        #[max_length = 255]
        compression_alg -> Varchar,
        size -> Int8,
        width -> Int8,
        height -> Int8,
        #[max_length = 255]
        orignal_mime_type -> Varchar,
        created_at -> Timestamptz,
    }
}

diesel::table! {
    user_images (id) {
        id -> Uuid,
        user_id -> Uuid,
        image_id -> Bytea,
        tags -> Array<Nullable<Text>>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use super::sql_types::AuthType;

    users (id) {
        id -> Uuid,
        #[max_length = 255]
        email -> Varchar,
        refresh_token -> Nullable<Text>,
        auth_type -> Nullable<AuthType>,
        refresh_token_exp -> Timestamptz,
        oauth_token -> Nullable<Text>,
        #[max_length = 255]
        name -> Nullable<Varchar>,
        #[max_length = 255]
        given_name -> Nullable<Varchar>,
        #[max_length = 255]
        family_name -> Nullable<Varchar>,
        created_at -> Timestamptz,
        updated_at -> Timestamptz,
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
