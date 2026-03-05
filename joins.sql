CREATE DATABASE JOINS;
USE JOINS;
GO

CREATE TABLE SALESMAN1(salesma_id int not null unique,Name varchar(20),city varchar(20),commission decimal(3,2))

INSERT INTO SALESMAN1 VALUES
(5001,'James Hoog','New York',0.15),
(5002,'Nail Knite','Paris',0.13),
(5005,'Pit Alex','London',0.11),
(5006,'Mc Lyon','Paris',0.14),
(5007,'Paul Adam','Rome',0.13),
(5003,'Lauson Hen','San Jose',0.12);


CREATE TABLE CUSTOMER(customer_id int not null unique,cust_name varchar(20),city varchar(20),grade int,salesman_id int not null)

INSERT INTO CUSTOMER VALUES
(3002,'Nick Rimando','New York',100,5001),
(3007,'Brad Davis','New York',200,5001),
(3005,'Graham Zusi','California',200,5002),
(3008,'Julian Green','Landon',300,5002),
(3004,'Fabian Johnson','Paris',300,5006),
(3009,'Geoff Cameron','Berlin',100,5003),
(3003,'Jozy Altidor','Moscow',200,5007),
(3001,'Brad Guzan','London',100,5005);

SELECT * FROM CUSTOMER
SELECT * FROM SALESMAN1

SELECT CUSTOMER.cust_name,SALESMAN1.Name,SALESMAN1.city
FROM CUSTOMER,SALESMAN1
WHERE SALESMAN1.city = CUSTOMER.city


CREATE TABLE ORDERS(ord_no int not null,purch_amt decimal,ord_date date,customer_id int not null,salesman_id int not null)

INSERT INTO ORDERS VALUES
(70001,150.5,'2012-10-05',3005,5002),
(70009,270.65,'2012-09-10',3001,5005),
(70002,65.26,'2012-10-05',3002,5001),
(70004,110.5,'2012-08-17',3009,5003),
(70007,948.5,'2012-09-10',3005,5002),
(70005,2400.6,'2012-07-27',3007,5001),
(70008,5760,'2012-09-10',3002,5001),
(70010,1983.43,'2012-10-10',3004,5006),
(70003,2480.4,'2012-10-10',3009,5003),
(70012,270.65,'2012-09-10',3008,5002),
(70011,75.29,'2012-08-17',3003,5007),
(70013,3045.6,'2012-04-25',3002,5001);


SELECT * FROM CUSTOMER
SELECT * FROM ORDERS

SELECT a.ord_no,a.purch_amt,b.cust_name,b.city 
from ORDERS a,CUSTOMER b
WHERE a.customer_id = b.customer_id
AND a.purch_amt BETWEEN 500 AND 2000;

SELECT a.ord_no,a.purch_amt,b.cust_name,b.city
FROM ORDERS a
JOIN CUSTOMER b
ON a.customer_id = b.customer_id
AND a.purch_amt BETWEEN 500 AND 2000;


EXEC SP_RENAME 'SALESMAN1.sales_man','salesman_id','COLUMN';

SELECT a.cust_name AS 'Customer_Name',
a.city,
b.Name AS 'Salesman',
b.commission 
FROM 
CUSTOMER a
INNER JOIN SALESMAN1 b 
ON a.salesman_id = b.salesman_id;


SELECT * FROM CUSTOMER
SELECT * FROM SALESMAN1


SELECT a.cust_name as Customer_Name,
a.city as Customer_city,
b.Name as Salesman,
b.commission
FROM CUSTOMER a
INNER JOIN SALESMAN1 b
ON a.salesman_id = b.salesman_id
where commission > 0.12;


SELECT * FROM CUSTOMER
SELECT * FROM SALESMAN1

SELECT A.cust_name AS CUSTOMER_NAME,
A.city AS CUSTOMER_CITY,
B.Name AS Salesman,
B.city AS Salesman_city,
B.commission FROM CUSTOMER A
INNER JOIN SALESMAN1 B
ON A.salesman_id = B.salesman_id
WHERE B.commission > 0.12
AND A.city <> B.city;


