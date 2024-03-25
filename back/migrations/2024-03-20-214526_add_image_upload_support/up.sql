-- Add `original_mime_type` column,
-- the other queries are for reverting and appling the migration with no errors
alter table public.stored_images
    add column if not exists orignal_mime_type varchar(255) not null;
comment on column public.stored_images.orignal_mime_type is 'The original MIME type of the image';
update public.stored_images
    set orignal_mime_type = 'image/jpeg'
    where orignal_mime_type is null;
alter table public.stored_images
    alter column orignal_mime_type set not null;
alter table public.stored_images
    alter column orignal_mime_type drop default;

-- Upgrade sizes to 64 ints
alter table public.stored_images
    alter column size type bigint;
alter table public.stored_images
    alter column width type bigint;
alter table public.stored_images
    alter column height type bigint;

-- New user images have no tags by default
alter table public.user_images
    alter column tags set default '{}';

-- No two user_images should share the same user_id image_id pair
alter table public.user_images
    drop constraint if exists user_image_user_id_image_id_unique;
alter table public.user_images
    add constraint user_image_user_id_image_id_unique unique (user_id, image_id);
