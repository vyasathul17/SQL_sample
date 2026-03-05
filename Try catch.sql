create database BankingPracticeDB;
go
use BankingPracticeDB;
go

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(50),
    Email VARCHAR(100) UNIQUE
);

INSERT INTO Customers VALUES
(1,'Amit Sharma','Delhi','amit@gmail.com'),
(2,'Priya Nair','Mumbai','priya@gmail.com'),
(3,'Rahul Das','Chennai','rahul@gmail.com'),
(4,'Sneha Reddy','Hyderabad','sneha@gmail.com');



CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountType VARCHAR(20) CHECK (AccountType IN ('Savings','Current')),
    Balance DECIMAL(12,2) CHECK (Balance >= 0),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Accounts VALUES
(101,1,'Savings',50000),
(102,2,'Current',75000),
(103,3,'Savings',30000),
(104,4,'Current',100000);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionType VARCHAR(20) CHECK (TransactionType IN ('Deposit','Withdraw')),
    Amount DECIMAL(10,2) CHECK (Amount > 0),
    TransactionDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);


INSERT INTO Transactions VALUES
(1001,101,'Deposit',5000,GETDATE()),
(1002,102,'Withdraw',2000,GETDATE()),
(1003,103,'Deposit',10000,GETDATE()),
(1004,104,'Withdraw',5000,GETDATE());

-------------------------------------------TRY CATCH----------------------------
---Write TRY...CATCH to handle duplicate CustomerID.

begin try
insert into Customers values
(1,'Test user','pune','test@gamil.com');
end try
begin catch
print 'Error occur while iserting customer';
print Error_message()
end catch

---Balance has CHECK constraint Balance >= 0.
begin try
insert into Accounts values
(105,5,'current',-50000);
end try
begin catch
print 'Invalid balance amount';
print error_message();
end catch

-----Insert account with non-existing CustomerID.

begin try
insert into Accounts 
values (106,99,'savings',20000);
end try
begin catch
print 'customer does not exist';
print error_message()
end catch

---Divide by Zero

begin try
select 100/0;
end try
begin catch
print 'Error Number : ' + cast(error_number() as varchar);
print'Error Message: ' + error_message()
end catch

---GetAccountBalance Procedure

create procedure GetAccountBalance
@AccountID int

as
begin
begin try

if not exists(select 1 from Accounts where AccountID= @AccountID)
throw 50001,'Account does not exist',1;
select Balance from Accounts where AccountID = @AccountID;
end try
begin catch
print Error_message();
end catch
end

exec GetAccountBalance 999;

-----Transfer Amount (With Transaction)----

create procedure TransferAmount
@FromAccount int,
@ToAccount int,
@Amount decimal(12,2)
as
begin
begin Transaction;
 
begin try
if @Amount <= 0 
throw 50004,'Transfer amount must be positive,',1;

if not exists(select 1 from Accounts where AccountID = @FromAccount)
throw 50005,'source account not found',1;

if not exists(select 1 from Accounts where AccountID = @ToAccount)
throw 50006,'source account not found',1;

declare @Balance decimal(12,2);

select @Balance = Balance from Accounts
where AccountID = @FromAccount

if @Balance < @Amount
throw 50007,'insufficient balance',1

update Accounts
set Balance = Balance - @Amount
where AccountID = @FromAccount

update Accounts
set Balance = Balance + @Amount
where AccountID = @ToAccount

commit transaction;
print 'Transfer successful';

end try

begin catch
rollback Transaction
print 'Transfer Failed'
print Error_message();
end catch
end

CREATE PROCEDURE PerformTransaction
    @AccountID INT,
    @Type VARCHAR(20),
    @Amount DECIMAL(10,2)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY

        IF @Amount <= 0
            THROW 50020, 'Amount must be positive', 1;

        IF NOT EXISTS (SELECT 1 FROM Accounts WHERE AccountID = @AccountID)
            THROW 50021, 'Account not found', 1;

        IF @Type NOT IN ('Deposit','Withdraw')
            THROW 50022, 'Invalid transaction type', 1;

        DECLARE @Balance DECIMAL(10,2);
        SELECT @Balance = Balance FROM Accounts WHERE AccountID = @AccountID;

        IF @Type = 'Withdraw' AND @Balance < @Amount
            THROW 50023, 'Insufficient funds', 1;

        IF @Type = 'Deposit'
            UPDATE Accounts SET Balance = Balance + @Amount WHERE AccountID = @AccountID;

        IF @Type = 'Withdraw'
            UPDATE Accounts SET Balance = Balance - @Amount WHERE AccountID = @AccountID;

        INSERT INTO Transactions(AccountID,TransactionType,Amount)
        VALUES(@AccountID,@Type,@Amount);

        COMMIT;
        PRINT 'Transaction Successful';

    END TRY
    BEGIN CATCH
        ROLLBACK;
        INSERT INTO ErrorLog(ErrorMessage) VALUES(ERROR_MESSAGE());
        PRINT 'Transaction Failed';
        PRINT ERROR_MESSAGE();
    END CATCH
END

select * from Customers
select * from Accounts
select * from Transactions





---Withdraw More Than Balance (Logical Error) Create stored procedure with TRY...CATCH:

create procedure withdrawAmount
@AccountID int,
@Amount decimal(12,2)
as
begin

begin try
declare @Balance decimal (12,2)
select @Balance = Balance 
from Accounts
where AccountID = @AccountID

if @Amount > @Balance
throw 50001,'Insufficient Balance',1;

update Accounts
set Balance = Balance - @Amount
where AccountID = @AccountID;
print 'withdrawal successful';

end try
begin catch
print 'Transaction Failed'
print Error_message();
end catch
end

exec withdrawAmount 101,100000;



