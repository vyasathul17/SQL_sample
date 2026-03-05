create database SalesPracticeDB;
go

use SalesPracticeDB;
go

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    JoinDate DATE
);

INSERT INTO Customers VALUES
(1, 'Arjun Menon', 'Kochi', '2022-01-15'),
(2, 'Meera Nair', 'Kannur', '2022-03-10'),
(3, 'Rahul Das', 'Calicut', '2022-05-20'),
(4, 'Anjali Ravi', 'Trivandrum', '2022-07-12'),
(5, 'Vikram Sharma', 'Chennai', '2022-08-25'),
(6, 'Sneha Iyer', 'Bangalore', '2023-01-05'),
(7, 'Kiran Kumar', 'Hyderabad', '2023-02-18'),
(8, 'Divya Pillai', 'Kochi', '2023-04-22');

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    OrderAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders VALUES
(101, 1, '2023-06-01', 15000),
(102, 2, '2023-06-05', 20000),
(103, 1, '2023-06-10', 10000),
(104, 3, '2023-06-15', 5000),
(105, 4, '2023-06-20', 25000),
(106, 5, '2023-06-25', 30000),
(107, 2, '2023-07-01', 15000),
(108, 6, '2023-07-05', 18000),
(109, 7, '2023-07-10', 22000),
(110, 8, '2023-07-15', 12000),
(111, 1, '2023-07-18', 8000),
(112, 5, '2023-07-22', 20000);




---Display Top 3 Customers by Single Order Amount

select Top 3 * from Orders
order by OrderAmount desc

---Display Top 5 Customers by Total Spending

select top 5 
a.CustomerName,
sum(b.OrderAmount) as Totalspend
from Customers a
join Orders b
on a.CustomerID = b.CustomerID
group by a.CustomerName
order by Totalspend desc;

-----Display Top N Customers (Dynamic)

Declare @TopN int = 3;

select Top(@TopN)
a.CustomerName,
sum(b.OrderAmount) as TotalSpend
from Customers a
join Orders b
on a.CustomerID = b.CustomerID
group by a.CustomerName
order by TotalSpend desc;

-----------------------------Using ROW_NUMBER()-----------------------------

with RankedCustomers as
(
select a.CustomerName,
sum(b.OrderAmount) as TotalSpend,
ROW_NUMBER() over(order by sum(b.OrderAmount)desc) as RankNo
from Customers a
join Orders b
on a.CustomerID = b.CustomerID
group by a.CustomerName)

select * from RankedCustomers
where RankNo <= 3

-------Using RANK() (Handles Ties)------

with Rankedcustomers as
(
select a.CustomerName,
sum(b.OrderAmount) as totalspend,
RANK()over(order by sum(b.OrderAmount)desc) as RankedPeople
from Customers a
join Orders b 
on a.CustomerID = b.CustomerID
group by a.CustomerName)

select * from Rankedcustomers
where RankedPeople >= 5

----Top 2 Customers Per City

with RankedCustomerswithCity as
(
select a.CustomerName,a.City,
sum(b.OrderAmount) as Totalspend,
ROW_NUMBER()over(partition by a.city order by sum(b.OrderAmount) desc) as Rankedbycity
from Customers a
join Orders b
on a.CustomerID = b.CustomerID
group by a.City,a.CustomerName)

select * from RankedCustomerswithCity
where Rankedbycity <= 2


select * from Customers
select * from Orders