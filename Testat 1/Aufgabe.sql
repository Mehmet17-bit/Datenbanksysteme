use testat_teil1;

create table Mitarbeiter(
PNr int PRIMARY KEY,
Name varchar(25),
AbtNr int references Abteilung(AbtNr),
Gehalt decimal(6,2)
);

create table Abteilung(
AbtNr int PRIMARY KEY,
AbtName varchar(25)
);



create table hotel(
HNr int PRIMARY KEY,
HName varchar(50),
Kategorie varchar(20),
PLZ int,
Ort varchar(30)
);

create table reisen(
Mitarbeiter varchar(30) references Mitarbeiter(PNr),
Hotel varchar(30) references Hotel(HNr),
Beginndatum DATE,
Dauer int,
Kosten decimal(6,2)
);


insert into mitarbeiter values(1 ,'Diluc Feuer', 1, 2650.00);

insert into mitarbeiter values
(2 ,'Fischl Elektro', 2, 3000.00),
(3, 'Diona Water', 3, 2700.00),
(4, 'Boruto Uzumaki', 4, 5000.00),
(5, 'Sarada Uchia', 4, 4500.00);

update mitarbeiter set AbtNr = 4
where PNr = 5;
                            
                            
select * from Mitarbeiter;

insert into abteilung values
(1, 'Ingenieur'),
(2, 'Entwickler'),
(3, 'Security'),
(4, 'Allrounder');
select * from abteilung;

drop table reisen;

select * from mitarbeiter ,abteilung
where mitarbeiter.AbtNr = abteilung.AbtNr;

insert into hotel values
(1, 'Hotel City', '5 Sterne', 70010, 'Hamburg'),
(2, 'Melbourne Hostel', '3 Sterne', 78000, 'Köln'),
(3, 'Meininger', '4 Sterne', 80000, 'Berlin'),
(4, 'Boden City', '2 Sterne', 75020, 'München'),
(5, 'Paradise', '5 Sterne', 77777, 'Frankfurt'),
(6, 'Sheap City', '1 Stern', 20202, 'Gallus'),
(7, 'Ibiz Hotel', '3 Sterne', 77000, 'Frankfurt'),
(8, 'Feel Free Hotel', '4 Sterne', 70000, 'Hamburg'),
(9, 'Konaha City', '5 Sterne', 74001, 'Tokio'),
(10, 'Luxury Place', '5 Sterne', 65432, 'Bali');


select * from hotel;

UPDATE abteilung SET AbtName = 'Softwareentwicklung'
WHERE AbtNr = 2;

Select * from abteilung;

select PNr, Name, MIN(Gehalt) AS niedrigsterGehalt
from mitarbeiter
where Gehalt;

select Name from mitarbeiter;

select HNr, HName, Kategorie, PLZ, Ort
from hotel
where HName like "%city" AND PLZ BETWEEN 70000 AND 78000;

insert into reisen values
(1, 'Konoha City', '2020-04-17', 5, 1250.00),
(1, 'Paradise', '2019-05-17', 4, 2220.00),
(1, 'Feel Free Hotel', '2020-01-01', 2, 1575.00),
(2, 'Luxury Place', '2020-09-22', 4, 3100.00),
(2, 'Paradise', '2019-05-17', 6, 3100.00),
(2, 'Hotel City', '2020-03-18', 4, 1900.00),
(3, 'Ibiz Hotel', '2019-06-12', 1, 1000.00),
(3, 'Hotel City', '2018-05-18', 7, 3150.00),
(3, 'Melbourne Hostel', '2020-11-23', 1, 1150.00),
(4, 'Meiniger', '2019-11-10', 5, 3225.00),
(4, 'Sheap City', '2019-02-13', 3, 1225.00),
(4, 'Meininger', '2020-04-06', 2, 1110.00),
(5, 'Ibiz Hotel', '2020-04-15', 2, 1000.00),
(5, 'Meiniger', '2019-07-06', 4, 2100.00),
(5, 'Feel Free Hostel', '2018-08-25', 4, 1870.00);

select * from reisen;

select PNr, Name 
from mitarbeiter, abteilung
where mitarbeiter.AbtNr = abteilung.AbtNr AND AbtName = 'Softwareentwicklung'
order by PNr ASC;

select PNr, Name, MIN(Gehalt) AS niedrigsterGehalt
from mitarbeiter
where Gehalt;

select PNr, Name, Gehalt AS niedrigsterGehalt
from mitarbeiter
where Gehalt
having MIN(Gehalt); 

select HNr, HName, Kategorie, PLZ, Ort
from hotel
where HName like "%city" AND PLZ BETWEEN 70000 AND 78000;

select mitarbeiter.Name,mitarbeiter.PNr,COUNT(reisen.mitarbeiter) AS Anzahl_Reisen, ROUND(AVG(reisen.Kosten),2) AS Durchschnittskosten
from reisen, mitarbeiter
where mitarbeiter.PNr = reisen.mitarbeiter
group by reisen.mitarbeiter, mitarbeiter.name
order by mitarbeiter.Name DESC; 

select mitarbeiter.Name
from reisen join mitarbeiter
on mitarbeiter.PNr = reisen.Mitarbeiter join hotel 
on hotel.HNr = reisen.Hotel
where hotel.ort = 'Hamburg'
group by mitarbeiter.PNr;


select mitarbeiter.name, mitarbeiter.PNr, abteilung.AbtName, reisen.Kosten,reisen.Beginndatum
from mitarbeiter
join reisen
on reisen.Mitarbeiter = mitarbeiter.PNr
join abteilung
on abteilung.AbtNr = mitarbeiter.AbtNr
where Kosten IN(select MAX(Kosten)
				from reisen)
order by Beginndatum;   


select distinct m1.Mitarbeiter, m2.Mitarbeiter, hotel.HName, m1.Beginndatum
from mitarbeiter, hotel, reisen m1, reisen m2
where m1.Mitarbeiter != m2.Mitarbeiter AND hotel.HNr = m1.Hotel AND m1.Hotel = m2.Hotel AND m1.Beginndatum = m2.Beginndatum;
			

select hotel.HNr,hotel.HName
from hotel join reisen
where hotel.HNr = reisen.Hotel
group by reisen.hotel
having COUNT(*) >= 2;

select hotel.HNr, hotel.HName, SUM(reisen.Dauer),ROUND(SUM(reisen.Kosten)/SUM(reisen.Dauer),2)
from hotel join reisen
on hotel.HName = reisen.Hotel
group by hotel.HNr, reisen.Hotel
order by hotel.HNr ASC;


select COUNT(HNr) AS Hotel_Anzahl
from hotel
left join reisen
on reisen.Hotel = hotel.HNr
Where reisen.Hotel IS NULL;

