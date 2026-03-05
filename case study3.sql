use [Assignments]
go

-- Display the count of customers in each region who have done the transaction in the year 2020

SELECT
count(*) as Number_of_customers,
a.region_name 
from 
Continent a
join Customers b
on a.region_id = b.region_id
group by a.region_name

-- Display the maximum and minimum transaction amount of each transaction type
select
max(txn_amount) as max_tax_amount,
min(txn_amount) as min_tax_amount,
txn_type
from 
[dbo].[Transaction]
group by txn_type

--Display the customer id, region name and transaction amount where transaction type is deposit and transaction amount > 500
select 
a.region_name,
b.customer_id,
c.txn_amount,
c.txn_type
from 
Continent a
join Customers b
on a.region_id = b.region_id
join [dbo].[Transaction] c
on b.customer_id = c.customer_id
where c.txn_type = 'deposit'  and c.txn_amount > 500

--Find duplicate records in the Customer table

select 
customer_id,
count(*) as dup_cust
from 
Customers
group by customer_id
having count(*) >1;

select 
 region_id,
count(*) as dup_reg
from Customers
group by 
region_id
having 
count(*) > 1


select * 
from(
select*,count(*)
over(partition by customer_id,txn_type,txn_amount )
as cnt
from [dbo].[Transaction])
t

select * 
from (
select *,
ROW_NUMBER() 
over(partition by customer_id,txn_type,txn_amount
order by txn_type)
as cnt from [dbo].[Transaction])
t

select 
customer_id,
txn_amount,
txn_type,count(*) as cnt
from 
[dbo].[Transaction]
group by customer_id,txn_amount,txn_type
having count(*)>1;

select 
txn_type,count(*) as dup_count
from 
[dbo].[Transaction]
group by txn_type
having count(*) > 1

-- Display the customer id, region name, transaction type and transaction amount for the minimum transaction amount in deposit.

select 
a.region_name,
b.customer_id,
c.txn_type,
c.txn_amount
from 
Continent a
join Customers b
on a.region_id = b.region_id
join [dbo].[Transaction] c
on b.customer_id = c.customer_id
where c.txn_type = 'deposit'
and c.txn_amount = 
(select 
min(txn_amount) as min_txn
from [dbo].[Transaction]
where txn_type = 'deposit')

--Create a stored procedure to display details of customers in the Transaction table where the transaction date is greater than Jun 2020.

create procedure
usp_GetCustomersAfterJune2020
As
Begin
set nocount on;

select
a.region_name,
c.txn_type,
c.txn_amount,
c.txn_date
from Continent a
join Customers b
on a.region_id = b.region_id
join [dbo].[Transaction] c
on b.customer_id = c.customer_id
where c.txn_date > '2020-06-30';
End;

EXEC usp_GetCustomersAfterJune2020


--Create a stored procedure to insert a record in the Continent table.
create procedure
usp_newcontinent 
@region_id int,
@region_name varchar(50)
AS
Begin
set nocount on;
insert into Continent(region_id,region_name)
values(@region_id,@region_name);
End;

exec usp_newcontinent
@region_id = 1110,
@region_name = 'Asia';

--Create a stored procedure to display the details of transactions that happened on a specific day.

create procedure
usp_SpecificDayTransaction
@TxnDate Date
As
Begin
set nocount on;
select *
from  [dbo].[Transaction]
where txn_date >= @TxnDate
and txn_date < DATEADD(DAY,1,@TxnDate);
end;

exec usp_SpecificDayTransaction '2020-06-15'


--Create a user defined function to add 10% of the transaction amount in a table.

create function dbo.fnct_AddTenPercent
( @txn_amount decimal(10,2)
)
returns decimal(10,2)
as
begin
return @txn_amount + (@txn_amount * 0.10);
End;

select 
customer_id,
txn_date,
txn_type,
txn_amount,
dbo.fnct_AddTenPercent(txn_amount) as Amount_with_10percent
from [dbo].[Transaction]

--function syntax
-- create function schema_name.function_name
--(@parameter_name datatype,
-- @parameter_name datatype)
--returns return_datatype
-- as
--begin
--function body
--return value
--end;

--Create a user defined function to find the total transaction amount for a given transaction type.

CREATE FUNCTION dbo.total_transaction_amount
(@txn_type varchar(50)
)
returns int
as
begin
declare @total_amount int;
select @total_amount = sum(TRY_CAST(txn_amount as int))
from [dbo].[Transaction]
where txn_type = @txn_type
return @total_amount
end;

select * , 
dbo.total_transaction_amount(txn_type) as total_transaction_amount_type
from [dbo].[Transaction]

-- Create a table value function which comprises the columns customer_id, region_id ,txn_date , txn_type , txn_amount which will retrieve data from the above table.
create function dbo.TransactionTableDetails()
returns table
as
return
(select
customer_id,
txn_date,
txn_type,
txn_amount
from 
[dbo].[Transaction]);

select * from 
dbo.TransactionTableDetails()

--Create a TRY...CATCH block to print a region id and region name in a single column.

-- Try Catch

begin try
select cast(region_id as varchar(10)) + ' - ' + region_name as region_details
from Continent;
end try

begin catch
print 'An error occur while retrieving region details';
end catch;

 --Create a TRY...CATCH block to insert a value in the Continent table

 Begin Try
 insert into Continent values(6, 'Antartica');
 End Try

 Begin catch
 print 'An error occur while inserting a new value to the continent table'
 End catch

 --Create a trigger to prevent deleting a table in a database.

 create Trigger trg_PreventTableDelete
 on database
 for drop_table
 as
 begin
 print 'Dropping tables is not allowed in this database';
 rollback;
 end;

 drop table  [dbo].[Continent]

 ---Create a trigger to prevent login of the same user id in multiple pages.
  
  
--Display top n customers on the basis of transaction type.

DECLARE @N int = 10;

WITH RankedCustomers as 
(
select 
customer_id,
txn_type,
sum(CAST(txn_amount as int)) as Total_amount,
ROW_NUMBER()over(
partition by txn_type
order by sum(cast(txn_amount as int)) desc)
as rn
from 
[dbo].[Transaction]
group by customer_id,txn_type)

select
customer_id,
txn_type,
Total_amount
from RankedCustomers
where rn <= @N
order by txn_type,Total_amount desc;


SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Transaction';


--Create a pivot table to display the total purchase, withdrawal and deposit for all the customers.

select 
customer_id,
ISNULL([Purchase],0) as total_purchase,
ISNULL([Withdraw],0) as total_withdraw,
isnull([Deposit],0) as total_deposit
from
(select
customer_id,
txn_type,
txn_amount
from 
[dbo].[Transaction])
as sourcetable
pivot
(
sum(cast(txn_amount as int))
for txn_type in ([Purchase],[Withdraw],[Deposit])
as pivottable
order by customer_id;


SELECT 
    customer_id,
    ISNULL([Purchase], 0) AS total_purchase,
    ISNULL([Withdraw], 0) AS total_withdraw,
    ISNULL([Deposit], 0)  AS total_deposit
FROM
(
    SELECT
        customer_id,
        txn_type,
        txn_amount
    FROM [dbo].[Transaction]
) AS sourcetable
PIVOT
(
    SUM(CAST(txn_amount AS INT))
    FOR txn_type IN ([Purchase], [Withdraw], [Deposit])
) AS pivottable
ORDER BY customer_id;

EXEC sp_rename '[dbo].[Transaction]', 'Transactions';

SELECT 
    customer_id,
    ISNULL([Purchase], 0) AS total_purchase,
    ISNULL([Withdraw], 0) AS total_withdraw,
    ISNULL([Deposit], 0)  AS total_deposit
FROM
(
    SELECT
        customer_id,
        txn_type,
        txn_amount
    FROM dbo.Transactions
) AS sourcetable
PIVOT
(
    SUM(CAST(txn_amount AS INT))
    FOR txn_type IN ([Purchase], [Withdraw], [Deposit])
) AS pivottable
ORDER BY customer_id;


select *  from [dbo].[Continent]
select * from [dbo].[Customers]
select * from Transactions 