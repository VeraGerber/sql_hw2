CREATE TABLE IF NOT EXISTS singer 
(
	id SERIAL PRIMARY KEY,
	singer_name VARCHAR(80) NOT NULL
	
	INSERT INTO singer(ID,singer_name)
	values
		(1, 'KISS'),
		(2, 'SLIPKNOT'),
		(3, 'Queen'),
		(4, 'Metallica');

);


CREATE TABLE IF NOT EXISTS genre (
	id SERIAL PRIMARY KEY,
	genre_name VARCHAR(40) NOT null
	
INSERT INTO genre(ID,genre_name)
	values
		(1,'shock-rock'),
		(2,'groove-metal'),
		(3,'pop-rock'),
		(4,'heavy-metal')
);

CREATE TABLE IF NOT EXISTS album(
	id SERIAL PRIMARY key 
	album_name VARCHAR(40),
	year_of_issue date
	
	INSERT INTO album(ID,album_name,year_of_issue)
	values
		(1,'Psyho_Circus', '1998-09-22'),
		(2,'All_Hope_is_Gone', '2008-08-20'),
		(3,'Made_in_Heaven', '1995-11-06'),
		(4,'Master_of_Puppets', '1986-03-03');
		
);

CREATE TABLE IF NOT EXISTS track (
	id SERIAL PRIMARY KEY,
	track_name VARCHAR(40),
	album_name VARCHAR(40),
	track_duration VARCHAR(8)
	
	INSERT INTO track(ID,track_name,album_name,track_duration)
	values
		(1, 'We_are_one', 'Psycho_Circus', '200'),
		(2,'You_wanted_best', 'Psycho_Circus', '300'),
		(3,'Sulfur', 'All_Hope_is_Gone' '250'),
		(4,'Vendetta', 'All_Hope_is_Gone', '267'),
		(5,'Let_me_live', 'Made_in_Heaven' '180'),
		(6,'Mother_love', 'Made_in_Heaven', '157'),
		(7,'Battery', 'Master_of_Puppets', '199'),
		(8, 'Welcome_home', 'Master_of_Puppets', '198');
	
);
			
CREATE TABLE IF NOT EXISTS creation (
	singer_id INTEGER REFERENCES singer(id),
	genre_id INTEGER REFERENCES genre(id)

	INSERT INTO creation (singer_id, genre_id) 
  		values
 			(1, 1), 
 			(2, 2), 
 			(3, 3), 
 			(4, 3);
);

CREATE TABLE IF NOT EXISTS joint_album (
	singer_id INTEGER REFERENCES singer(id),
	album_id INTEGER REFERENCES album(id)
	
	INSERT INTO joint_album (singer_id, album_id) 
  		VALUES 
  			(1, 1), 
  			(2, 2), 
  			(2, 3), 
  			(3, 4), 
  			(4, 4);

);

CREATE TABLE IF NOT EXISTS collection (
	id SERIAL PRIMARY KEY,
	collection_name VARCHAR(40),
	year_of_issue date

	INSERT INTO collection (ID,collection_name,year_of_issue)
		values
			(1, 'Metallica and Slipknot', '1996-01-01'),
			(2, 'Queen Kiss', '1999-01-01'),
			(3, 'Metall collection', '2000-01-01'),
			(4, 'Gold', '2020-01-01');
			
);

CREATE TABLE IF NOT EXISTS collection_tracks (
	track_id INTEGER REFERENCES track(id),
	album_id INTEGER REFERENCES album(id)
	
	INSERT INTO collection_tracks(album_id,track_id) 
  		VALUES 
  			(1, 1), 
  			(2, 2), 
  			(4, 3), 
  			(3, 4), 
  			(3, 3), 
  			(4, 3);
);


--Название и продолжительность самого длительного трека.--
SELECT track_name, track_duration
FROM track
WHERE track_duration = (SELECT MAX(track_duration) FROM track);
   
-- Название треков, продолжительность которых не менее 3,5 минут--
SELECT track_name
FROM track
WHERE track_duration > 210;

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT collection_name
FROM collection
WHERE year_of_issue BETWEEN 2018 AND 2020;

-- Исполнители, чьё имя состоит из одного слова--
SELECT singer_name
FROM singer
WHERE singer_name NOT LIKE '% %';

-- Название треков, которые содержат слово «мой» или «my»--
SELECT track_name
FROM track
WHERE track_name LIKE '%мой%' OR track_name LIKE '%my%';

-- количество исполнителей в каждом жанре--
SELECT genre_name, count(creation.singer_id) 
  FROM genre 
  JOIN creation ON genre.id = creation.genre_id 
  GROUP BY genre_name;
 
-- количество треков, вошедших в альбомы 2019-2020 годов;
SELECT album_name, album.year_of_issue , count(track.album_id) 
  FROM album
  JOIN track ON album_id= track.album_id 
  WHERE album.year_of_issue BETWEEN 2019 AND 2020
  GROUP BY album_name, album.year_of_issue;
 
--средняя продолжительность треков по каждому альбому;
SELECT album_name, AVG(track_duration)
  FROM album
  JOIN track ON album_id = track.album_id 
  GROUP BY album_name;
 
--все исполнители, которые не выпустили альбомы в 2020 году--
SELECT sn.singer_name,
FROM singer sn
LEFT JOIN album a ON sn singer_id = a.singer_id
LEFT JOIN album a ON a.album_id = a.album_id
WHERE a.year_of_issue <> 2020 OR a.year_of_issue IS NULL;  FROM singer

 
--Названия сборников, в которых присутствует конкретный исполнитель--
 SELECT collection_name FROM collection
  JOIN collection_tracks ON collection.id = collection_tracks.collection_id
  JOIN track ON collection_tracks.track_id = track.id
  JOIN album ON track.album_id = album_id
  JOIN creation ON album.id = creation.album_id
  JOIN singer ON singer.id = creation.singer_id
  WHERE singer.name = 'Metallica'
