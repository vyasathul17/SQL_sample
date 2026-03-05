create database SalesPivottables
go;
use SalesPivottables


CREATE TABLE SalesData (
    SaleID INT PRIMARY KEY,
    SalesPerson VARCHAR(50),
    Region VARCHAR(50),
    Product VARCHAR(50),
    SaleMonth VARCHAR(20),
    Amount INT
);

INSERT INTO SalesData VALUES
(1, 'Rahul', 'South', 'Laptop', 'Jan', 50000),
(2, 'Rahul', 'South', 'Mouse', 'Jan', 2000),
(3, 'Rahul', 'South', 'Laptop', 'Feb', 45000),
(4, 'Anita', 'North', 'Laptop', 'Jan', 52000),
(5, 'Anita', 'North', 'Mouse', 'Feb', 2500),
(6, 'Anita', 'North', 'Keyboard', 'Feb', 3000),
(7, 'Vikram', 'East', 'Laptop', 'Jan', 48000),
(8, 'Vikram', 'East', 'Keyboard', 'Mar', 3500),
(9, 'Rahul', 'South', 'Keyboard', 'Mar', 4000),
(10, 'Anita', 'North', 'Laptop', 'Mar', 53000),
(11, 'Vikram', 'East', 'Mouse', 'Feb', 2200),
(12, 'Rahul', 'South', 'Mouse', 'Mar', 1800);

select * from SalesData

------------------------------PIVOT TABLE-----------------------------
----Show total sales amount per SalesPerson for each Month.

select *
from (select SalesPerson,SaleMonth,Amount from SalesData)
as SourceTable
pivot
(sum(Amount)
for SaleMonth in ([Jan],[Feb],[Mar]))
as PivotTable;

----Show total sales of each Product by Region.

select * from
(select Region,Product,Amount from SalesData)
as sourcetable
pivot
(sum(Amount) for Product in ([Laptop],[Mouse],[Keyboard]))
as pivottable;

----Show total sales by SalesPerson only for Laptop sales, month-wise.

select * from
(select SalesPerson,SaleMonth,Amount from SalesData
where Product = 'Laptop')
as sourcetable
pivot
(sum(Amount) for SaleMonth in([Jan],[Feb],[Mar]))
as pivottable


----Count number of sales transactions per SalesPerson per Month.

select * from
(select SalesPerson,SaleMonth from SalesData)
sourcetable
pivot
(count(SaleMonth) for SaleMonth in ([Jan],[Feb],[Mar]))
as pivottable

---Show total sales per Region for each Month.
select * from 
(select Region,SaleMonth,Amount from SalesData)
as sourcetable
pivot
(sum(Amount) for SaleMonth in ([Jan],[Feb],[Mar]))
as pivottable

---Create dynamic pivot (months may change).If months are not fixed, you must use Dynamic SQL.

Declare @cols nvarchar(max),
@query nvarchar(max)

select @cols = STRING_AGG(QUOTENAME(SaleMonth),',')
from (select distinct SaleMonth from SalesData) as x;

set @query = 
'select * from 
(select SalesPerson,SaleMonth,Amount from  SalesData)
as sourcetable
pivot
(sum(Amount)
for SaleMonth in (' + @cols+ '))
as pivottable;';

exec sp_executesql @query;



CREATE TABLE EmployeePerformance (
    EmpID INT,
    EmpName VARCHAR(50),
    Department VARCHAR(50),
    ReviewYear INT,
    Quarter VARCHAR(5),
    Score INT
);

INSERT INTO EmployeePerformance VALUES
(1, 'Arjun', 'IT', 2023, 'Q1', 85),
(1, 'Arjun', 'IT', 2023, 'Q2', 90),
(1, 'Arjun', 'IT', 2023, 'Q3', 88),
(1, 'Arjun', 'IT', 2023, 'Q4', 92),

(2, 'Meera', 'HR', 2023, 'Q1', 78),
(2, 'Meera', 'HR', 2023, 'Q2', 82),
(2, 'Meera', 'HR', 2023, 'Q3', 80),
(2, 'Meera', 'HR', 2023, 'Q4', 85),

(3, 'Ravi', 'Finance', 2023, 'Q1', 88),
(3, 'Ravi', 'Finance', 2023, 'Q2', 91),
(3, 'Ravi', 'Finance', 2023, 'Q3', 87),
(3, 'Ravi', 'Finance', 2023, 'Q4', 90),

(4, 'Ananya', 'IT', 2023, 'Q1', 75),
(4, 'Ananya', 'IT', 2023, 'Q2', 80),
(4, 'Ananya', 'IT', 2023, 'Q3', 82),
(4, 'Ananya', 'IT', 2023, 'Q4', 84);

select * from EmployeePerformance

----Show each employee’s quarterly scores in separate columns

select * from
(select EmpName,Score,Quarter from EmployeePerformance)
as sourcetable
pivot
(sum(Score) for Quarter IN ([Q1],[Q2],[Q3],[Q4]))
as pivottable;

---Show department-wise average quarterly score.

select * from 
(select Department,Quarter,Score from EmployeePerformance)
as sourcetable
pivot
(avg(Score) for Quarter in ([Q1],[Q2],[Q3],[Q4]))
as pivottable


---Show number of employees reviewed per department in each quarter.
select * from 
(select EmpID,Department,Quarter from EmployeePerformance)
as sourcetable
pivot
(count(EmpID) for Quarter in ([Q1],[Q2],[Q3],[Q4]))
as pivottable

---Show total yearly score of each employee broken down by quarter AND include total score column.

select *
,ISNULL([Q1],0) + ISNULL([Q2],0)+ISNULL([Q3],0)+ISNULL([Q4],0) as Total
from
(select EmpName,Quarter,Score from EmployeePerformance)
as sourcetable
pivot
(sum(Score) for Quarter in ([Q1],[Q2],[Q3],[Q4]))
as pivottable

----Find employees whose Q4 score is greater than Q1 score.

select * from 
(select EmpName,Quarter,Score from EmployeePerformance)
as soursetable
pivot
(sum(Score) for Quarter in ([Q1],[Q2],[Q3],[Q4]))
as pivottable
where [Q4] > [Q1];

---Show only IT department employees with quarterly scores in columns.
select * from
(select EmpName,Department,Score,Quarter from EmployeePerformance
where Department = 'IT')
as sourcetable
pivot
(sum(Score) for Quarter in ([Q1],[Q2],[Q3],[Q4]))
as pivottable

---If new quarter like Q5 comes → hardcoded pivot fails.

declare @cols_1 nvarchar(max),
@query_1 nvarchar(max)

select @cols_1 = STRING_AGG(QUOTENAME(Quarter),',')
from (select distinct Quarter from EmployeePerformance) as x;

set @query_1 = 
'select * from 
(select EmpName,Quarter,Score from EmployeePerformance)
as sourcetable
pivot
(sum(Score) for Quarter in (' + @cols_1+ '))
as pivottable;';

exec sp_executesql @query_1;




select * from EmployeePerformance