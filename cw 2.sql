CREATE DATABASE cw2;
CREATE EXTENSION postgis;

CREATE TABLE buildings(ID integer PRIMARY KEY NOT null, geometry geometry, NAME varchar(15));
CREATE TABLE roads(ID integer PRIMARY KEY NOT null, geometry geometry, NAME varchar(15));
CREATE TABLE poi(ID integer PRIMARY KEY NOT null, geometry geometry, NAME varchar(15));

--buildings
INSERT INTO buildings(ID, geometry, NAME) VALUES (1, ST_GeomFromText('POLYGON((8 4, 8 1.5, 10.5 1.5, 10.5 4, 8 4))',0), 'BuildingA');
INSERT INTO buildings(ID, geometry, NAME) VALUES (2, ST_GeomFromText('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))',0), 'BuildingB');
INSERT INTO buildings(ID, geometry, NAME) VALUES (3, ST_GeomFromText('POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))',0), 'BuildingC');
INSERT INTO buildings(ID, geometry, NAME) VALUES (4, ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))',0), 'BuildingD');
INSERT INTO buildings(ID, geometry, NAME) VALUES (5, ST_GeomFromText('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))',0), 'BuildingE');

--points 
INSERT INTO poi(ID, geometry, NAME) VALUES (1, ST_GeomFromText('POINT(1 3.5)',0), 'G');
INSERT INTO poi(ID, geometry, NAME) VALUES (2, ST_GeomFromText('POINT(5.5 1.5)',0), 'H');
INSERT INTO poi(ID, geometry, NAME) VALUES (3, ST_GeomFromText('POINT(9.5 6)',0), 'I');
INSERT INTO poi(ID, geometry, NAME) VALUES (4, ST_GeomFromText('POINT(6.5 6)',0), 'J');
INSERT INTO poi(ID, geometry, NAME) VALUES (5, ST_GeomFromText('POINT(6 9.5)',0), 'K');

--roads
INSERT INTO roads(ID, geometry, NAME) VALUES (1, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',0), 'RoadX');
INSERT INTO roads(ID, geometry, NAME) VALUES (2, ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)',0), 'RoadY');

--6A)
SELECT SUM(st_length( ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',0)) + st_length(ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)',0))) AS total_length; 

--6B)
SELECT ST_AsEWKT(buildings.geometry) AS geometry, ST_Area(buildings.geometry) AS Area, ST_Perimeter(buildings.geometry) AS Perimeter
FROM buildings 
WHERE buildings.name='BuildingA';

--6C) 
SELECT buildings.name, ST_Area(buildings.geometry) AS Area
FROM buildings
ORDER BY buildings.name;

--6D)
SELECT buildings.name, ST_Perimeter(buildings.geometry) AS Perimeter
FROM buildings
ORDER BY ST_Area(buildings.geometry) DESC LIMIT 2;

--6E)
SELECT st_length(st_shortestline(buildings.geometry, poi.geometry)) FROM buildings, poi
    WHERE buildings.name = 'BuildingC' AND poi.name = 'G';

--6F) 
SELECT ST_Area(ST_Difference((SELECT buildings.geometry 
				  FROM buildings
				  WHERE buildings.name='BuildingC'), ST_buffer((SELECT buildings.geometry 
				  FROM buildings
				  WHERE buildings.name='BuildingB'),0.5))) AS Area;

--6G) 
SELECT buildings.name
FROM buildings, roads
WHERE ST_Y(ST_Centroid(buildings.geometry)) > ST_Y(ST_Centroid(roads.geometry)) AND roads.name='RoadX';

--6H) 
SELECT ST_Area(ST_Symdifference((SELECT buildings.geometry 
				  FROM buildings
				  WHERE buildings.name='BuildingC'),ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))',0))) AS Area;