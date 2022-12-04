# CS4416 Project Specs:

## Task 1. SQL

For the schema in album_collection_schema.sql:

- Create view **Exceptions(artist_name, album_name)**. *(A, B)* is a data row in this view if and only if artist A contributes to at least one song on album B (according to table song_artist) but artist A is not listed as one of the artists on album B in table album_artist. There should be no duplicate data rows in the view.

- Create view **AlbumInfo(album_name, list_of_artist, date_of_release, total_length)**. Each album should be listed exactly once. For each album, the value in column list_of_artists is a comma-separated list of all artists on the album according to table album_artist. The value in column total_length is the total length of the album in minutes.

Hint: For column list_of_artists use an aggregate function not covered in class. The full list of aggregate functions available in MySQL is available at https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html. Use also the tips from the article https://stackoverflow.com/questions/7745609/sql-select-only-rows-with-max-value-on-a-column.
 
- Write trigger **CheckReleaseDate** that does the following. Assume a new row (S, A, TN) is inserted into table song_album with song_id S, album_id A and track_no TN. Check if the release date of song S is later than the release date of album A. If this is the case, then change the release date of song S in table songs to be the same as the release date of album A.

- Write stored procedure **AddTrack(A, S)** where A is an album_id and S is a songs_id. The procedure should check if A is an album_id already existing in table albums and S is a song_id already existing in table songs. If both conditions are satisfied then the procedure should insert data row (S, A, TN+1) into table song_album where TN is the highest track_no for album A in table song_album before inserting the row.

- Write stored function **GetTrackList(A)** which, for a given album_id A, returns a comma-separated list of the names of all songs on the album ordered according to their track_no.

Hint: Use an aggregate function not covered in class. The full list of aggregate functions available in MySQL is available at https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html.

- Write all the code for creating the two views, the trigger, the stored procedure and the stored function in a text file named album_collection_code.sql.

You may insert any data you want into the database in order to test your code. Please do not include code for inserting data into the database in the file album_collection_code.sql. The file album_collection_code.sql must contain only CREATE VIEW, CREATE TRIGGER, CREATE PROCEDURE and CREATE FUNCTION statements. It is OK to create other views, procedures or functions if that helps you to write the required ones.

The file album_collection_code.sql must be a simple text file that can be opened with Windows Notepad. 

## Task 2. ERD
Draw an entity-relationship diagram (ERD) for the schema in album_collection_schema.sql. Save the ERD as a PNG file album_collection_erd.png.
