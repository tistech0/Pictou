alter table public.stored_images
    alter column orignal_mime_type drop not null;

alter table public.stored_images
    alter column orignal_mime_type set default null;
