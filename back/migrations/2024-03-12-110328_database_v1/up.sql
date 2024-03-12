CREATE TYPE auth_type AS ENUM ('google', 'apple');

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) NOT NULL,
  refresh_token VARCHAR(255) NOT NULL,
  auth_type auth_type NOT NULL,
  token_exp TIMESTAMP NOT NULL,
  oauth_token VARCHAR(255) NULL
);

CREATE TABLE stored_images (
    hash BYTEA PRIMARY KEY,
    compression_alg VARCHAR(255) NOT NULL,
    size INT NOT NULL,
    width INT NOT NULL,
    height INT NOT NULL
);

CREATE TABLE user_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    image_id BYTEA NOT NULL,
    tags TEXT[] NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (image_id) REFERENCES stored_images(hash)
);

CREATE TABLE albums (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    tags TEXT[] NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

CREATE TABLE album_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    album_id UUID NOT NULL,
    image_id BYTEA NOT NULL,
    FOREIGN KEY (album_id) REFERENCES albums(id),
    FOREIGN KEY (image_id) REFERENCES stored_images(hash)
);

CREATE TABLE shared_albums (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    album_id UUID NOT NULL,
    user_id UUID NOT NULL,
    FOREIGN KEY (album_id) REFERENCES albums(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
