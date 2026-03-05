---Stored Procedure?
---A stored procedure is a prepared SQL code that you can save, so the code can be reused over and over again.
--Stored Procedure Syntax
--CREATE PROCEDURE procedure_name
--AS
--sql_statement
---GO;
---Execute a Stored Procedure
--EXEC procedure_name;

create database Banking_Management_system
use Banking_Management_system


-- Customer Table

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50)
);

INSERT INTO Customers (CustomerID, CustomerName, City)
VALUES
(1, 'Rahul Sharma', 'Delhi'),
(2, 'Priya Nair', 'Mumbai'),
(3, 'Arjun Menon', 'Bangalore'),
(4, 'Sneha Reddy', 'Hyderabad');

--Accounts Table

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    Balance DECIMAL(10,2),
    AccountType VARCHAR(20)
);

INSERT INTO Accounts (AccountID, CustomerID, Balance, AccountType)
VALUES
(101, 1, 50000, 'Savings'),
(102, 1, 25000, 'Current'),
(103, 2, 75000, 'Savings'),
(104, 3, 30000, 'Savings'),
(105, 4, 100000, 'Current');

--Transactions Table

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT,
    TransactionType VARCHAR(10), -- Deposit / Withdraw
    Amount DECIMAL(10,2),
    TransactionDate DATETIME DEFAULT GETDATE()
);


INSERT INTO Transactions (AccountID, TransactionType, Amount, TransactionDate)
VALUES
(101, 'Deposit', 50000, '2026-02-01'),
(102, 'Deposit', 25000, '2026-02-02'),
(103, 'Deposit', 75000, '2026-02-03'),
(104, 'Deposit', 30000, '2026-02-04'),
(105, 'Deposit', 100000, '2026-02-05'),

(101, 'Withdraw', 5000, '2026-02-10'),
(103, 'Withdraw', 10000, '2026-02-11'),
(104, 'Withdraw', 2000, '2026-02-12'),

(101, 'Deposit', 10000, '2026-02-15'),
(105, 'Withdraw', 15000, '2026-02-16');

select * from Customers
select * from Accounts
select * from Transactions

-- Procedure to View Account Balance
--Requirements:
--Input: @AccountID
--Return the current balance
--If account does not exist → return message

CREATE PROCEDURE usp_GetAccountBalance
@AccountID int

AS
BEGIN
SET NOCOUNT ON;

IF NOT EXISTS (SELECT 1 FROM Accounts WHERE AccountID = @AccountID)
BEGIN 
PRINT('INVALID ACCOUNT ID');
RETURN;
END

SELECT AccountID,Balance
from Accounts
where AccountID = @AccountID;
END;

EXEC usp_GetAccountBalance 101;

EXEC usp_GetAccountBalance 1111;

--usp_GetCustomerAccounts

CREATE PROCEDURE usp_GetCustomerAccount
@CustomerID INT

AS 
BEGIN
SET NOCOUNT ON;

IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID)
BEGIN
PRINT('INVALID CUSTOMERID');
RETURN;
END
SELECT CustomerID,CustomerName  
FROM Customers
WHERE CustomerID = @CustomerID
END


EXEC usp_GetCustomerAccount 1;


--Procedure to Show Transaction History
--Requirements:
--Input:
--@AccountID
--@StartDate
--@EndDate
--Return all transactions between dates
--Sort by TransactionDate DESC

CREATE PROCEDURE usp_GetTransactionHistory
@AccountID int,
@StartDate DATETIME,
@EndDate DATETIME

AS 
BEGIN
SET NOCOUNT ON;

SELECT * FROM 
Transactions 
WHERE AccountID = @AccountID
AND TransactionDate >= @StartDate
AND TransactionDate < DATEADD(DAY,1,@EndDate)
ORDER BY TransactionDate DESC;
END;

EXEC usp_GetTransactionHistory 101,'2026-02-06','2026-02-07';




CREATE PROCEDURE usp_CreateAccount
@CustomerID INT,
@AccountType VARCHAR(10),
@InitialDeposit DECIMAL(10,2)

AS
BEGIN
 SET NOCOUNT ON;
  
  BEGIN TRY

    IF @InitialDeposit < 1000
    BEGIN
     RAISERROR ('MINIMUM DEPOSIT IS 1000.',16,1)
     RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID)
     BEGIN
         RAISERROR ('INVALID CUSTOMER ID.',16,1)
         RETURN;
     END

     BEGIN TRANSACTION;
     DECLARE @NewAccountID INT;
     SELECT @NewAccountID = ISNULL(MAX(AccountID),0) + 1 from Accounts

     INSERT INTO Accounts(AccountID,CustomerID,Balance,AccountType)
     VALUES(@NewAccountID,@CustomerID,@InitialDeposit,@AccountType)

     INSERT INTO Transactions(AccountID,TransactionType,Amount)
     VALUES(@NewAccountID,'Deposit',@InitialDeposit)
     COMMIT TRANSACTION
     PRINT 'TRANSACTION SUCESSFULLY DONE'

   END TRY
   BEGIN CATCH
       ROLLBACK TRANSACTION;
       PRINT ERROR_MESSAGE();
   END CATCH
END

EXEC usp_CreateAccount 1,'Deposit',15000;


--Monthly Statement Generator
--Requirements:
---Input:
--@AccountID
--@Month
--@Year
--Show:
--Opening Balance
--Total Deposits
--Total Withdrawals
--Closing Balance

CREATE PROCEDURE usp_GenerateMonthlyStatement
@AccountID INT,
@Month INT,
@Year INT
AS
BEGIN

SET NOCOUNT ON;

DECLARE @OpeningBalance DECIMAL(10,2);
DECLARE @TotalDeposits DECIMAL(10,2);
DECLARE @TotalWithdrawals DECIMAL(10,2);

SELECT @OpeningBalance = ISNULL(SUM(CASE 
WHEN TransactionType = 'Deposit' THEN Amount
ELSE -Amount
END),0)
FROM Transactions
WHERE AccountID = @AccountID
AND TransactionDate < DATEFROMPARTS(@Year,@Month,1);

SELECT
@TotalDeposits = ISNULL(SUM(CASE WHEN TransactionType = 'Deposit' THEN Amount END),0),
@TotalWithdrawals = ISNULL(SUM(CASE WHEN TransactionType = 'Withdraw' THEN Amount END),0)
FROM Transactions
WHERE AccountID = @AccountID
AND MONTH(TransactionDate) = @Month
AND YEAR(TransactionDate)= @Year;

SELECT 
@OpeningBalance AS OpeningBalance, 
@TotalDeposits AS TotalDeposits, 
@TotalWithdrawals AS TotalWithdrawals, 
(@OpeningBalance + @TotalDeposits - @TotalWithdrawals) AS ClosingBalance; 
END;

select * from Customers
select * from Accounts
select * from Transactions