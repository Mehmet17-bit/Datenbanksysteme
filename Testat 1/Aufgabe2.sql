use testat_teil2;

Create Table mitarbeiter(
PNr int PRIMARY KEY,
Name varchar(255),
Abteilung varchar(255)
);

Create Table projektmitarbeit(
PNr int references mitarbeiter(PNr),
ProjektNr int references projekt(ProjektNr),
Taetigkeit varchar(255),
Stunden int
);

Create Table  projekt(
ProjektNr int PRIMARY KEY,
ProjektName varchar(255),
Beginndatum DATE,
Budget DECIMAL(8,2)
);

INSERT INTO mitarbeiter VALUES
(1, 'Fred Feuerstein', 'IT-Anwendungen'),
(2, 'Nerdy Nerd', 'Hardwaremaster'),
(3, 'Razor', 'Developer'),
(4, 'Mr. Right', 'IT_Anwendungen'),
(5, 'Unknown', 'Security'),
(6, 'Roy Kater', 'Developer');

INSERT INTO projektmitarbeit VALUES
(1, 2000, 'Projektleiter', 35),
(1, 2222, 'Assistent',  15),
(2, 2100, 'Protokollant', 8),
(2, 2222, 'Protokollant', 6),
(3, 2555, 'Projektleiter', 40),
(3, 2600, 'Assistent', 25),
(4, 2555, 'Assistent', 16),
(4, 2100, 'Assistent', 24),
(5, 2000, 'Protokollant', 7),
(5, 2555, 'Assistent', 22),
(6, 2222, 'Projektleiter', 23),
(6, 2000, 'Assistent', 14);

INSERT INTO projekt VALUES
(2000, 'Mobile Business Intelligence', '2020-02-01', 260000.00),
(2100, 'Artifical Intelligence', '2019-06-17', 185000.00),
(2222, 'Game Analyzing', '2016-04-22', 100000.00),
(2555, 'Enviroment Intelligence', '2018-08-18', 320000.00),
(2600, 'Database Structer', '2017-02-29', 220000.00);

update projekt set Beginndatum = '2017-02-24'
where ProjektNr = 2600;


SELECT ProjektName, Budget
FROM projekt
where Budget >= 175000
order by Budget DESC;


select projekt.ProjektName, 'Groesstes Budget' as Budget
from projekt
where projekt.budget
having MAX(projekt.Budget)
UNION
select projekt.ProjektName, 'Kleinstes Budget' as Budget
from projekt
where projekt.Budget = (select MIN(Budget)
						from projekt); 
                        
                        
                        

select projekt.ProjektName, 'Groesstes Budget' as Budget
from projekt
where projekt.Budget = (select MAX(Budget)
						from projekt)
UNION
select projekt.ProjektName, 'Kleinstes Budget' as Budget
from projekt
where projekt.Budget = (select MIN(Budget)
						from projekt);
                        
                        

select SUM(Budget) AS Gesamtbudget
from projekt;


select mitarbeiter.Name
from mitarbeiter join projektmitarbeit
on mitarbeiter.PNr = projektmitarbeit.PNr join projekt
on projektmitarbeit.ProjektNr = projekt.ProjektNr
where mitarbeiter.Abteilung = 'IT-Anwendungen' AND projekt.ProjektName = 'Mobile Business Intelligence'
group by mitarbeiter.PNr;

select projekt.ProjektName, COUNT(mitarbeiter.PNr) AS Anzahl_der_Mitarbeiter
from projekt join projektmitarbeit
on projekt.ProjektNr = projektmitarbeit.ProjektNr join mitarbeiter
on mitarbeiter.PNr = projektmitarbeit.PNr
where mitarbeiter.PNr = projektmitarbeit.PNr And projekt.ProjektNr = projektmitarbeit.ProjektNr
group by projekt.ProjektNr; 

select projekt.ProjektName
from projekt, projektmitarbeit
where NOT exists(select Taetigkeit from projektmitarbeit
										where projektmitarbeit.Taetigkeit = 'Projektleiter' AND projekt.ProjektNr = projektmitarbeit.ProjektNr)
group by projekt.ProjektNr;


select mitarbeiter.Name , SUM(projektmitarbeit.Stunden) AS Gesamtstunden
from projektmitarbeit join projekt
on projektmitarbeit.Taetigkeit = 'Projektleiter' AND projektmitarbeit.ProjektNr = projekt.ProjektNr AND projekt.Budget > 250000 join mitarbeiter
on mitarbeiter.PNr = projektmitarbeit.PNr AND Name IS NOT NULL
group by mitarbeiter.Name;

select Name, SUM(Stunden) AS Gesamtstunden
from projektmitarbeit
left join mitarbeiter 
on mitarbeiter.PNr = projektmitarbeit.PNr AND Taetigkeit = 'Projektleiter'
left join projekt 
on projekt.ProjektNr = projektmitarbeit.ProjektNr
where projekt.Budget > 250000 AND Name IS NOT NULL
group by Name;

select mitarbeiter.Name
from mitarbeiter 
where Name like "N%" OR Name like "R%";

select projekt.ProjektName, projekt.Budget AS urspruengliche_Budget, projekt.Budget * 1.08 AS neue_Budget 
from projekt 
where projekt.ProjektName = 'Mobile Business Intelligence' 
UNION
select projekt.ProjektName, projekt.Budget AS urspruengliche_Budget, projekt.Budget * 1.04 AS neue_Budget 
from projekt
where Beginndatum > '2015-12-31' AND Beginndatum < '2017-01-01'
order by ProjektName ASC;

select projekt.ProjektName, mitarbeiter.Name, projektmitarbeit.Taetigkeit 
from mitarbeiter, projektmitarbeit, projekt
where mitarbeiter.PNr = projektmitarbeit.PNr AND projekt.ProjektNr = projektmitarbeit.ProjektNr
group by mitarbeiter.PNr, projekt.ProjektNr
order by projekt.ProjektName, mitarbeiter.Name ASC;