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
