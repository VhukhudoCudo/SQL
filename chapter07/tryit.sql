CREATE TABLE albums (
    album_id bigserial,
    album_catalog_code varchar(100),
    album_title text,
    album_artist text,
    album_release_date date,
    album_genre varchar(40),
    album_description text
 );
 CREATE TABLE songs (
    song_id bigserial,
    song_title text,
    song_artist text,
    album_id bigint    
);