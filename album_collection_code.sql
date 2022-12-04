-- Question 1
CREATE OR REPLACE VIEW Exceptions AS
    SELECT artist_name,
           album_name
    FROM artists
        NATURAL JOIN
        song_album
        NATURAL JOIN 
        song_artist
        NATURAL JOIN 
        albums
    WHERE (artist_id, album_id) NOT IN (
        SELECT album_artist.artist_id, album_artist.album_id
        FROM artists
            NATURAL JOIN
            albums
            NATURAL JOIN
            album_artist
            NATURAL JOIN
            song_album
        )
group by artist_name, album_name;

-- Question 2
create or replace View detail_of_album as
    select album_name, date_of_release, album_id, GROUP_CONCAT(DISTINCT artist_name ORDER BY artist_name DESC SEPARATOR ', ') as list_of_artists
    from albums natural Join album_artist natural join artists
    group by album_id ;

create or replace View sum_of_songs_per_album as
    (Select Cast(Round(SUM(song_length),2) as DECIMAL(12,2) ) as total_length_in_minutes, album_id
    from songs natural join song_album
    group by album_id);

create or replace view AlbumInfo as
Select album_name, list_of_artists, date_of_release, total_length_in_minutes
    from
detail_of_album natural join sum_of_songs_per_album
group by album_name;

-- Question 3

DELIMITER //
CREATE or replace TRIGGER CheckReleaseDate
AFTER INSERT
ON song_album
FOR EACH ROW
    BEGIN
        DECLARE album_released VARCHAR(32);
        DECLARE song_released VARCHAR(32);

        SET album_released = (SELECT date_of_release
                              FROM albums
                              WHERE albums.album_id = NEW.album_id);

        SET song_released = (SELECT date_of_release
                             FROM songs
                             WHERE songs.song_id = NEW.song_id);

        IF (album_released = '0000-00-00') THEN
            SET album_released = NULL;
        END IF;

        IF (album_released <> song_released) THEN
            UPDATE songs
            SET songs.date_of_release = album_released
            WHERE song_id = NEW.song_id;
        END IF;
    END;
//

-- Question 4
DELIMITER //
   CREATE OR REPLACE PROCEDURE AddTrack(A INT, S INT)
      BEGIN
         DECLARE TN INT;
         DECLARE track_in_album BOOL;
         DECLARE track_in_songs BOOL;
         
         SET TN = (SELECT MAX(track_no) FROM song_album WHERE album_id = A);
         SET track_in_album = (S IN (SELECT song_id FROM song_album WHERE album_id = A));
         SET track_in_songs = (S IN (SELECT song_id FROM songs));

          IF (track_in_album IS FALSE AND track_in_songs IS TRUE) THEN
             SET TN = TN + 1;
             
            INSERT INTO 
                    song_album (song_id, album_id, track_no)
            VALUES 
                    (S, A, TN);
         END IF;
      END; //

-- Question 5

DELIMITER //

CREATE or replace FUNCTION GetTrackList(A INT)
RETURNS TEXT
    BEGIN
        DECLARE result TEXT;

        SELECT GROUP_CONCAT(DISTINCT song_name SEPARATOR ',')
        FROM song_album
             NATURAL JOIN
             songs
        WHERE album_id = A
        INTO result;

        RETURN result;
    END;
//