use [Newcafe]

select * from [dbo].[SCHOOL_STUDENTS_DETAILS]

----------------------------------------------------------------------Triggers ----------------------------------------------------------------------------

--A trigger in SQL is a special database object that automatically executes a block of code in response to specific events on a table, such as INSERT, UPDATE, or DELETE. 
--Triggers are often used for auditing changes, enforcing complex business rules, or maintaining data integrity without requiring explicit application logic.

-- syntax

create Trigger trigger_name
on table_name
after insert,update,delete
as 
begin
-- trigger logic here
end;


CREATE TRIGGER TRIGGER_NAME
ON TABLE_NAME
AFTER
INSERT,
UPDATE,
DELETE
AS
BEGIN
-- TRIGGER LOGIC HERE
END;

 --Create a trigger to prevent deleting a table in a database.

CREATE TRIGGER TRR_PREVENT_TABLE_DELETION
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
PRINT 'DROPPIN TABLE IS NOT ALLOWED IN THIS DATA BASE'
END;

DROP TABLE [dbo].[SCHOOL_STUDENTS_DETAILS]

------------------------------------primary table------------------------------------------
CREATE TABLE Employee1
(  
    EmployeeID int NOT NULL,
    First_Name nvarchar(50) NOT NULL,
    Last_Name nvarchar(50) NOT NULL,
    Hire_date date,    
);

select * from Employee1

--------------------------------------------------log table ---------------------------------------------------------------------------

create table EmpLog1(
logID int identity(1,1) not null,
EmployeeID int not null,
First_Name varchar(50) not null,
Last_Name varchar(50) not null, 
Hire_date date not null,
operation varchar(50),
updated_on datetime,
updated_by varchar(50));

select * from Employee1
select * from EmpLog1


--Create a trigger that prevents deleting records from the Employee table and shows a message.
create trigger trg_Employee_delete
on Employee1
instead of delete
as 
begin 
print'Delete is not allowed on employee table'
end;



---creating trigger after insert ---

create trigger trgEnployeeInsert
on Employee1
for insert
as
insert into Emplog1(EmployeeID,
First_Name,	
Last_name,	
Hire_date,	
operation,	
updated_on,	
updated_by)

select EmployeeID,
First_Name,	
Last_name,	
Hire_date,
'INSERT',
getdate(),
suser_name()
from inserted;


INSERT INTO Employee1
VALUES(101, 'Neena','Kochhar','05-12-2018'),
(112, 'John','King','01-01-2015');

select *
from Emplog1
order by EmployeeID



------------------------------------SQL Trigger After DELETE--------------------------


INSERT INTO Employee1 VALUES (203, 'Catherine','Abel','07-21-2010'),
(411, 'Sam','Abolrous','03-12-2016');

create trigger trgEmployeeDelete
on Employee1
for delete
as
insert into Emplog1(EmployeeID,First_Name,Last_name,Hire_date,operation,updated_on,updated_by)
select EmployeeID,First_Name,Last_name,Hire_date,'DELETE',getdate(),SUSER_NAME()
from deleted;

delete from Employee1
where EmployeeID = 203;

select * from Employee1
select * from Emplog1



--------------------------------------SQL Trigger UPDATE-----------------------------

create trigger trgEmployeeUpdate11
on Employee1
for update
as
insert into Emplog1(
EmployeeID,
First_Name,
Last_name,
Hire_date,
operation,
updated_on,
updated_by)

select EmployeeID,First_Name,Last_name,Hire_date,'UPDATE',GETDATE(),SUSER_NAME()
from inserted;

update Employee1
set First_Name = 'Chiku'
where EmployeeID = 101;

UPDATE Employee1
SET Last_name = 'Adams'
WHERE EmployeeID = 101;




--- Create a trigger to audit the data in a table.

create table Emp
(
EmpID int primary key,
EmpName varchar(20),
salary decimal(10,2),
Hire_date date)

create table Emp_audit(
Audit_ID int identity(1,1) primary key,
EmpID Int,
EmpName varchar(20),
salary decimal(10,2),
Hire_date date,
operation varchar(20),
operated_by varchar(20),
operated_on varchar(20))


create trigger trgEmployeeAuditDetail1
on Emp_audit
after INSERT,DELETE,UPDATE
as 
begin
SET NOCOUNT ON;

----insert---
insert into Emp_audit(
EmpID,EmpName,salary,Hire_date,operation,operated_by,operated_on)

select 
i.EmpID,
i.EmpName,
i.salary,
i.Hire_date,
'INSERT',
SUSER_NAME(),
GETDATE()
from inserted i
where not exists(select 1 from deleted);

insert into Emp_audit(
EmpID,EmpName,salary,Hire_date,operation,operated_by,
operated_on)

select 
d.EmpID,
d.EmpName,
d.salary,
d.Hire_date,
'DELETE',
SUSER_NAME(),
GETDATE()
from deleted d
where not exists(select 1 from inserted);

insert into Emp_audit(
EmpID,EmpName,salary,Hire_date,operation,operated_by,operated_on)
select
i.EmpID,
i.EmpName,
i.salary,
i.Hire_date,
'UPDATE',
SUSER_NAME(),
GETDATE()
from inserted i 
inner join deleted d
on
d.EmpID = i.EmpID;
END;
go




CREATE TABLE Employee_
(  
    EmployeeID int NOT NULL primary key,
    First_Name nvarchar(50) NOT NULL,
    Last_Name nvarchar(50) NOT NULL,
    Hire_date date, salary decimal(10,2)    
);

insert into Employee_ values 
(101,'clara','kevin','2020-02-12',6700.00),
(102,'Manu','k','2020-03-01',3700.00),
(103,'Bell','clinton','2020-05-21',87700.00),
(104,'Bipin','Chandra','2020-06-05',61700.00),
(105,'Sekhar','Bandopadhya','2020-12-11',16700.00)

select * from Employee_

--Create a trigger that automatically updates LastModifiedDate whenever an employee record is updated.

alter table Employee_
add LastModifiedDate Datetime;

create trigger trg_ModifiedLastDate
on Employee_
after update
as 
begin
set nocount on;

update e
set LastModifiedDate = GETDATE()
from Employee_ e
inner join inserted i 
on e.EmployeeID = i.EmployeeID
end;


update Employee_
set salary = salary + 1000
where EmployeeID = 101



--Create an AFTER INSERT trigger on Employee that logs:

create table Employee_in
(EmployeeID INT NOT NULL PRIMARY KEY,
    First_Name NVARCHAR(50) NOT NULL,
    Last_Name NVARCHAR(50) NOT NULL,
    Hire_date DATE,
    Salary DECIMAL(10,2));

INSERT INTO Employee_in(EmployeeID, First_Name, Last_Name, Hire_date, Salary)
VALUES 
(111,'Clara','Kevin','2020-02-12',6700.00),
(112,'Manu','K','2020-03-01',3700.00),
(113,'Bell','Clinton','2020-05-21',87700.00),
(114,'Bipin','Chandra','2020-06-05',61700.00),
(115,'Sekhar','Bandopadhya','2020-12-11',16700.00);

create table Employee_Audit_table
(Audit_Id int identity(1,1) primary key,
EmployeeID int,
First_Name NVARCHAR(50),
Last_Name NVARCHAR(50),
Hire_date DATE,
Salary DECIMAL(10,2),
operation varchar(10),
operated_by nvarchar(50),
operated_on datetime);

create trigger trg_Insertlog
on Employee_in
after insert
as 
begin
set nocount on;

insert into Employee_Audit_table
(EmployeeID,First_Name,Last_Name,Hire_date,Salary,operation,operated_by,operated_on)
select 
i.EmployeeID,
i.First_Name,
i.Last_Name,
i.Hire_date,
i.Salary,
'INSERT',
SUSER_NAME(),
GETDATE()
from inserted i;
end;

update Employee_in
set salary = salary + 1000
where EmployeeID = 112

insert into Employee_in values(106,'Alice','John','2026-01-15',4500.00);

select * from Employee_Audit_table

---Create a trigger that prevents salary reduction during UPDATE.

create trigger trg_SalaryReduction
on Employee_in
after update
as 
begin
set nocount on ;
if exists(
select 1 from inserted i 
inner join deleted d 
on i.EmployeeID = d.EmployeeID
where i.salary < d.salary)
begin 
raiserror('salary reduction is not allowed', 16,1);
rollback transaction;
end
end;

update Employee_in
set salary = salary - 1000
where EmployeeID = 113;

--Allow updates only between 9 AM and 6 PM.If someone updates outside this time → rollback.

create trigger trg_allowupdate_officeHours
on Employee_in
after update
as
begin

declare @currenthours int = datepart(hour,getdate());

if(@currenthours <9 or @currenthours >=18)

begin
raiserror('update are allowed only between 9 am and 6 pm',16,1);
rollback transaction;
end
end;


--Create a UPDATE trigger that logs only if salary is changed (ignore other column updates).

create trigger trg_Salaryupdate
on Employee_in
after update
as
begin
set nocount on;
insert into Employee_Audit_table(
EmployeeID,First_Name,Last_Name,Hire_date,Salary,operation,operated_by,operated_on)
select
i.EmployeeID,
i.First_Name,
i.Last_Name,
i.Hire_date,
i.Salary as New_salary,
'UPDATE',
SUSER_NAME(),
GETDATE()
from inserted i 
inner join deleted d
on i.EmployeeID = d.EmployeeID
where i.Salary <> d.Salary;
end;

update Employee_in
set salary = 117500.00
where EmployeeID = 114

select * from Employee_Audit_table

--Create a trigger that correctly handles multiple row updates (no scalar variables).
--Create a DDL trigger to prevent TRUNCATE TABLE Employee.
--Create a trigger that logs:
--Table name
--Operation (ALTER, DROP)
--User
--Date
--whenever schema changes occur.

--Allow salary updates only if:User is HR_Admin Or salary increase ≤ 10%

--Instead of deleting a record:
--Update IsDeleted = 1
--Block physical DELETE
--👉 Use INSTEAD OF DELETE