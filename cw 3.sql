--4)Wyznacz liczbę budynków położonych w odległości mniejszej niż 1000 m od głównych rzek. 
--Budynki spełniające to kryterium zapisz do osobnej tabeli tableB.
SELECT COUNT(popp.f_codedesc) AS buildings FROM popp, majrivers WHERE st_length(st_shortestline(popp.geom, majrivers.geom)) < 1000 AND f_codedesc='Building'
SELECT popp.f_codedesc AS buildings INTO tableB FROM popp, majrivers WHERE st_length(st_shortestline(popp.geom, majrivers.geom)) < 1000 AND f_codedesc='Building'

--5)Utwórz tabelę o nazwie airportsNew. Z tabeli airports do zaimportuj nazwy lotnisk, 
--ich geometrię, a także atrybut elev, reprezentujący wysokość n.p.m.
SELECT geom, name, elev INTO airportsNew FROM airports;
--a)Znajdź lotnisko, które położone jest najbardziej na zachód i najbardziej na wschód.
--zachód
SELECT NAME FROM airportsNew ORDER BY ST_X(geom) LIMIT 1;
--wschód
SELECT name FROM airportsNew ORDER BY ST_X(geom) desc LIMIT 1;
  -- b) Do tabeli airportsNew dodaj nowy obiekt - lotnisko, które położone jest w punkcie środkowym drogi pomiędzy lotniskami znalezionymi w punkcie a. 
-- Lotnisko nazwij airportB. Wysokość n.p.m. przyjmij dowolną.

INSERT INTO airportsNew 
VALUES ('airportB', (SELECT ST_Centroid (ST_MakeLine(
    (SELECT geom FROM airportsNew WHERE name = 'ATKA'),
    (SELECT geom FROM airportsNew WHERE name = 'ANNETTE ISLAND')))),150);
	--6)Wyznacz pole powierzchni obszaru, który oddalony jest mniej niż 1000 jednostek od 
--najkrótszej linii łączącej jezioro o nazwie ‘Iliamna Lake’ i lotnisko o nazwie „AMBLER”

SELECT ST_Area(ST_Buffer(ST_Shortestline(lakes.geom,airports.geom),1000)) AS area
FROM lakes, airports 
WHERE lakes.names = 'Iliamna Lake' AND airports.name = 'AMBLER';

--7)Napisz zapytanie, które zwróci sumaryczne pole powierzchni poligonów reprezentujących 
--poszczególne typy drzew znajdujących się na obszarze tundry i bagien (swamps).
SELECT SUM(ST_Area(tree.geom)), tree.vegdesc
FROM trees tree, swamp swamps, tundra tundras
WHERE ST_Contains(tree.geom, swamps.geom) OR ST_Contains(tree.geom, tundras.geom)
GROUP BY tree.vegdesc;