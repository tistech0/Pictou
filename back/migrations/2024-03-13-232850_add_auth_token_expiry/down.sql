comment on column public.users.refresh_token is null;

alter table public.users
    alter column refresh_token type varchar(255);

alter table public.users
    alter column refresh_token set not null;

update public.users
    set auth_type = 'google'::auth_type where auth_type is null;

alter table public.users
    alter column auth_type set not null;

alter table public.users
    rename column refresh_token_exp to token_exp;

alter table public.users
    alter column token_exp drop default;

alter table public.users
    alter column oauth_token type varchar(255);

alter table public.users
    drop constraint users_pk;

-- Intentionally not droping name, given_name, and family_name columns
