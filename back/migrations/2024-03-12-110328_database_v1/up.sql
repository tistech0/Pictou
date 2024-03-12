-- Your SQL goes here
CREATE TYPE auth_type AS ENUM ('google', 'apple');

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) NOT NULL,
  refresh_token VARCHAR(255) NOT NULL,
  auth_type auth_type NOT NULL,
  token_exp TIMESTAMP NOT NULL,
  oauth_token VARCHAR(255) NULL
);
