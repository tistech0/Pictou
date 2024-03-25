alter table public.users
    add column if not exists created_at timestamp with time zone default NOW() not null;
alter table public.users
    add column if not exists updated_at timestamp with time zone default NOW() not null;

alter table public.user_images
    add column if not exists created_at timestamp with time zone default NOW() not null;
alter table public.user_images
    add column if not exists updated_at timestamp with time zone default NOW() not null;

alter table public.stored_images
    add column if not exists created_at timestamp with time zone default NOW() not null;

alter table public.albums
    add column if not exists created_at timestamp with time zone default NOW() not null;
alter table public.albums
    add column if not exists updated_at timestamp with time zone default NOW() not null;

alter table public.shared_albums
    add column if not exists created_at timestamp with time zone default NOW() not null;

alter table public.album_images
    add column if not exists created_at timestamp with time zone default NOW() not null;
