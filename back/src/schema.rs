// @generated automatically by Diesel CLI.

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
    new_users (id) {
        id -> Uuid,
        #[max_length = 255]
        email -> Varchar,
        refresh_token -> Nullable<Text>,
        refresh_token_exp -> Timestamptz,
        google_refresh_token -> Nullable<Text>,
        google_refresh_token_exp -> Nullable<Timestamptz>,
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
    users (id) {
        id -> Uuid,
        #[max_length = 255]
        email -> Varchar,
        refresh_token -> Nullable<Text>,
        refresh_token_exp -> Timestamptz,
        google_refresh_token -> Nullable<Text>,
        google_refresh_token_exp -> Nullable<Timestamptz>,
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
    new_users,
    shared_albums,
    stored_images,
    user_images,
    users,
);
