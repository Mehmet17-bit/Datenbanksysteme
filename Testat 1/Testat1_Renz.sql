create database Testat_Renz;


create table Modul (
  ModulNr  char(6) primary key, 
  Titel	   varchar (60) not null 
);

create table Dozent (
  DozNr    integer primary key, 
  DozName  varchar (20) not null
);

create table Vorlesung (
  VNr        integer primary key, 
  Jahr	     integer not null, 
  Semester   char (1), 
  ModulNr    char (6) references Modul, 
  DozNr	     integer references Dozent,
  check (Semester in ('w','s'))
);

create table Student (
  MatrikelNr  integer primary key, 
  SName  varchar (20) not null
);

create table Teilnahme (
  MatrikelNr    integer references Student, 
  VNr    integer references Vorlesung,
  primary key (MatrikelNr, VNr)
);


insert into Dozent (DozNr, DozName) 
  values (1,'Dominikus'),
         (2,'Fritze'),
         (3,'Blosch'),
         (4,'Rein'),
         (5,'Just'),
         (6,'Bienhaus'),
         (7,'Schäfer'),
         (8,'Döring'),
         (9,'Cirkel'),
         (10,'Metz'),
         (11,'Renz'),
         (12,'Gundlach');


insert into Modul (ModulNr, Titel) 
  values ('CS1000','PIS'),
  		 ('CS1001','DBS'),
		 ('CS1002','WBS'),
		 ('CS1003','KSP'),
		 ('CS1004','SUD'),
		 ('CS1005','OOP'),
		 ('CS1006','DM'),
		 ('CS1007','LA'),
		 ('CS1008','CB'),
		 ('CS1009','NTG'),
		 ('CS1010','AUD');


insert into Student (MatrikelNr, SName) 
  values (1,'Akin'),
         (2,'Kaan'),
         (3,'Ufuk'),
         (4,'Murat'),
         (5,'Mehmet'),
         (6,'Nel'),
         (7,'Memjoo'),
         (8,'Samir'),
         (9,'Enes'),
         (10,'Mesut'),
         (11,'Ozan'),
         (12,'Merve'),
		 (13,'Ahmet'),
		 (14,'Adeel'),
		 (123456,'Alman');


insert into Vorlesung (VNr,Jahr,Semester,ModulNr,DozNr) 
  values (1,2021,'s','CS1000',1),
  		 (2,2021,'s','CS1001',11),
		 (3,2021,'s','CS1002',9),
		 (4,2021,'s','CS1003',4),
		 (5,2021,'s','CS1004',12),
		 (6,2020,'w','CS1005',6),
		 (7,2020,'w','CS1006',5),
		 (8,2020,'w','CS1007',3),
		 (9,2020,'w','CS1008',10),
		 (10,2019,'w','CS1009',2),
		 (11,2019,'w','CS1009',7),
		 (12,1996,'s','CS1010',8);


insert into Teilnahme (MatrikelNr, VNr)  
  values (1, 7),
         (2, 4),
         (3, 1),
         (4, 3),
         (5, 8),
         (6, 9),
         (7, 2),
         (8, 5),
         (9, 9),
         (10, 7),
         (11, 3),
         (12, 7),
         (13, 3),
         (14, 6),
         (123456, 12);
         
         
         
(g) (4 Pkt) Geben Sie alle Angaben zu den Vorlesungen aus, 
               an denen weniger als 6 Studierende teilnehmen. 
               Bitte beachten Sie, dass es auch sein könnte, dass 
               gar niemand an einer Vorlesung teilnimmt.
               
		
        
select * from Vorlesung 
join Modul using(ModulNr)
join Teilnahme using(VNr)
join Student using(MatrikelNr)
where SName IS NULL ;
