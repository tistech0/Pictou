alter table public.user_images
    drop constraint user_images_user_id_fkey;
alter table public.user_images
    add foreign key (user_id) references public.users
        on update cascade on delete cascade;

alter table public.user_images
    drop constraint user_images_image_id_fkey;
alter table public.user_images
    add foreign key (image_id) references public.stored_images
        on update cascade on delete cascade;

alter table public.shared_albums
    drop constraint shared_albums_album_id_fkey;
alter table public.shared_albums
    add foreign key (album_id) references public.albums
        on update cascade on delete cascade;

alter table public.shared_albums
    drop constraint shared_albums_user_id_fkey;
alter table public.shared_albums
    add foreign key (user_id) references public.users
        on update cascade on delete cascade;

alter table public.albums
    drop constraint albums_owner_id_fkey;
alter table public.albums
    add foreign key (owner_id) references public.users
        on update cascade on delete cascade;
