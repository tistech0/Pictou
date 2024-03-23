alter table public.stored_images
    alter column orignal_mime_type drop not null;

alter table public.stored_images
    alter column orignal_mime_type set default null;

-- Not downgrading image sizes back to 32-bit

-- Not dropping the unique constraint on user_images
