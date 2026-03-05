use casestudy2
go

------Simple Queries: --------

----List all the employee details. ----

select * from employee


----List all the department details.----

select * from department

----List all job details. ----
select * from job1

---List all the locations.---
select * from location


---List out the First Name, Last Name, Salary, Commission for all Employees. ---
select 
first_name,
last_name,
salary,comm  
from employee

--List out the Employee ID, Last Name, Department ID for all employees and alias Employee ID as "ID of the Employee", Last Name as "Name of the 
--Employee", Department ID as "Dep_id". ---

select 
employee_id as ID_of_the_Employee,
last_name as Name_of_the_Employee,
department_id as Dep_id 
from employee

---List out the annual salary of the employees with their names only---

select 
first_name,
middle_name,
last_name,
salary from employee

--WHERE Condition: ---

---List the details about "Smith"--
select * from 
employee 
where employee_id =  7369;

---List out the employees who are working in department 20.--- 
select * 
from employee
where department_id = 20;

--List out the employees who are earning salary between 2000 and 3000. ---
select * 
from employee
where salary between 2000 and 3000;

---List out the employees who are working in department 10 or 20.--- 
select * 
from employee
where department_id in (10,20);

select * 
from employee 
where department_id = 10 or department_id = 20;

--Find out the employees who are not working in department 10 or 30. --

select *
from employee 
where department_id 
not in (10 ,30);

--List out the employees whose name starts with 'L'--

select * 
from employee
where first_name like 'L%';



--List out the employees whose name starts with 'D' and ends with 'N' --

SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    employee_id,
    job_id,
    hire_date,
    salary,
    comm,
    department_id
FROM employee
WHERE CONCAT(first_name, ' ', last_name) LIKE 'D%n';


--List out the employees whose name length is 4 and start with 'J' --

select * from 
employee
where first_name like 'J%'
and 
len(first_name) = 4;


--List out the employees who are working in department 30 and draw the salaries more than 2500 --

select * 
from employee 
where department_id = 30 
and 
salary > 2500

--List out the employees who are not receiving commission--

select * 
from employee
where comm is Null

---ORDER BY Clause:---- 

-- List out the Employee ID and Last Name in ascending order based on the Employee ID.-- 

select 
employee_id,last_name
from employee
order by employee_id asc;


---List out the Employee ID and Name in descending order based on salary---
select 
employee_id,
first_name,
salary
from
employee
order by first_name desc

--List out the employee details according to their Last Name in ascending-order.-- 

select * 
from employee
order by last_name asc;

--List out the employee details according to their Last Name in ascending order and then Department ID in descending order.--

select *
from employee
order by
last_name asc ,
department_id desc

--GROUP BY and HAVING Clause: --
--List out the department wise maximum salary, minimum salary and average salary of the employees. --

select 
max(salary) as max_salary,
min(salary) as min_salary,
avg(salary) as avg_salary,
department_id
from employee
group by department_id

--List out the job wise maximum salary, minimum salary and average salary of the employees. 

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

--List out the number of employees who joined each month in ascending order. 

select 
month(hire_date) as month,
count(*) as num_employee
from employee
group by month(hire_date)
order by month(hire_date) asc;

--List out the number of employees for each month and year in ascending order based on the year and month. 
select
month(hire_date) as month,
year(hire_date) as year,
count(*) as num_employee
from 
employee
group by year(hire_date),month(hire_date)
order by year(hire_date),month(hire_date) asc


--List out the Department ID having at least four employees. --

select department_id
from employee
group by department_id
having count(*) >= 4;

--How many employees joined in February month. 

select count(*) as num_employee,
month(hire_date) as month
from employee
group by month(hire_date)
having month(hire_date) = 2;

--How many employees joined in May or June month. 
select count(*) as 
num_employee,
month(hire_date) as month
from employee
where month(hire_date) in (5,6)
group by month(hire_date)

--How many employees joined in 1985? 
select count(*) as num_employee,
year(hire_date) as year
from employee
where year(hire_date) = 1985
group by year(hire_date)

---How many employees joined each month in 1985? 

select count(*) as no_employee,
month(hire_date) as month
from employee
where year(hire_date)= 1985
group by month(hire_date)




--How many employees were joined in April 1985? 
select count(*) as no_employee
from employee
where year(hire_date) = 1985
group by month(hire_date)
having month(hire_date) = 4; 

--Which is the Department ID having greater than or equal to 3 employees joining in April 1985? 
select department_id
from employee
where year(hire_date) = 1985 and month(hire_date) = 4
group by department_id
having count(*) >= 3;


-------------------------------------Joins-------------------------------------------------------------- 
--List out employees with their department names. 

select 
a.first_name,
a.last_name,
a.salary,
a.hire_date,
b.Name
from employee a
join department b 
on a.department_id = b.department_id



---Display employees with their designations. 
select a.first_name,
a.last_name,
a.salary,
a.comm,
b.designation
from employee a 
join job1 b
on a.job_id = b.job_id;


--Display the employees with their department names and city. 
select a.first_name,
a.last_name,
a.salary,
a.comm,
b.Name,
c.city
from employee a
join department b 
on a.department_id = b.department_id
join location c 
on b.location_id = c.location_id

--How many employees are working in different departments? Display with department names. 
select
count(*) as no_employee,
b.Name
from employee a 
join department b
on a.department_id = b.department_id
group by b.Name

--How many employees are working in the sales department? 

select count(*) as no_employee,
b.Name
from employee a
join department b
on a.department_id = b.department_id
where b.Name = 'Sales'
group by b.Name;


--Which is the department having greater than or equal to 3 employees and display the department names in  ascending order.
select count(*) as no_employee,
b.Name
from employee a
join 
department b
on a.department_id = b.department_id
group by b.Name
having count(*) >= 3
order by b.Name asc;

--How many employees are working in 'Dallas'? 
select 
count(*) as no_employees,
c.city
from employee a
join department b
on a.department_id = b.department_id
join location c
on b.location_id = c.location_id
where c.city = 'Dallas'
group by c.city

--Display all employees in sales or operation departments.
select a.first_name,
a.last_name,b.Name
from employee a
join department b 
on a.department_id = b.department_id
where b.Name in ('Sales','Operations')

-------------------------------------------------------------------------CONDITIONAL STATEMENT---------------------------------------------------------------------- 
--Display the employee details with salary grades. Use conditional statement to create a grade column. 

select * ,
case 
when salary < 1500 then 'Grade C'
when salary between 1500 and 2500 then 'Grade B'
else 'Grade A'
End as Grade_category
from employee

--List out the number of employees grade wise. Use conditional statement to create a grade column. 

select
Grade,
count(*) as no_employee 
from(
select 
case 
when salary < 1500 then 'Grade C'
when salary between 1500 and 2500 then 'Grade B'
else 'Grade A'
end as Grade
from employee)t
group by Grade

--Display the employee salary grades and the number of employees between 2000 to 5000 range of salary.

select 
Grade, 
count(*) as no_employee
from (
select 
case
when salary between 2500 and 5000 then 'MID RANGE VALUE'
end as Grade
from employee)
t
where Grade is not null
group by Grade


----------------------------------------------------------------Subqueries------------------------------------------------------------------------ 
--Display the employees list who got the maximum salary. 

select 
* from 
employee
where salary = (
select max(salary) from employee)

--Display the employees who are working in the sales department. 

select * from 
employee
where department_id = (
select department_id from 
department 
where Name = 'Sales')

--Display the employees who are working as 'Clerk'. 

select *
from employee
where job_id = (
select job_id from 
job1 
where designation = 'Clerk')

--Display the list of employees who are living in 'Boston'. 

select *
from employee a
join department b
on a.department_id = b.department_id
join location c
on b.location_id = c.location_id
where c.location_id like 'Boston'

select * from 
employee 
where department_id = (
select department_id 
from department
where location_id = 
(select location_id
from location 
where city = 'Boston'))


--Find out the number of employees working in the sales department. 
select count(*) as no_employee
from employee
where department_id = 
(select department_id from 
department 
where Name = 'Sales'
)
group by department_id

--Update the salaries of employees who are working as clerks on the basis of 10%. 

update employee
set salary = (0.1 * salary + salary)
where job_id = (
select job_id from 
job1 
where designation = 'Clerk')

--Display the second highest salary drawing employee details. 

select * from 
employee where 
salary = (select max(salary) from
employee where salary < (
select max(salary) from employee))

--List out the employees who earn more than every employee in department 30. 

select * from 
employee where 
salary = (
select max(salary)
from employee
where department_id = 30)

 --Find out which department has no employees. 

 select * from department d
 where not exists
 (select 1 from employee e 
 where d.department_id = e.department_id)

 select * from department d
 left join employee e
 on d.department_id = e.department_id
 where e.department_id is null;

--Find out the employees who earn greater than the average salary for their department.

select * from 
employee 
where salary > (
select avg(salary) as avg_salary
from employee)

select * from employee
select * from job1
select * from location
select * from department





