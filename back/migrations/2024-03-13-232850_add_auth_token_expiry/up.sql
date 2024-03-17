comment on column public.users.refresh_token is 'the refresh token delivered to the app, NULL when the user is fully logged out';

alter table public.users
    alter column refresh_token type text;

alter table public.users
    alter column refresh_token drop not null;

alter table public.users
    rename column token_exp to refresh_token_exp;

alter table public.users
    alter column refresh_token_exp type timestamp with time zone;

alter table public.users
    alter column refresh_token_exp set default '1970-01-01 00:00:00+00'::timestamp with time zone;

comment on column public.users.refresh_token_exp is 'expiry timestamp of the refresh token';

alter table public.users
    alter column oauth_token type text;

alter table public.users
    alter column oauth_token set default '';

alter table public.users
    add constraint users_pk
        unique (email);

alter table public.users
    alter column auth_type drop not null;

alter table public.users
    alter column auth_type set default null;

alter table public.users
    add column if not exists name varchar(255) default null,
    add column if not exists given_name varchar(255) default null,
    add column if not exists family_name varchar(255) default null;

comment on column public.users.name is 'Full user name, optional';
comment on column public.users.given_name is 'First name, optional';
comment on column public.users.family_name is 'Last name, optional';
