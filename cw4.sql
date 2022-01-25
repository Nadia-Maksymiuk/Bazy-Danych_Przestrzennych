CREATE DATABASE cwiczenie4;
CREATE EXTENSION postgis;

--ZADANIE 1
--Utwórz tabelę obiekty. W tabeli umieść nazwy i geometrie obiektów przedstawionych na rysunkach. Układ odniesienia ustal jako niezdefiniowany.
CREATE TABLE obiekty (id INT PRIMARY KEY, nazwa VARCHAR(20) NOT NULL, geom GEOMETRY NOT NULL);

INSERT INTO obiekty VALUES(
1, 'obiekt1', ST_GeomFromEWKT('SRID=0;COMPOUNDCURVE(LINESTRING(0 1, 1 1), CIRCULARSTRING(1 1, 2 0, 3 1), 
							  CIRCULARSTRING(3 1, 4 2, 5 1), LINESTRING(5 1, 6 1))'));

INSERT INTO obiekty VALUES(
2, 'obiekt2', ST_GeomFromEWKT('SRID=0;CURVEPOLYGON(COMPOUNDCURVE(LINESTRING(10 6, 14 6), CIRCULARSTRING(14 6, 16 4, 14 2), 
							  CIRCULARSTRING(14 2, 12 0, 10 2), LINESTRING(10 2, 10 6)), CIRCULARSTRING(11 2, 13 2, 11 2))'));
							  
INSERT INTO obiekty VALUES(
3, 'obiekt3', ST_GeomFromEWKT('SRID=0;POLYGON((7 15, 10 17, 12 13, 7 15))'));

INSERT INTO obiekty VALUES(
4, 'obiekt4', ST_GeomFromEWKT('SRID=0;MULTILINESTRING((20 20, 25 25), (25 25, 27 24), (27 24, 25 22), 
							  (25 22, 26 21), (26 21, 22 19), (22 19, 20.5 19.5))'));
							  
INSERT INTO obiekty VALUES(
5, 'obiekt5', ST_GeomFromEWKT('SRID=0;MULTIPOINTM((30 30 59), (38 32 234))'));

INSERT INTO obiekty VALUES(
6, 'obiekt6', ST_GeomFromEWKT('SRID=0;GEOMETRYCOLLECTION(POINT(4 2), LINESTRING(1 1, 3 2))'));

SELECT nazwa, ST_CurveToLine(geom) FROM obiekty;

--ZADANIE 2
--Wyznacz pole powierzchni bufora o wielkości 5 jednostek, który został utworzony wokół najkrótszej linii łączącej obiekt 3 i 4:
SELECT ST_Area(ST_Buffer(ST_ShortestLine(obiekt3.geom, obiekt4.geom), 5)) AS PolePowierzchni
FROM obiekty obiekt3, obiekty obiekt4 WHERE obiekt3.nazwa = 'obiekt3' AND obiekt4.nazwa = 'obiekt4'; 

--ZADANIE 3
--Zamień obiekt4 na poligon. Jaki warunek musi być spełniony, aby można było wykonać to zadanie? Zapewnij te warunki.
UPDATE obiekty SET geom = ST_GeomFromEWKT('SRID=0;POLYGON((20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5, 20 20))')
WHERE nazwa = 'obiekt4';

SELECT (ST_DumpPoints(geom)).geom AS pkt INTO punkty FROM obiekty WHERE nazwa = 'obiekt4';
INSERT INTO punkty VALUES(ST_geomfromewkt('POINT(20 20)'));
UPDATE obiekty SET geom = (
					SELECT ST_MakePolygon(ST_MakeLine(pkt)) FROM punkty 
) WHERE nazwa = 'obiekt4';

--SELECT nazwa, ST_GeometryType(geom) FROM obiekty;

--ZADANIE 4
--W tabeli obiekty, jako obiekt7 zapisz obiekt złożony z obiektu3 i obiektu4
INSERT INTO obiekty VALUES(7, 'obiekt7', 
(
	SELECT ST_Collect(obiekt3.geom, obiekt4.geom) 
	FROM obiekty obiekt3, obiekty obiekt4 WHERE obiekt3.nazwa = 'obiekt3' AND obiekt4.nazwa = 'obiekt4'
));

--ZADANIE 5
--Wyznacz pole powierzchni wszystkich buforów o wielkości 5 jednostek, które zostały utworzone wokół obiektów nie zawierających łuków
SELECT nazwa, ST_Area(ST_Buffer(geom, 5)) 
FROM obiekty WHERE NOT ST_HasArc(geom);