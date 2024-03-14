comment on column public.users.refresh_token is null;

alter table public.users
    alter column refresh_token type varchar(255) using refresh_token::varchar(255);

alter table public.users
    alter column refresh_token set not null;

alter table public.users
    add auth_type auth_type not null;

alter table public.users
    drop column refresh_token_exp;

alter table public.users
    add token_exp timestamp not null;

alter table public.users
    drop column google_refresh_token;

alter table public.users
    add oauth_token varchar(255);

alter table public.users
    drop column google_refresh_token_exp;

alter table public.users
    drop constraint users_pk;
