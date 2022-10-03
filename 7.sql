

---Stored Procedures

Create Procedure sp_sapleproc1 As
Begin 
select 5*5

end

-- aþaðýdaki þekillerde çalýþtýrýlabiliyor.

execute sp_sapleproc1

exec sp_sapleproc1

sp_sapleproc1

-----------------------


Create or alter Procedure sp_sampleproc2 As
Begin 
print 'Clarusway'

end

--- bu þekilde print ile yapýnca mesaj gibi görüyor. Ayný procedre üzerine yazabiliyoruz. Bir öncekini siliyor.

exec sp_sampleproc2

-----------------------


CREATE TABLE ORDER_TBL
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);
INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 7, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 8, 'Johnson',GETDATE(), GETDATE()+5 )
CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);
SET NOCOUNT ON
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )


select * from ORDER_TBL


Create or alter Procedure sp_sampleproc3 As
Begin 
select count( ORDER_ID) AS CNT_ORDER from ORDER_TBL

end

EXEC sp_sampleproc3

insert ORDER_TBL values (9,9,'Adam', NULL, NULL)

EXEC sp_sampleproc3

------------------------------------------------

--PROCEDURE PARAMETERS

Create or alter Procedure sp_sampleproc4(@DAY DATE = '01-01-2022') 
As
begin
select count( ORDER_ID) AS CNT_ORDER 
from ORDER_TBL
where ORDER_DATE=@DAY
end

EXEC sp_sampleproc4

EXEC sp_sampleproc4 '2022-09-29'

-------------


Create or alter Procedure sp_sampleproc5 (@CUSTOMER VARCHAR(50) , @DAY DATE = '01-01-2022') 
As
begin
select count( ORDER_ID) AS CNT_ORDER 
from ORDER_TBL
where ORDER_DATE=@DAY
AND CUSTOMER_NAME=@CUSTOMER
end

EXEC sp_sampleproc5 'ADAM', '2022-10-01'

EXEC sp_sampleproc5 @CUSTOMER='ADAM', @DAY='2022-10-01'

----------------------------------------------------------

--QUERY PARAMETERS 

DECLARE @V1 INT
DECLARE @V2 INT
DECLARE @RESULT INT

SET @V1 =5
SET @V2 = 6
SET @RESULT =@V1 * @V2

SELECT @RESULT AS RESULT

--- PRÝNT @RESULT
-----------------------------------

.............


..........



..........




------------------------------



DECLARE @DAY DATE

SET @DAY='2022-09-28'

SELECT * 
FROM ORDER_TBL
WHERE ORDER_DATE=@DAY

-----------------------------------

---IF, ELSE IF, ELSE

DECLARE @CUSTOMER_ID INT=2


IF @CUSTOMER_ID=1
	PRINT 'CUSTOMER NAME IS ADAM'
ELSE IF @CUSTOMER_ID=2
	PRINT 'CUSTOMER NAME IS SMITH'
ELSE
	PRINT 'CUSTOMER NAME IS JOHN'

-----------------


--iki deðiþken tanýmlayýn
--1. deðiþken ikincisinden büyük ise iki deðiþkeni toplayýn
--2. deðiþken birincisinden büyük ise 2. deðiþkenden 1. deðiþkeni çýkarýn
--1. deðiþken 2. deðiþkene eþit ise iki deðiþkeni çarpýn


DECLARE @V1 INT = 5
DECLARE @V2 INT = 8
IF @V1 > @V2
	PRINT @V1 + @V2
ELSE IF @V1 < @V2
	PRINT @V2 - @V1
ELSE
	PRINT @V1 * @V2



	-----------


--istenilen tarihte verilen sipariþ sayýsý 5 ' ten küçükse 'lower than 5'
--5 ile 10 arasýndaysa sipariþ sayýsý (kaç ise sayý)
--10' dan büyük ise 'upper than 10' yazdýran bir sorgu yazýnýz.
DECLARE @DAY DATE
DECLARE @CNTORDER INT
SET @DAY = '2022-10-03'
SELECT	@CNTORDER = COUNT (ORDER_ID)
FROM	ORDER_TBL
WHERE	ORDER_DATE = @DAY
IF @CNTORDER < 2
	PRINT 'lower than 5'
ELSE IF @CNTORDER BETWEEN 2 AND 3
	SELECT @CNTORDER cnt_order
ELSE	PRINT 'upper than 10'


----------------------


---------------While

DECLARE @COUNTER INT=1

WHILE @COUNTER < 21
BEGIN

	PRINT @COUNTER 

	SET @COUNTER=@COUNTER + 1

END


SELECT * FROM ORDER_TBL

DECLARE @ID INT=10

WHILE @ID <21
BEGIN 

	INSERT ORDER_TBL VALUES (@ID,@ID,NULL, NULL,NULL)
	SET @ID += 1
END

------------------------



---FUNCTIONS

--SCALAR VALUED FUNCTIONS


--SCALAR VALUED FUNCTIONS
----
CREATE FUNCTION fn_upper_first_char()
RETURNS NVARCHAR(MAX)
AS
BEGIN
	RETURN UPPER (LEFT ('character', 1)) + LOWER (RIGHT ('character', len ('character')-1))
END

--------------------------


CREATE FUNCTION fn_upper_first_char2(@CHAR NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
	RETURN UPPER (LEFT (@CHAR, 1)) + LOWER(RIGHT (@CHAR, len(@CHAR)-1))
END



SELECT dbo.fn_upper_first_char2('UFUK')




SELECT *, dbo.fn_upper_first_char2(CUSTOMER_NAME) AS NEW_NAME
FROM ORDER_TBL


------------------------

--Table Valued Functions

--View den farklý deðiþken girebiliyoruz.

CCREATE FUNCTION fn_order_tbl()
RETURNS TABLE
AS
	RETURN	SELECT * 
			FROM ORDER_TBL 
			WHERE CUSTOMER_NAME = 'Adam'




SELECT *
FROM	dbo.fn_order_tbl()


CREATE FUNCTION fn_order_tbl_2 (@CUSTOMER_NAME NVARCHAR(MAX))
RETURNS TABLE
AS
	RETURN	SELECT * 
			FROM ORDER_TBL 
			WHERE CUSTOMER_NAME = @CUSTOMER_NAME



SELECT	ORDER_DATE
FROM	dbo.fn_order_tbl_2('Adam')


----------------------

CREATE FUNCTION fn_order_tbl_3 ()
RETURNS @tbl TABLE (ORDER_ID INT , ORDER_DATE DATE)
AS
BEGIN
		INSERT 	@tbl VALUES (1, '2022-10-03')

		RETURN
END


SELECT * 
FROM	dbo.fn_order_tbl_3 ()




-------------



DECLARE @TBL TABLE (ORDER_ID INT, ORDER_DATE DATE)

SELECT *
FROM @TBL


