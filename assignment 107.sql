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


--21. How old is the Oldest Male Programmer.

select max(Age_year) as MaxAge
from
(select DATEDIFF(YEAR,dob,GETDATE())
- case 
when DATEADD(YEAR,DATEDIFF(year,dob,getdate()),dob) > GETDATE()
then 1 else 0 end as Age_year,
DATEDIFF(MONTH,dob,GETDATE()) % 12 as AgeMonth,
DATEDIFF(DAY,DATEADD(month,datediff(month,dob,getdate()),dob),getdate()) as Age_Day
from programmer
)t;

----or---
select max(
case 
when DATEADD(YEAR,DATEDIFF(YEAR,dob,GETDATE()),dob) >GETDATE()
then datediff(year,dob,getdate()) -1
else 
DATEDIFF(year,dob,getdate()) end  
) as  Age from programmer

--22. What is the AVG age of Female Programmers?

select AVG(
case
when DATEADD(YEAR,DATEDIFF(YEAR,dob,GETDATE()),dob) > GETDATE()
then DATEDIFF(YEAR,dob,GETDATE()) - 1
else
DATEDIFF(YEAR,dob,GETDATE())
end) as Avg_female_Age 
from programmer
where gender = 'f'

---or--- 

select AVG(Avg_Age)
from (
select DATEDIFF(YEAR,dob,GETDATE())
- case 
when DATEADD(YEAR,DATEDIFF(year,dob,getdate()),dob)>GETDATE()
then 1 else 0 end as Avg_Age,
DATEDIFF(MONTH,dob,GETDATE()) as Age_month,
DATEDIFF(DAY,DATEADD(month,DATEDIFF(month,dob,getdate()),dob),GETDATE()) as Age_day
from programmer
where gender like 'f'
)
t

--23. Calculate the Experience in Years for each Programmer and Display with their names in Descending order.

select *
,
DATEDIFF(YEAR,doj,GETDATE())
- case 
when DATEADD(YEAR,DATEDIFF(year,doj,getdate()),doj) > GETDATE() 
then 1 else 0 end as Experience,
DATEDIFF(MONTH,doj,GETDATE()) % 12 as Experience_Month,
DATEDIFF(DAY,DATEADD(Month,datediff(month,doj,getdate()),doj),getdate())
as Experience_Days
from programmer
order by pname desc


--24. Who are the Programmers who celebrate their Birthday’s During the Current Month?

select *,
case
when DATEADD(YEAR,DATEDIFF(YEAR,dob,GETDATE()),dob) >GETDATE()
then DATEDIFF(YEAR,dob,GETDATE()) - 1
else DATEDIFF(YEAR,dob,GETDATE()) end as Age
from 
programmer
where MONTH(dob) = '05'

--or--
select * ,
DATEDIFF(YEAR,dob,getdate())
- case 
when DATEADD(YEAR,DATEDIFF(year,dob,getdate()),dob)>getdate()
then 1 else 0
end as Age,
DATEDIFF(MONTH,dob,GETDATE()) % 12 as Age_Month,
DATEDIFF(DAY,DATEADD(Month,datediff(Month,dob,getdate()),dob),getdate())
as Age_day
from programmer 
where MONTH(dob)= '05'


--25. How many Female Programmers are there?

select count(pname) as Female_emp
from programmer
where gender like 'f'

--26. What are the Languages studied by Male Programmers. 
select pname,prof1,prof2
from programmer
where gender like 'm'

--27. What is the AVG Salary? 

select avg(salary) from programmer

--28. How many people draw salary 2000 to 4000? 
select count(pname) from programmer
where salary between 2000 and 4000

--29. Display the details of those who don’t know Clipper, COBOL or PASCAL. 

select * from programmer
where prof1 not in ('clipper','cobol','pascal') 
and prof2 not in ('clipper','cobol','pascal')

--30. Display the Cost of Package Developed By each Programmer. 
select pname,sum(dcost) as package_dcost from software
group by pname

--31. Display the sales values of the Packages Developed by the each Programmer.

select pname,sum(scost*sold) as sales_value from software
group by pname

--32. Display the Number of Packages sold by Each Programmer.

select pname,sum(sold) as no_package_sold from software
group by pname

--33. Display the sales cost of the packages Developed by each Programmer Language wise.

select developin,sum(scost) as sale_cost from software
group by developin

--34. Display each language name with AVG Development Cost, AVG Selling Cost and AVG Price per Copy. 

select developin,AVG(dcost) as Development_cost,AVG(scost) as Selling_cost,AVG(cast(sold as float)/scost) as Price_per_copy
from software
group by developin

--35. Display each programmer’s name, costliest and cheapest Packages Developed by him or her.
select pname,max(dcost) as costliest,min(dcost) as cheapest 
from software
group by pname 

--36. Display each institute name with number of Courses, Average Cost per Course.
select institute,count(course) as no_of_course,AVG(coursefee) as Avg_fee
from studies
group by institute

--37. Display each institute Name with Number of Students. 
select institute,count(pname) as no_students
from studies
group by institute

--38. Display Names of Male and Female Programmers. Gender also. 
select pname,gender
from programmer

--39. Display the Name of Programmers and Their Packages.

select pname,salary
from programmer

--40. Display the Number of Packages in Each Language Except C and C++. 

select developin as language,count(title) as no_packages
from software
group by developin
having developin != 'c' and developin != 'c++'

---41. Display the Number of Packages in Each Language for which Development Cost is less than 1000.

select developin,count(title) as no_package
from software
where dcost < 1000
group by developin

--42. Display AVG Difference between SCOST, DCOST for Each Package.
select title,AVG(scost) as Avg_scost,AVG(dcost) as Avg_dcost
from software
group by title

---43. Display the total SCOST, DCOST and amount to Be Recovered for each Programmer for Those Whose Cost has not yet been Recovered. 

select pname,sum(scost) as total_scost,sum(dcost) as total_dcost,sum(dcost - (sold*scost)) as Not_Recovered
from software
group by pname
having sum(dcost) > sum(sold*scost)

 ---44. Display Highest, Lowest and Average Salaries for those earning more than 2000. 

 select pname,max(salary) as max_salary,min(salary) as min_salary,
 AVG(salary) as avg_salary
 from programmer
 where salary >2000
 group by pname
 
 --45. Who is the Highest Paid C Programmers? 

 select * from programmer
 where salary = (select max(salary) as highest_paid from programmer where prof1 like 'c' or prof2 like'c');

 --46. Who is the Highest Paid Female COBOL Programmer? 

 select * from programmer
 where salary = (select max(salary) from programmer where (prof1 like 'cobol' or prof2 like 'cobol'))
 and gender = 'f'

 --47. Display the names of the highest paid programmers for each Language.

 with ctc as (
 select pname,salary,prof1 as Prof from programmer
 union
 select pname,salary,prof2 from programmer)
 select pname,salary,Prof
 from (select * ,
 RANK()over(partition by Prof order by salary desc) as rnk
 from ctc)
 t
 where rnk = 1

 --48. Who is the least experienced Programmer. 

 select pname,
 DATEDIFF(YEAR,doj,GETDATE())
 - case 
 when DATEADD(YEAR,DATEDIFF(year,doj,getdate()),doj) > GETDATE()
 then 1 else 0
 end as Experience,
 DATEDIFF(MONTH,doj,GETDATE()) % 12 as Exp_Month,
 DATEDIFF(DAY,DATEADD(month,datediff(month,doj,getdate()),doj),getdate()) as Exp_date
 from programmer
 order by Experience asc

 --49. Who is the most experienced male programmer knowing PASCAL.

 select pname,prof1,prof2,
 DATEDIFF(YEAR,doj,GETDATE())
 - case
 when DATEADD(YEAR,datediff(year,doj,getdate()),doj)>GETDATE()
 then 1 else 0
 end as Experience
 from programmer
 where gender like 'm'
 and (prof1 like 'pascal' or prof2 like 'pascal')
 order by Experience desc

 --50. Which Language is known by only one Programmer? 

 with CTE as (
 select prof1 as Language from programmer
 union all
 select prof2 from programmer)
 select Language from CTE
 group by Language
 having count(*) = 1;

 --51. Who is the Above Programmer Referred in 50? 

 create table PgLang(Prof varchar(20))
 select * from PgLang
 insert into PgLang
 select prof1 from programmer
 group by prof1 
 having prof1 not in (select prof2 from programmer)
 and count(prof1) = 1
 union
 select prof2 from programmer
 group by prof2 having 
 prof2 not in (select prof1 from programmer)
 and count(prof2) = 1

 select pname,prof
 from programmer
 inner join PgLang on 
 Prof = prof1 or prof = prof2

 --52. Who is the Youngest Programmer knowing DBASE? 
 select 
 pname,prof1,prof2,
 DATEDIFF(YEAR,dob,GETDATE())
 - case 
 when DATEADD(YEAR,DATEDIFF(year,dob,getdate()),dob) > GETDATE()
 then 1 else 0
 end as Age 
 from programmer where dob = (select max(dob) from programmer where prof1 = 'dbase' or prof2 = 'dbase')

 --53. Which Female Programmer earning more than 3000 does not know C, C++, ORACLE or DBASE?

 select pname,prof1,prof2,salary
 from programmer
 where salary > 3000
 and gender like 'f'
 and prof1 not in ('c','c++','oracle','dbase') 
 and prof2 not in ('c','c++','oracle','dbase')

 --54. Which Institute has most number of Students? 
 select top 1 institute,count(pname) as total_students
 from studies
 group by institute
 order by total_students desc;

 ---or --(using subquery)
 select institute,count(pname) as total_student
 from studies
 group by institute
 having count(pname) = 
 (select max(cnt)
 from (
 select count(pname) as cnt
 from studies
 group by institute)as t)

 --55. What is the Costliest course

 select top 1 course ,max(coursefee) as costliest
 from studies
 group by course
 order by costliest desc

---or---
select course from 
studies where coursefee = 
(select max(coursefee) from studies)

--56. Which course has been done by the most of the Students? 
select top 1 course ,count(pname) as total_std
from studies
group by course 
order by total_std desc

---or using subquery---

select course,count(pname) as total_student
from studies
group by course
having count(pname) = 
(select max(cnt) from 
(select count(pname) as cnt
from studies
group by course)as t)

--57. Which Institute conducts costliest course.
select institute,coursefee
from studies
where coursefee = 
(select max(coursefee) from studies)

--58. Display the name of the Institute and Course, which has below AVG course fee. 

select institute,course,coursefee
from studies
where coursefee < (select AVG(coursefee) from studies)

--59. Display the names of the courses whose fees are within 1000 (+ or -) of the Average Fee

select course
from studies
where coursefee < (select AVG(coursefee) + 1000 from studies) 
and coursefee > (select AVG(coursefee) - 1000 from studies)

--60. Which package has the Highest Development cost? 
select title,dcost from 
software
where dcost = (select max(dcost) from software)

--61. Which course has below AVG number of Students?

create table Average_student(Course varchar(20),count_no int)
insert into Average_student
select course,count(pname) from studies group by course
select Course,count_no from Average_student where count_no <= (select AVG(count_no) from Average_student)

--62. Which Package has the lowest selling cost? 

select top 1 title , min(scost) as min_cost from software
group by title
order by min_cost asc

--or--

select title,scost
from software
where scost = (select min(scost) from software)

--63. Who Developed the Package that has sold the least number of copies? 

select pname,sold
from software
where sold = (select min(sold) from software)

-----or---

select top 1 pname ,min(sold) as min_sold
from software
group by pname
order by min_sold asc

--64. Which language has used to develop the package, which has the highest sales amount? 

select top 1 developin,max(scost*sold) as highest_sales
from software
group by developin
order by highest_sales desc

---or--
select developin,(sold*scost)
from software
where (sold*scost) = (select max(sold*scost) from software)

--65. How many copies of package that has the least difference between development and selling cost where sold. 

select title,sold,(dcost-scost) as difference_cost
from software
where (dcost - scost) =
(select min(dcost-scost) from software)

---or---
select title,sold
from software
where title = (select title from software
where (dcost-scost) = (select min(dcost-scost) from software))

--66. Which is the costliest package developed in PASCAL.

select title
from software where dcost = (select max(dcost) from software where developin like 'pascal')

--67. Which language was used to develop the most number of Packages.

select top 1 developin,count(title) as no_packages
from software
group by developin
order by no_packages desc

---or---

select developin,count(title)
from software
group by developin
having count(title)=
(select max(pac) from
(select count(title) as pac
from software
group by developin) as t)

--68. Which programmer has developed the highest number of Packages? 

select pname,count(title) as no_packages
from software
group by pname
having count(title) = 
(select max(pack) from
(select count(title) as pack from software
group by pname) as t)

--or--

select top 1 pname,count(title) as no_package
from software
group by pname
order by no_package desc

--69. Who is the Author of the Costliest Package? 

select top 1 pname ,max(dcost) as costliest
from software
group by pname
order by costliest desc

--or--

select pname,dcost
from software
where dcost = (select max(dcost) from software)

--70. Display the names of the packages, which have sold less than the AVG number of copies. 

select title,sold
from software
where sold < (select AVG(sold) from software)

--71. Who are the authors of the Packages, which have recovered more than double the Development cost? 

select pname,dcost,(scost*sold) as Recovered
from software
where (scost*sold) > (2*dcost)

--72. Display the programmer Name and the cheapest packages developed by them in each language.

select pname,title
from software
where dcost in (select min(dcost) from software group by developin)

--73. Display the language used by each programmer to develop the Highest Selling and Lowest-selling package. 

select pname,developin from software where sold in (select max(sold) from software group by pname)
union
select pname,developin from software where sold in (select min(sold) from software group by pname)


--74. Who is the youngest male Programmer born in 1965? 

select pname,dob,
DATEDIFF(YEAR,dob,GETDATE())
- case 
when DATEADD(YEAR,DATEDIFF(year,dob,getdate()),dob) > GETDATE()
then 1 else 0 
end as Age,
DATEDIFF(MONTH,dob,GETDATE()) % 12 as MonthDay,
DATEDIFF(DAY,DATEADD(month,datediff(month,dob,getdate()),dob),getdate()) as Day_age
from programmer 
where dob = (select max(dob) from programmer where
gender = 'm' and year(dob) = 1965)

--75. Who is the oldest Female Programmer who joined in 1992? 

select pname,dob,doj,salary,
DATEDIFF(YEAR,dob,GETDATE())
- case
when DATEADD(YEAR,DATEDIFF(year,dob,getdate()),dob)>GETDATE()
then 1 else 0
end as Age,
DATEDIFF(MONTH,dob,GETDATE()) % 12 as MonthAge,
DATEDIFF(DAY,DATEADD(month,datediff(month,dob,getdate()),dob),getdate()) as Day_year
from programmer 
where dob = (select min(dob) from programmer where year(doj) = '1992' and gender ='f')

--76. In which year was the most number of Programmers born. 

select top 1 year(dob) as Year_dob,count(pname) as no_people
from programmer
group by YEAR(dob)
order by no_people desc

---or -- 
select YEAR(dob) as year_dob,count(pname) as pep
from programmer
group by YEAR(dob)
having count(pname) = (select max(no_people)
from (select count(pname)as no_people from programmer
group by YEAR(dob))
as t
)

--77. In which month did most number of programmers join? 

select top 1 MONTH(doj) as month_joined,count(pname) as no_pep
from programmer
group by MONTH(doj)
order by no_pep desc

---or---
select MONTH(doj) as Month_joined,count(pname) as pep
from programmer
group by MONTH(doj)
having COUNT(pname) = (select max(no_pepe) from (
select count(pname)as no_pepe
from programmer
group by MONTH(doj)) as t)

--78. In which language are most of the programmer’s proficient. 

create table proficiency (prof_lan varchar(20),no_peop int)
create table prof_count (PRC varchar(20),people_count int)

insert into proficiency
select prof1,count(pname) from programmer group by prof1 
union all
select prof2 ,count(pname) from programmer group by prof2
select * from proficiency

insert into prof_count
select prof_lan,sum(no_peop) from proficiency group by prof_lan
select * from prof_count

select PRC,people_count
from prof_count
where people_count = (select max(people_count) from prof_count)


---or--

select PR,sum(CNT) as total
from (
select prof1 as PR,count(*) CNT from programmer group by prof1
union all
select prof2,count(*) from programmer group by prof2) A
group by PR
having SUM(CNT) = (select max(total) from 
(select PR,sum(CNT) as total
from (select prof1 as PR,count(*) as CNT from programmer group by prof1
union all
select prof2 ,count(*) from programmer group by prof2)
B group by PR)
c)

---or---
select top 5 PR,count(*) as total
from (select prof1 as PR from programmer
union all
select prof2 from programmer) A
group by PR
order by total desc

--79. Who are the male programmers earning below the AVG salary of Female Programmers? 

select pname,salary
from programmer where gender like 'm' and salary < (select AVG(salary) from programmer where gender like 'f') 

--80. Who are the Female Programmers earning more than the Highest Paid male?

select pname,salary
from programmer
where gender = 'f'
and salary > (select max(salary) from programmer where gender like 'm')

--81. Which language has been stated as the proficiency by most of the Programmers? 

create table prof(PR varchar(20),pep int)
create table prof_cnt (PRC varchar(20),pep_total int)

insert into prof
select prof1,count(pname) from programmer group by prof1
union all
select prof2,count(pname) from programmer group by prof2
select * from prof

insert into prof_cnt 
select PR,sum(pep) from prof group by PR
select * from prof_cnt

select PRC,pep_total
from prof_cnt where pep_total = (select max(pep_total) from prof_cnt)

---or--
select top 4 PROF,count(*) as CNT
from ( select prof1 as PROF from programmer 
union all
select prof2 from programmer ) as t
group by PROF
order by CNT desc

---OR---
select PR, SUM(CNT) as total
from (select prof1 as PR ,count(*) as CNT from programmer group by prof1
union all
select prof2 ,count(*) from programmer group by prof2) A
group by PR 
having sum(CNT) = (select max(total) from 
(select PR,sum(CNT) as total from (select prof1 as PR,count(*) as CNT from programmer group by prof1
union all
select prof2, count(*) from programmer group by prof2) B group by PR)  C)

--82. Display the details of those who are drawing the same salary.

select * from programmer
where salary in 
(select salary from programmer
group by salary
having count(*) > 1)


--83. Display the details of the Software Developed by the Male Programmers Earning More than 3000/-

select a.*
from software a
inner join programmer b 
on a.pname = b.pname
where b.gender = 'm' and b.salary > 3000

--84. Display the details of the packages developed in Pascal by the Female Programmers.

select a.* from software a
inner join programmer b
on a.pname = b.pname
where b.gender = 'f' and a.developin ='pascal'

--85. Display the details of the Programmers who joined before 1990.

select * from programmer
where YEAR(doj) < '1990'

--86. Display the details of the Software Developed in C By female programmers of Pragathi.

select a.* from software a 
inner join programmer b
on a.pname = b.pname
inner join studies c
on b.pname = c.pname
where b.gender = 'f'
and c.institute = 'pragathi'

--87. Display the number of packages, No. of Copies Sold and sales value of each programmer institute wise.

select b.institute,count(a.title) as no_packages,count(a.sold) as no_copies_sold,sum(a.scost*a.sold) as Sales_value
from software a
inner join studies b
on a.pname = b.pname
group by b.institute

--88. Display the details of the software developed in DBASE by Male Programmers, who belong to the institute in which most number of Programmers studied.

select distinct sw.* from software sw
join programmer pg 
on sw.pname = pg.pname
join studies st 
on st.pname = sw.pname
where sw.developin = 'dbase'
and pg.gender = 'm'
and st.institute = (select top 1 institute
from studies group by institute
order by count(*) desc)

--89. Display the details of the software Developed by the male programmers Born before 1965 and female programmers born after 1975.

select sw.*,year(pg.dob) as Born from software sw
join programmer pg
on sw.pname = pg.pname
where (pg.gender = 'm'
and YEAR(pg.dob) < 1965)
or  (pg.gender = 'f' and 
YEAR(pg.dob)> 1975)

--90. Display the details of the software that has developed in the language which is neither the first nor the second proficiency of the programmers. 

select sw.* from software sw
join programmer pg
on sw.pname = pg.pname
where sw.developin <> pg.prof1 and sw.developin<>pg.prof2


--92. Display the names of the programmers who have not developed any packages.

select pname from programmer
where pname not in (select pname from software)

---93. What is the total cost of the Software developed by the programmers of Apple? 

select st.institute,sum(sw.dcost) as total_cost
from studies st 
join software sw
on st.pname = sw.pname
where st.institute = 'apple'
group by st.institute

--94. Who are the programmers who joined on the same day? 

select distinct a.pname,day(a.doj) as Day_doj from programmer a ,programmer b
where DAY(a.doj) = DAY(b.doj)
and a.pname <> b.pname
order by Day_doj desc

--95. Who are the programmers who have the same Prof2? 

select distinct a.pname,a.prof2 from programmer a, programmer b
where a.prof2 = b.prof2
and a.pname <> b.pname
order by prof2

--96. Display the total sales value of the software, institute wise.

select st.institute,sum(sw.sold*sw.scost) as total_sales
from software sw join
studies st on sw.pname = st.pname
group by institute


--97. In which institute does the person who developed the costliest package studied. 

select st.institute,sw.pname,sw.dcost
from software sw
join  studies st
on sw.pname = st.pname
where sw.dcost = (select max(dcost) from software )


--98. Which language listed in prof1, prof2 has not been used to develop any package.

select prof1 as prg_lan 
from programmer
where prof1 not in (select developin from software)
union
select prof2 from 
programmer
where prof2 not in (select developin from software)

---or---
select distinct lang
from (
select prof1 as lang from programmer
union all 
select prof2 from programmer) A
where lang not in (select developin from software)

--99. How much does the person who developed the highest selling package earn and what course did HE/SHE undergo.

select pg.salary,sw.sold,st.institute from programmer pg
join software sw 
on pg.pname = sw.pname
join studies st
 on st.pname = sw.pname
 where sw.sold = (select max(sold) from software)

 --100. What is the AVG salary for those whose software sales is more than 50,000/-.

select pg.pname,AVG(pg.salary) as Avg_salary
from programmer pg
join software sw
on pg.pname = sw.pname
group by pg.pname
having sum(sw.sold*sw.scost) > 50000

--101. How many packages were developed by students, who studied in institute that charge the lowest course fee? 

select sw.pname,count(sw.title) as no_packages 
from software sw 
join studies st 
on sw.pname = st.pname
where st.coursefee = (select min(coursefee) from studies)
group by sw.pname
order by no_packages desc

select sw.pname,count(sw.title) as no_packages
from software sw 
join studies st
on sw.pname = st.pname
group by sw.pname,st.institute
having min(st.coursefee) = (select min (coursefee) from studies)


--102. How many packages were developed by the person who developed the cheapest package, where did HE/SHE study? 

select sw.pname,st.institute, count(sw.sold) as no_packages 
from software sw 
join studies st
on sw.pname= st.pname
group by sw.pname,st.institute
having min(dcost) = (select min(dcost) from software)

--103. How many packages were developed by the female programmers earning more than the highest paid male programmer? 


select sw.pname,pg.salary,count(sw.title) as no_package
from software sw 
join programmer pg 
on sw.pname = pg.pname
where pg.gender = 'f'
and pg.salary > (select max(salary)
from programmer where gender = 'm')
group by sw.pname,pg.salary

--104. How many packages are developed by the most experienced programmer form BDPS.


select count(*) from software s,programmer p
where p.pname=s.pname group by doj having min(doj)=(select min(doj)
from studies st,programmer p, software s
where p.pname=s.pname and st.pname=p.pname and (institute='bdps'));

--105. List the programmers (form the software table) and the institutes they studied.

select distinct sw.pname,st.institute from software sw 
join studies st
on sw.pname = st.pname

--106. List each PROF with the number of Programmers having that PROF and the number of the packages in that PROF. 

select lang,count(distinct p.pname) as no_programmer,
count(title) as no_packages
from (
select pname,prof1 as lang from programmer
union all
select pname,prof2 from programmer)
p left join
software sw 
on p.lang = sw.developin
group by lang

--107. List the programmer names (from the programmer table) and No. Of Packages each has developed.

select pg.pname,count(sw.title) as no_packages
from programmer pg join
software sw on 
sw.pname = pg.pname
group by pg.pname

select * from programmer
select * from software
select * from studies




 
 

 

 


 
 


 
 
 
 

 

 





 
 




 








 




 





 



 

, 



 
 
 

 
 


 

 



 



