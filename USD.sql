create database BankingSystemDB;
go
use BankingSystemDB;
go

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    City VARCHAR(50),
    CreatedDate DATETIME DEFAULT GETDATE()
);

INSERT INTO Customers VALUES
(1, 'Arjun', 'Menon', '1995-06-15', 'Kochi', DEFAULT),
(2, 'Meera', 'Nair', '1998-02-20', 'Kannur', DEFAULT),
(3, 'Rahul', 'Das', '1992-09-10', 'Calicut', DEFAULT),
(4, 'Anjali', 'Ravi', '2000-01-05', 'Trivandrum', DEFAULT),
(5, 'Vikram', 'Sharma', '1990-12-12', 'Chennai', DEFAULT);


CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountType VARCHAR(20),  -- Savings / Current
    Balance DECIMAL(12,2),
    OpenDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Accounts VALUES
(101, 1, 'Savings', 50000, '2023-01-01'),
(102, 2, 'Current', 75000, '2023-02-10'),
(103, 3, 'Savings', 20000, '2023-03-15'),
(104, 4, 'Savings', 90000, '2023-04-20'),
(105, 5, 'Current', 120000, '2023-05-05');

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionType VARCHAR(20), -- Deposit / Withdrawal
    Amount DECIMAL(10,2),
    TransactionDate DATETIME,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);


INSERT INTO Transactions VALUES
(1, 101, 'Deposit', 10000, '2023-06-01'),
(2, 101, 'Withdrawal', 5000, '2023-06-05'),
(3, 102, 'Deposit', 20000, '2023-06-10'),
(4, 103, 'Withdrawal', 2000, '2023-06-15'),
(5, 104, 'Deposit', 15000, '2023-06-20'),
(6, 105, 'Withdrawal', 10000, '2023-06-25'),
(7, 101, 'Deposit', 8000, '2023-07-01'),
(8, 102, 'Withdrawal', 5000, '2023-07-05'),
(9, 103, 'Deposit', 3000, '2023-07-10'),
(10, 104, 'Withdrawal', 4000, '2023-07-15');


--------------------------------------------Calculate Age from DOB (Scalar Function)----------------------------------------------------

--Input: DateOfBirth

--Output: Age


create function dbo.fn_calculateAge (@DOB date)
returns int
as 
begin
declare @Age int
set @Age = DATEDIFF(YEAR,@DOB,GETDATE())
- case 
when MONTH(@DOB) > MONTH(GETDATE())
or (MONTH(@DOB) = MONTH(GETDATE())
and DAY(@DOB) > DAY(GETDATE()))
then 1
else 0
end
return @Age
end;



select
FirstName,DateOfBirth,
dbo.fn_calculateAge(DateOfBirth) as Age
from Customers;

---------------------------------------------------------------------------Get Full Name--------------------------------------------------------------------------------------------------------------------------

--Combine FirstName + LastName

create function dbo.fn_GetFullName
(@FirstName varchar(50),
@LastName varchar(50))
returns varchar(101)
as
begin
return @FirstName + ' ' + @LastName
end;

select 
dbo.fn_GetFullName(FirstName,LastName) as FullName
from Customers



--------------------------------------------------------------------------Add 10% Bonus to Balance----------------------------------------------------------------------------------
--Add 10% Bonus to Balance

--Input: Balance

--Output: Updated Balance



create function dbo.fn_AddBonus (@Balance decimal(11,2))
returns decimal(11,2)
as
begin
return @Balance +(@Balance * 0.10)
end;

select 
AccountID,Balance,
dbo.fn_AddBonus(Balance) as BonusBalance
from Accounts


--INTERMEDIATE LEVEL UDF PRACTICE

--Total Balance of a Customer

--Input: CustomerID

--Output: SUM(Balance)



-------------------------------------------------------------------------Total Balance of a Customer-------------------------------------------------------------------

create function dbo.fn_TotalCustomerBalance(@customerID int)
returns decimal(12,2)
as
begin
declare @Total decimal(12,2)
select @Total = sum(Balance)
from Accounts
where CustomerID = @customerID

return isnull(@Total,0)
end;

select CustomerID,
dbo.fn_TotalCustomerBalance(CustomerID) as TotalBalance
from Customers

---------------------------------------------------------------------------Total Deposits for an Account--------------------------------------------------------------------------
--Total Deposits for an Account

--Input: AccountID

--Return: SUM(Deposit Amount)

create function dbo.fn_TotalDepositAccount (@AccountID int)
returns decimal(12,2)
as
begin
declare @Total decimal (12,2)

select @Total = sum(Amount)
from Transactions
where AccountID = @AccountID
and
TransactionType = 'Deposit'

return isnull(@Total,0)
end;

select AccountID,
dbo.fn_TotalDepositAccount (AccountID) as TotalDeposit

from Accounts

----------------------------------Check if Account is High Value---------------------------------------------------------------------

--If Balance > 80000 → Return 'High Value'

--Else → 'Normal


create function dbo.fn_AccountCategory(@Balance decimal(12,2))
returns varchar (50)
as
begin
declare @Category varchar(20)

if @Balance > 8000
set @Category = 'High Value'
else
set @Category = 'Normal'

return @category
end;


select AccountID,
Balance,
dbo.fn_AccountCategory(Balance) as AccountCategory
from Accounts;



----------------------------------TABLE VALUED FUNCTION PRACTICE-----------------------------
--Get All Transactions by AccountID (Return table)

create function dbo.fn_CreateTransactionByAccount(@AccountID int)
returns Table
as
return
(select 
TransactionID,TransactionType,Amount,TransactionDate
from Transactions
where AccountID = @AccountID);


select * from dbo.fn_CreateTransactionByAccount(101);

---Get All Accounts by City (Return table using JOIN) Multi-Statement Table-Valued Function (MSTVF)

create function dbo.fn_AllAccountsByCity (@city varchar(50))
returns @Result Table
(AccountID int,
customerName varchar(20),
AccountType varchar(20),
Balance decimal(12,2))
as
begin
insert into @Result
select 
a.AccountID,
b.FirstName+' '+b.LastName,
a.AccountType,
a.Balance
from Accounts a
inner join Customers b
on a.CustomerID = b.CustomerID
where b.City = @city
return
end;

select * from dbo.fn_AllAccountsByCity ('Kochi');

-----------------MEDIUM LEVEL LOGIC---------------
-----------------------------------------------------------------Monthly Statement Function-------------------------------------------------------------------

--Input:AccountID,Month,Year
--Return:Total Deposit,Total Withdrawal,Net Amount

-----------------------------------------------------------------Profit / Loss Function----------------------------------------------------------------------------
--Return:Total Deposit – Total Withdrawal

create function dbo.fn_MonthlyStatement
(
@AccountID INT,
@Month int,
@Year int)
returns @statement Table
(
TotalDeposit Decimal(12,2),
TotalWithdrawal Decimal(12,2),
NetAmount Decimal(12,2))

as
begin

declare @Deposit decimal(12,2)
declare @Withdrawal decimal(12,2)

select @Deposit = sum(Amount) from 
Transactions
where AccountID = @AccountID
and TransactionType = 'Deposit'
and month(TransactionDate) = @Month
and year(TransactionDate) = @Year


select @Withdrawal = sum(Amount) from 
Transactions where AccountID =@AccountID
and TransactionType = 'Withdrawal'
and month(TransactionDate) = @Month
and year(TransactionDate) = @year

insert into @statement
values(
ISNULL(@Deposit,0),
ISNULL(@Withdrawal,0),
ISNULL(@Deposit,0)- ISNULL(@Withdrawal,0))

return
end;

select * from dbo.fn_MonthlyStatement(101,6,2023);



select * from Transactions
select * from Accounts
select * from Customers

