truncate table public.album_images;
alter table public.album_images
    drop column image_id;
alter table public.album_images
    add column image_id bytea not null;
