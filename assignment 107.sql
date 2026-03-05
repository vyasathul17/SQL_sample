create database Software_Programmer;
go
use Software_Programmer;
go

CREATE TABLE programmer(
	pname  varchar(20) PRIMARY KEY,
	dob  date,
	doj  date,
	gender varchar(1),
	prof1 varchar(20),
	prof2 varchar(20),
	salary  int
	);

insert into programmer values('anand', '1966-04-12','1992-04-21','m','pascal','basic',3200);
insert into programmer values('altaf', '1964-07-02','1990-11-13','m','clipper','cobol',2800);
insert into programmer values('juliana','1960-01-31','1990-04-21','f','cobol','dbase',3000);
insert into programmer values('kamala', '1968-10-30','1992-01-02','f','c','dbase',2900);
insert into programmer values('mary', '1970-06-24','1991-02-01','f','cpp','oracle', 4500);
insert into programmer values('nelson', '1985-09-11','1989-10-11','m','cobol','dbase',2500);
insert into programmer values('pattrick','1965-11-10','1990-04-21','m','pascal','clipper',2800);
insert into programmer values('qadir', '1965-08-31','1991-04-21','m','assembly', 'c',3000);
insert into programmer values('ramesh', '1967-05-03','1991-02-28','m','pascal','dbase',3200);
insert into programmer values('rebecca', '1967-01-01','1990-01-01','f','basic','cobol',2500);
insert into programmer values('remitha ', '1970-04-19','1993-04-20','f','c','assembly',3600);
insert into programmer values('revathi','1969-12-02','1992-01-02','f', 'pascal','basic',3700);
insert into programmer values('vijaya','1965-12-14','1992-05-02','f','foxpro','c',3500);


CREATE TABLE software(
	pname  varchar(20),
	title varchar(20),
	developin varchar(20),
	scost int,
	dcost int,
	sold int,
    FOREIGN KEY(pname) REFERENCES programmer(pname) ON DELETE CASCADE,
	);

insert into software values('mary','readme','cpp',300,1200,84);
insert into software values('anand', 'parachutes','basic', 399.95,6000, 43);
insert into software values('anand', 'videotitling','pascal', 7500, 16000, 9);
insert into software values('juliana', 'inventory','cobol', 3000, 3500, 0);
insert into software values('kamala', 'payrollpkg','dbase', 9000, 20000, 7);
insert into software values('mary', 'financialacct','oracle', 18000, 85000, 4);	
insert into software values('mary', 'codegenerator','c', 4500, 20000, 23);
insert into software values('pattrick', 'readme','cpp', 300, 1200, 84);	
insert into software values('qadir', 'bombsaway','assembly', 750, 3000, 11);	
insert into software values('qadir', 'vaccines','c', 1900, 3100, 21);
insert into software values('ramesh', 'hotelmgmt','dbase', 13000, 35000, 4);	
insert into software values('ramesh', 'deadlee','pascal', 599.95, 4500, 73);	
insert into software values('remitha', 'pcutilities','c', 725, 5000, 51);
insert into software values('remitha', 'tsrhelppkg','assembly', 2500, 6000, 7);
insert into software values('revathi', 'hotelmgmt','pascal', 1100, 75000, 2);
insert into software values('vijaya', 'tsreditor','c', 900, 700, 6);



CREATE TABLE studies(
	pname  varchar(20),
	institute varchar(20),
	course varchar(20),
	coursefee int ,
	PRIMARY KEY(pname),
    FOREIGN KEY(pname) REFERENCES programmer(pname) ON DELETE CASCADE,
	);




insert into studies values('anand', 'sabhari', 'pgdca', 4500);
insert into studies values('altaf', 'coit', 'dca', 7200);
insert into studies values('juliana', 'bdps', 'mca', 22000);
insert into studies values('kamala', 'pragathi', 'dca', 5000);
insert into studies values('mary', 'sabhari', 'pgdca', 4500);
insert into studies values('nelson', 'pragathi', 'dap', 4500);
insert into studies values('pattrick', 'pragathi', 'dcap', 6200);
insert into studies values('qadir', 'apple', 'hdca', 14000);
insert into studies values('ramesh', 'sabhari', 'pgdca', 4500);
insert into studies values('rebecca', 'brilliant', 'dcap', 11000);
insert into studies values('remitha ', 'bdps', 'dcs', 6000);
insert into studies values('revathi', 'sabhari', 'dap', 5000);
insert into studies values('vijaya', 'bdps', 'dca', 48000);

---1. Find out the selling cost AVG for packages developed in Pascal. 

select Avg(SCOST) as avg_cost from software
where developin = 'pascal'

--2. Display Names, Ages of all Programmers. 

select 
pname,
dob,
doj,salary,
DATEDIFF(YEAR,dob,GETDATE())
- case 
when DATEADD(YEAR,DATEDIFF(year,dob,getdate()),dob)>GETDATE()
then 1 else 0 
end as AgeYears,
DATEDIFF(MONTH,dob,GETDATE()) % 12 as AgeMonths,
DATEDIFF(DAY,DATEADD(MONTH,DATEDIFF(month,dob,getdate()),dob),getdate()) as Agedays
from programmer

------Experience---

select 
pname,
dob,
doj,
salary,
DATEDIFF(YEAR,doj,GETDATE())
- case 
when DATEADD(YEAR,DATEDIFF(year,doj,getdate()),doj)>GETDATE()
then 1 else 0
end as Experience,
DATEDIFF(MONTH,doj,GETDATE()) % 12 as Experience_Months,
DATEDIFF(DAY,DATEADD(Month,datediff(month,doj,getdate()),doj),GETDATE()) as ExperienceDay
from programmer
---3. Display the Names of those who have done the DAP Course. 
select 
pname,institute,course
from studies where course = 'dap'

---4. Display the Names and Date of Births of all Programmers Born in January. 

select 
pname,doj
from programmer
where month(doj) = 1


---5. What is the Highest Number of copies sold by a Package? 

select max(sold) as max_sold
from software


---6. Display lowest course Fee. 

select min(coursefee)as min_fee from studies


---7. How many programmers done the PGDCA Course? 

select count(a.course) as count_course
from studies a
join programmer b
on a.pname = b.pname
where a.course = 'pgdca'

select count(pname) from studies
where course like 'pgdca'

---8. How much revenue has been earned thru sales of Packages Developed in C. 
select sum(sold * scost) as Revenue_earned
from software
where developin = 'c'


---9. Display the Details of the Software Developed by Ramesh. 
select pname,developin 
from software
where pname = 'ramesh'


---10. How many Programmers Studied at Sabhari? 

select count(pname) 
from studies
where institute = 'sabhari'


---11. Display details of Packages whose sales crossed the 2000 Mark. 
select * from software
where (sold*scost) >2000

---12. Display the Details of Packages for which Development Cost have been recovered. 
select * from software
where (scost*sold) > dcost

---13. What is the cost of the costliest software development in Basic?
select max(dcost) as costliest_soft from software

---14. How many Packages Developed in DBASE?
select count(developin) from software
where developin = 'dbase'


---15. How many programmers studied in Pragathi? 

select 
count(pname)
from studies
where institute = 'pragathi'

--16. How many Programmers Paid 5000 to 10000 for their course? 

select count(pname) as no_programmer
from studies
where coursefee between 500 and 10000


--17. What is AVG Course Fee 
select avg(coursefee)as Avg_course from studies

---18. Display the details of the Programmers Knowing C. 
select * from programmer
where prof1 = 'c' or prof2 = 'c'

---19. How many Programmers know either COBOL or PASCAL.

select * from programmer
where prof1 in ('cobol','pascal') or prof2 in ('cobol','pascal')

---20. How many Programmers Don’t know PASCAL and C 

select * from programmer
where prof1 not in ('pascal','c') and prof2 not in ('pascal','c')


select * from programmer
select * from software
select * from studies

--21. How old is the Oldest Male Programmer. 
--22. What is the AVG age of Female Programmers? 
--23. Calculate the Experience in Years for each Programmer and Display with their names in Descending order. 
--24. Who are the Programmers who celebrate their Birthday’s During the Current Month? 
--25. How many Female Programmers are there? 
--26. What are the Languages studied by Male Programmers. 
--27. What is the AVG Salary? 
--28. How many people draw salary 2000 to 4000? 
--29. Display the details of those who don’t know Clipper, COBOL or PASCAL. 
--30. Display the Cost of Package Developed By each Programmer. 
--31. Display the sales values of the Packages Developed by the each Programmer. 
--32. Display the Number of Packages sold by Each Programmer. 
--33. Display the sales cost of the packages Developed by each Programmer Language wise. 
--34. Display each language name with AVG Development Cost, AVG Selling Cost and AVG Price per Copy. 
--35. Display each programmer’s name, costliest and cheapest Packages Developed by him or her. 
--36. Display each institute name with number of Courses, Average Cost per Course. 
--37. Display each institute Name with Number of Students. 
--38. Display Names of Male and Female Programmers. Gender also. 
--39. Display the Name of Programmers and Their Packages. 
--40. Display the Number of Packages in Each Language Except C and C++. 
 



 



