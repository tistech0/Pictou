alter table public.album_images
drop constraint if exists album_images_album_id_fkey;
alter table public.album_images
    add foreign key (album_id) references public.albums
        on update cascade on delete cascade;

truncate public.album_images;
alter table public.album_images
drop column if exists image_id;
alter table public.album_images
    add column if not exists image_id uuid not null;

alter table public.album_images
drop constraint if exists album_images_user_images_id_fkey;
alter table public.album_images
    add constraint album_images_user_images_id_fkey
        foreign key (image_id) references public.user_images
            on update cascade on delete cascade;
