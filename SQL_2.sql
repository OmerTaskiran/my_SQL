--SQL Server Built-in Functions


--Date formats



CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

select * from t_date_time


SELECT GETDATE() AS TIME


INSERT t_date_time 
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())


select * from t_date_time


INSERT t_date_time 
VALUES ('12:20:00', '2022-09-17','2022-09-17', '2022-09-17', '2022-09-17', '2022-09-17')


-------------////////////////


---

SELECT DATENAME (DW, GETDATE())

SELECT DATEPART (SECOND, GETDATE())

SELECT DATEPART (MONTH, GETDATE())

SELECT DAY (GETDATE())

SELECT MONTH (GETDATE())

SELECT YEAR (GETDATE())


---

SELECT DATEDIFF(SECOND, '2021-12-21', GETDATE())


--ORDER TABLOSUNDAKİ ORDER DATE İLE SHIP DATE ARASINDAKİ GÜN FARKINI BULUNUZ.


SELECT	*, DATEDIFF(DAY , order_date, shipped_date) shipped_day
FROM	sale.orders

---dateadd
--eomonth

SELECT DATEADD(DAY, 3 , '2022-09-17')

SELECT DATEADD(DAY, -3 , '2022-09-17')

SELECT DATEADD(YEAR, -3 , '2022-09-17')


SELECT EOMONTH('2023-02-10')



SELECT ISDATE('2022-09-17')

SELECT ISDATE('20220917')

SELECT ISDATE('17-09-2022')


---sipariþ tarihinden iki gün sonra kargolanan sipariþleri döndüren bir sorgu yazýn


SELECT *, DATEDIFF(DAY , order_date, shipped_date) AS day_diff
FROM		sale.orders


SELECT *, DATEDIFF(DAY , order_date, shipped_date) AS day_diff
FROM		sale.orders
WHERE		DATEDIFF(DAY , order_date, shipped_date) > 2


--LEN, CHARINDEX, PATINDEX

SELECT LEN('Clarusway')

SELECT LEN('Clarusway  ')

SELECT LEN('  Clarusway  ')


---

SELECT CHARINDEX('C', 'Clarusway')

SELECT CHARINDEX('a', 'Clarusway')

SELECT CHARINDEX('a', 'Clarusway', 4)


SELECT PATINDEX('sw', 'Clarusway')

SELECT PATINDEX('%sw%', 'Clarusway')

SELECT PATINDEX('%r_sw%', 'Clarusway')


SELECT PATINDEX('___r_sw%', 'Clarusway')


--------LEFT, RIGHT, SUBSTRING

SELECT LEFT('Clarusway',3)

SELECT RIGHT('Clarusway',3)


SELECT SUBSTRING ('Clarusway', 3,2)

SELECT SUBSTRING ('Clarusway', 0,2)

SELECT SUBSTRING ('Clarusway', -1,2)

SELECT SUBSTRING ('Clarusway', -1,3)



-----------

--LOWER, UPPER, STRING_SPLIT 

SELECT LOWER ('CLARUSWAY'), UPPER ('clarusway')



SELECT	value
FROM	STRING_SPLIT('Ezgi/Senem/Mustafa', '/')



---clarusway kelimesinin sadece ilk harfini büyültün.


SELECT LEFT('clarusway',1)

SELECT SUBSTRING('clarusway', 2, LEN('clarusway'))

SELECT UPPER(LEFT('clarusway',1)) + LOWER (SUBSTRING('clarusway', 2, LEN('clarusway')))



SELECT	*, UPPER(LEFT(email,1)) + LOWER (SUBSTRING(email, 2, LEN(email))) New_email
FROM	sale.store


--TRIM, LTRIM, RTRIM

SELECT TRIM ('   CLARUSWAY   ')


SELECT TRIM ('?' FROM '?   CLARUSWAY   ?')

   CLARUSWAY   

SELECT TRIM ('?, ' FROM '?   CLARUSWAY   ?')

CLARUSWAY


SELECT LTRIM ('  CLARUSWAY   ')

CLARUSWAY   

SELECT RTRIM ('  CLARUSWAY   ')

  CLARUSWAY


-------

--REPLACE, STR

SELECT REPLACE('CLARUSWAY', 'C', 'A')


SELECT REPLACE('CLAR USWAY', ' ', '')


SELECT STR(1234.25, 7, 2)

SELECT STR(1234.25, 7, 1)



--CAST, CONVERT

SELECT CAST(123.56 AS VARCHAR(8))

SELECT CAST(123.56 AS INT)


SELECT CAST(123.56 AS NUMERIC(4,1))

--

SELECT CONVERT (NUMERIC(4,1) , 123.56)

SELECT GETDATE()

SELECT CONVERT (VARCHAR , GETDATE(), 6)


SELECT CONVERT (DATE, '19 Sep 22', 6)


--ROUND, ISNULL

SELECT ROUND (123.56, 1)

SELECT ROUND (123.54, 1)


SELECT ROUND (123.54, 1, 0)


SELECT ROUND (123.56, 1, 0)

SELECT ROUND (123.56, 1, 1)

SELECT ROUND (123.54, 1, 1)


--

SELECT ISNULL(NULL, 0)

SELECT ISNULL(1, 0)


SELECT ISNULL('NOTNULL', 0)


SELECT phone, ISNULL(phone, 0)
FROM sale.customer



--COALESCE, NULLIF, ISNUMERIC

SELECT COALESCE(NULL, NULL, 'ALÝ', NULL)

SELECT NULLIF(0, 0)



SELECT phone, ISNULL(phone, 0), NULLIF (ISNULL(phone, 0), '0')
FROM sale.customer


-------

SELECT ISNUMERIC(1)

SELECT ISNUMERIC('1')

SELECT ISNUMERIC('1,5')

SELECT ISNUMERIC('1.5')

SELECT ISNUMERIC('1ALÝ')




-----------

-- How many customers have yahoo mail?

SELECT COUNT (*) as cnt_cust
FROM sale.customer
WHERE email LIKE '%yahoo%'


SELECT	PATINDEX('%yahoo%', email)
FROM	sale.customer


SELECT	COUNT (PATINDEX('%yahoo%', email))
FROM	sale.customer
WHERE	PATINDEX('%yahoo%', email) > 0


SELECT	COUNT (*)
FROM	sale.customer
WHERE	PATINDEX('%yahoo%', email) > 0



--Write a query that returns the characters before the '@' character in the email column.




SELECT	email, LEFT (email, PATINDEX('%@%', email)-1) AS chars
FROM	sale.customer

SELECT	email, LEFT (email, CHARINDEX('@', email)-1) AS chars
FROM	sale.customer



---Add a new column to the customers table that contains the customers' contact information.
--If the phone is not null, the phone information will be printed, if not, the email information will be printed.


SELECT phone, email, COALESCE(phone, email, 'no contact') contact 
FROM	sale.customer
ORDER BY 3


--Write a query that returns streets. The third character of the streets is numerical.
--street sütununda soldan üçüncü karakterin rakam olduðu kayýtlarý getiriniz.

select * from sale.customer



SELECT	street, SUBSTRING(street, 3,1) third_char, ISNUMERIC (SUBSTRING(street, 3,1)) isnumerical
FROM	SALE.customer
WHERE	ISNUMERIC (SUBSTRING(street, 3,1)) = 1


SELECT	street
FROM	SALE.customer
WHERE	ISNUMERIC (SUBSTRING(street, 3,1)) = 1