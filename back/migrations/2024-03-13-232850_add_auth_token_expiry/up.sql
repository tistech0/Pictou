comment on column public.users.refresh_token is 'the refresh token delivered to the app, NULL when the user is fully logged out';

alter table public.users
    alter column refresh_token type text using refresh_token::text;

alter table public.users
    alter column refresh_token drop not null;

alter table public.users
    drop column auth_type;

alter table public.users
    add refresh_token_exp timestamp with time zone default '1970-01-01 00:00:00+00'::timestamp with time zone not null;

comment on column public.users.refresh_token_exp is 'expiry timestamp of the refresh token';

alter table public.users
    drop column token_exp;

alter table public.users
    add google_refresh_token text;

comment on column public.users.google_refresh_token is 'refresh token delivered by the Google OAuth2 API, NULL when the user hasn''t linked their google account';

alter table public.users
    drop column oauth_token;

alter table public.users
    add google_refresh_token_exp timestamp with time zone default '1970-01-01 00:00:00+00'::timestamp with time zone;

comment on column public.users.google_refresh_token_exp is 'expiry timestamp of the Google OAuth2 refresh token (if present)';

alter table public.users
    add constraint users_pk
        unique (email);
