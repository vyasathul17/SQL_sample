create database casestudy2;
use casestudy2;
go


-------Location table------------

create table location(location_id int not null primary key,city varchar(20) not null);

insert into location values 
(122,'New York'),
(123,'Dallas'),
(124,'Chicago'),
(167,'Boston');

select * from location

create table department(department_id int not null primary key,Name varchar(20) not null,
location_id int, foreign key(location_id) references location(location_id));


insert into department values
(10,'Accounting',122),
(20,'Sales',124),
(30,'Research',123),
(40,'Operations',167);



select * from department

create table job1(job_id int not null primary key,designation varchar(20));

insert into job1 values
(667,'Clerk'),
(668,'Staff'),
(669,'Analyst'),
(670,'Sales Person'),
(671,'Manager'),
(672,'President');

select * from job1
select * from department
select * from location


create table employee(employee_id int not null ,last_name varchar(20),
first_name varchar(20),middle_name varchar(20),job_id int,
foreign key(job_id) references job1(job_id),hire_date date,salary int not null,comm int null,
department_id int, foreign key (department_id) references department(department_id));

insert into employee values
(7369,'Smith','John','Q',667,'17-Dec-84',800,Null,20),
(7499,'Allen','Kevin','J',670,'20-feb-85',1600,300,30),
(755,'Doyle','Jean','K',671,'04-Apr-85',2850,Null,30),
(756,'Dennis','Lynn','S',671,'15-May-85',2750,Null,30),
(757,'Baker','Lesile','D',671,'10-Jun-85',2200,Null,40),
(7521,'Wark','Cynthia','D',670,'22-Feb-85',1250,50,30);


select * from employee
select * from job1
select * from department
select * from location


select first_name,last_name,salary,department_id from employee

select employee_id as Employee_ID,last_name as Name_of_the_Employee,
department_id as dep_id from employee

select last_name,middle_name,first_name,salary from employee

------where condition---------------

select * from employee where last_name = 'Smith' 
select * from employee where department_id = 20
select * from employee where salary between 2000 and 3000;
select * from employee where department_id = 10 or department_id = 20
select * from employee where department_id != 10 and department_id != 30
select * from employee where department_id not in (10,30);
select * from employee where first_name like 'L%';

SELECT * FROM (
    SELECT 
      CONCAT(first_name,' ',last_name) AS full_name,
      employee_id,
      job_id,
      hire_date,
      salary,
      comm,
      department_id
    FROM employee
) t
WHERE full_name LIKE 'L%e';

select * from (
select concat(first_name,' ',last_name)
as full_name,employee_id,job_id,hire_date,salary,comm,department_id from employee) t
where full_name like 'J%' and Len(full_name) = 4;

SELECT *
FROM (
  SELECT CONCAT(first_name,' ',last_name) AS full_name,
         employee_id,
         job_id,
         hire_date,
         salary,
         comm,
         department_id
  FROM employee
) t
WHERE full_name LIKE 'J%'
AND LEN(full_name) = 4;

select 
employee_id,first_name,job_id,hire_date,salary,comm,department_id 
from employee
where first_name like 'J%' and len(first_name) = 4;


select * from employee where department_id = 30 and salary > 2500;
select * from employee where comm is null;


----------------order by------------------------
select employee_id,last_name from employee 
order by employee_id asc;

select employee_id,last_name,salary from employee
order by salary desc;

select * from employee 
order by last_name asc;

select * from employee 
order by last_name asc, department_id desc;

-----------------Group by and Having clause ----------------------

select max(salary) as max_salary,
min(salary) as min_salary,
avg(salary) as Avg_salary,
department_id from employee
group by department_id

select 
max(a.salary) as max_salary,
min(a.salary) as min_salary,
avg(a.salary) as avg_salary,
b.designation
from employee a
join
job1 b
on a.job_id = b.job_id
group by designation;

select month(hire_date) as month, 
count(*) as number_employee from employee 
group by month(hire_date)
order by month asc;

select year(hire_date) as year,
month(hire_date) as month,
count(*) as number_employee
from employee
group by year(hire_date),month(hire_date)
order by year,month asc;

select department_id 
from employee
group by department_id
having
count(*) >= 4;

select month(hire_date) as month,
count(*) as no_employee
from employee
group by month(hire_date)
having month(hire_date) = 2;


SELECT COUNT(*) as no_employee FROM Employee
WHERE MONTH(Hire_Date) IN (5,6);

select year(hire_date) as year,
count(*) as no_employee
from employee
where year(hire_date) =1985
group by year(hire_date);

select
month(hire_date) as month,
count(*) as no_employee
from employee
where year(hire_date) = 1985
group by month(hire_date);

SELECT 
    YEAR(hire_date) AS year,
    MONTH(hire_date) AS month,
    COUNT(*) AS no_employee
FROM employee
WHERE YEAR(hire_date) = 1985
GROUP BY YEAR(hire_date), MONTH(hire_date)
ORDER BY month;

select 
count(*) as no_employee
from employee
where month(hire_date) = 4 and year(hire_date) = 1985;

select department_id from 
employee 
where year(hire_date) = 1985 and month(hire_date) = 4
group by department_id
having
count(*) >= 3;

--------------------Joins-----------------------------------------
select 
a.employee_id,
a.last_name,
a.middle_name,
a.first_name,
b.Name
from employee a
join department b
on a.department_id = b .department_id 

select a.*,b.designation
from employee a
join
job1 b
on a.job_id = b.job_id;


select a.first_name,
a.last_name,
b.Name,
c.city
from employee a
join department b 
on a.department_id = b.department_id
join location c 
on b.location_id = c.location_id

select 
count(*) as no_employees,
b.Name
from employee a 
join 
department b on 
a.department_id = b.department_id
group by b.Name;
 
------------2nd method----------------
select 
a.first_name,
a.last_name,
b.Name as department_name,
count(*) over(partition by a.department_id) as No_of_employee
from employee a
join department b 
on a.department_id = b.department_id

select 
count(*) as no_employee,
b.Name from employee a 
join department b
on a.department_id = b.department_id
where b.Name = 'Sales'
group by b.Name


---------2nd method----------
SELECT COUNT(*)
FROM Employee e
JOIN Department d ON e.Department_Id = d.Department_Id
WHERE d.Name = 'Sales';

select b.Name 
from employee a
join department b 
on a.department_id = b.department_id
group by b.Name
having count(*) >= 3
order by b.Name asc;

select 
count(*) as no_employee
from employee a
join department b
on a.department_id = b.department_id
join location c
on b.location_id = c.location_id
where c.city = 'Dallas'


select a.first_name,a.last_name,b.Name 
from employee a
join department b
on a.department_id = b.department_id
where b.Name = 'Sales' or b.Name = 'Operations'

---------------condition statement-------------------
select *,
case
when salary < 1500 then 'Grade C'
when salary between 1500 and 3000 then 'Grade B'
else 'Grade A'
END as Grade_category
from employee

select Grade ,count(*) as no_employees
from
(select 
case 
when salary > 1500 then 'Grade C'
when salary between 1500 and 3000 then 'Grade B'
else 'Grade A'
end as Grade
from employee)
t
group by Grade

select Grade,count(*) as no_employees
from
(select case 
when salary between 2000 and 5000 then 'MID RANGE SALARY'
end as Grade
from employee)
t
where Grade is not null
group by Grade

-----------------Subqueries--------------------

select * from employee
where salary = (select max(salary) from employee)

select a.first_name,
a.last_name,
b.Name from 
employee a 
join department b 
on a.department_id = b.department_id
where b.Name = 'Sales'

----2nd method-----

select * from employee
where department_id = 
(select department_id from department where Name = 'Sales')


select * from employee
where job_id = 
(select job_id from job1 
where designation = 'Clerk')

select * from employee
where department_id in 
(select department_id from department
where location_id = 
(select location_id from location
where city = 'Boston'))


select count(*) as no_employee 
from employee
where department_id = (select department_id from 
department where Name = 'Sales')

update employee set salary = 800
where job_id = 667

update employee 
set salary = (0.1 * salary + salary)
where job_id = (select job_id from job1
where designation = 'Clerk')

select * from employee 
where salary = 
(select max(salary) from employee 
where salary < (select max(salary) from employee))

select * from employee 
where salary = 
(select max(salary) from employee 
where department_id = 30);

select * from department d
where not exists 
(select 1 from employee e 
where e.department_id = d.department_id)

 select * from department d
 left join employee e
 on d.department_id = e.department_id
 where e.department_id is null;

select * from employee 
where salary > (select avg(salary) from employee)


select * from employee
select * from job1
select * from department
select * from location

