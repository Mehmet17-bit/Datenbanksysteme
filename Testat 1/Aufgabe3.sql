use testat_teil3;

create table zutat(
id_zutat int PRIMARY KEY,
bezeichnung varchar(255)
);

create table rezept(
id_rezept int Primary Key,
id_benutzer int references benutzer(id_benutzer),
titel varchar(255),
portionen int,
dauer TIME
);

create table rezept_schritt(
id_rezept int references rezept(id_rezept),
nr_schritt int,
titel varchar(255),
anweisung varchar(255)
);

create table schritt_zutat(
id_rezept int references rezept(id_rezept),
nr_schritt int references rezept_schritt(nr_schritt),
zutat varchar(255) references zutat(id_zutat),
menge int,
einheit ENUM('g','kg','ml','l','tl','el')
);

create table benutzer(
id_benutzer int Primary key,
benutzername varchar(255),
email varchar(255)
);

create table bewertung(
id_rezept int references rezept(id_rezept),
id_benutzer int references benutzer(id_benutzer),
anzahl_sterne int,
datum DATE
);

INSERT INTO zutat VALUES
(1, 'Weizen'),
(2, 'Butter'),
(3, 'Milch'),
(4, 'Zucker'),
(5, 'Nutella'),
(6, 'Soja'),
(7, 'Sahne'),
(8, 'Backpulver'),
(9, 'Eier'),
(10, 'Beeren');

INSERT INTO rezept VALUES
(11, 1000, 'Nutellapizza', 3, '00:45:00'),
(22, 1001, 'Sahnetarta', 5, '00:30:00'),
(33, 1002, 'Beeren a la Rista', 2, '01:00:00'),
(44, 1003, 'Pudding', 6, '00:25:00'),
(55, 1004, 'Zuckerbombe', 4, '01:30:00');

INSERT INTO benutzer VALUES
(1000, 'chef123', 'chef123@yahoo.de'),
(1001, 'Backoo', 'backoo@gmail.de'),
(1002, 'Carlos', 'carlos@hotmail.com'),
(1003, 'Kessie', 'kessie@webmail.de'),
(1004, 'Rivale', 'rivale@riv-mx.de');

INSERT INTO bewertung VALUES
(33, 1002, 4, '2020-10-17'),
(11, 1004, 5, '2020-03-10'),
(22, 1001, 3, '2020-12-30'),
(55, 1003, 5, '2020-05-12'),
(22, 1000, 3, '2020-06-06');

INSERT INTO rezept_schritt VALUES
(11,1, 'Nutellapizza', 'durchknetten'),
(11,2, 'Nutellapizza', 'verühren'),
(22,1, 'Sahnetarta', 'Sahne eingeben'),
(22,2, 'Sahnetarta', 'alles durchrühren'),
(33,1, 'Beeren a la Rista', 'Beeren dazu geben'),
(33,2, 'Beeren a la Rista', 'kühlen lassen'),
(44,1, 'Pudding', 'Milch und Nutella hinzufügen'),
(44,2, 'Pudding', 'verrühren'),
(55,1, 'Zuckerbombe', 'viel Zucker eingeben'),
(55,2, 'Zuckerbombe', 'ein Schuss Sahne');

INSERT INTO schritt_zutat VALUES
(11, 1, 1, 100, 'g'),
(11, 1, 5, 75, 'g'),
(11, 2, 8, 200, 'g'),
(22, 1, 1, 150, 'g'),
(22, 1, 2, 50, 'g'),
(22, 2, 3, 100, 'ml'),
(22, 2, 7, 10, 'g'),
(33, 1, 4, 5, 'tl'),
(33, 2, 6, 250, 'ml'),
(33, 2, 10, 25, 'g'),
(44, 1, 3, 300, 'ml'),
(44, 1, 4, 3, 'tl'),
(44, 2, 5, 100, 'g'),
(44, 2, 9, 4, 'g'),
(55, 1, 2, 125, 'g'),
(55, 1, 4, 6, 'el'),
(55, 1, 5, 50, 'g'),
(55, 2, 7, 2, 'el'),
(55, 2, 8, 75, 'g'),
(55, 2, 9, 2, 'g');

Select * from benutzer;
Select * from bewertung;
Select * from rezept;
Select * from schritt_zutat;
Select * from zutat;
Select * from rezept_schritt;


Select titel, (HOUR(dauer)*60+MINUTE(dauer)) AS Dauer_Minuten
from rezept
where portionen > 3
order by id_benutzer ASC;

SELECT rezept.titel, benutzer.benutzername
FROM (rezept INNER JOIN benutzer ON rezept.id_benutzer = benutzer.id_benutzer)
WHERE ((SELECT COUNT(bewertung.id_benutzer) FROM bewertung WHERE (bewertung.id_rezept = rezept.id_rezept) AND (bewertung.datum >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR))) >= 3) AND ((SELECT AVG(bewertung.anzahl_sterne) FROM bewertung WHERE (bewertung.id_rezept = rezept.id_rezept) AND (bewertung.datum >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR))) >= 4)
ORDER BY rezept.titel ASC;

Select r.titel, b.benutzername, AVG(bw.anz_sterne), COUNT(bw.anz_sterne)
from bewertung bw, benutzer b, rezept r
where r.id_rezept = bw.id_rezept and b.id_benutzer = bw.id_benutzer
order by r.titel, b.benutzername, AVG(bw.anz_sterne), COUNT(bw.anz_sterne) DESC;

Select zutat.bezeichnung
from zutat left join schritt_zutat
on zutat.id_zutat = schritt_zutat.zutat
where schritt_zutat.zutat is NULL 
order by zutat.bezeichnung ASC;

SELECT rezept.titel, MAX(rezept_schritt.nr_schritt) AS 'Schritte'
FROM (rezept INNER JOIN rezept_schritt ON rezept.id_rezept=rezept_schritt.id_rezept)
WHERE (SELECT MAX(Tbl.Anzahl)
  FROM (SELECT zutat.id_zutat, schritt_zutat.id_rezept, COUNT(zutat.id_zutat) AS 'Anzahl'
    FROM (schritt_zutat INNER JOIN zutat ON schritt_zutat.zutat = zutat.id_zutat)
    GROUP BY zutat.id_zutat, schritt_zutat.id_rezept) AS Tbl
  WHERE Tbl.id_rezept = rezept.id_rezept) >= 2
GROUP BY rezept.id_rezept
ORDER BY rezept.id_rezept ASC;

SELECT rezept.titel, benutzer.benutzername FROM rezept,benutzer,schritt_zutat,zutat
WHERE rezept.id_benutzer = benutzer.id_benutzer AND schritt_zutat.id_rezept = rezept.id_rezept AND zutat.id_zutat = schritt_zutat.zutat
AND zutat.bezeichnung = "Milch" 
GROUP BY rezept.id_rezept
HAVING SUM(schritt_zutat.menge) >= 200;

select benutzername 
from benutzer b inner join bewertung bw
on b.id_benutzer = bw.id_benutzer
where anz_sterne >= 4
Having Count(b.id_benutzer) >= 3
order by b.id_benutzer ASC;

select id_zutat, bezeichnung
from zutat z
where not exists(select id_zutat
				from schritt_zutat SZ join rezept r 
                on r.id_rezept = SZ.id_rezept
                where r.titel = 'Pfannkuchen mit Sahne' AND z.id_zutat = SZ.zutat)
                
                
order by id_zutat ASC;

SELECT COUNT(benutzer.id_benutzer)
FROM (benutzer INNER JOIN (benutzer AS benutzer2) ON ((benutzer.id_benutzer < benutzer2.id_benutzer) AND (benutzer.email = benutzer2.email)));

SELECT Z.bezeichnung, COUNT(DISTINCT SZ.id_rezept) AS Anzahl_Rezepte FROM zutat Z
JOIN schritt_zutat SZ On Z.id_zutat=SZ.zutat
GROUP BY id_zutat
ORDER BY id_zutat ASC;

select SEC_TO_TIME(Sum(SEC_TO_TIME(r.dauer)))
from rezept r join benutzer
on r.id_benutzer = benutzer.id_benutzer and benutzer.benutzername = 'chef123'
group by benutzer.benutzername;

Select COUNT(nr_schritt)/ COUNT(DISTINCT id_rezept) 
FROM rezept_schritt;