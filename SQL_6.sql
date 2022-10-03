

----Write a query that returns all customers whose  first or last name is Thomas.  (don't use 'OR')

select * from sale.customer

select first_name, last_name
from sale.customer
where first_name='Thomas'
Union
select first_name, last_name
from sale.customer
where last_name='Thomas'


--------------------------


---Write a quary that returns all brands with products for both 2018 and 2020 model year.


SELECT Brand FROM sale.sales_summary

SELECT a.brand_name FROM product.brand a, product.product b
WHERE a.brand_id = b.brand_id and b.model_year = 2018
INTERSECT
SELECT a.brand_name FROM product.brand a, product.product b
WHERE a.brand_id = b.brand_id and b.model_year = 2020


----------------------------------------


------ Write a query that returns the first and the last names of the customers who placed orders in all of 2018, 2019, and 2020.


select A.first_name, A.last_name
from sale.customer A,sale.orders B
where A.customer_id=B.customer_id
and Year(B.order_date)=2018
INTERSECT
select A.first_name, A.last_name
from sale.customer A,sale.orders B
where A.customer_id=B.customer_id
and Year(B.order_date)=2019
INTERSECT
select A.first_name, A.last_name
from sale.customer A,sale.orders B
where A.customer_id=B.customer_id
and Year(B.order_date)=2020


SELECT	customer_id, first_name, last_name
FROM	sale.customer
WHERE	customer_id IN (
						SELECT	DISTINCT customer_id
						FROM	sale.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'
						INTERSECT
						SELECT	DISTINCT customer_id
						FROM	sale.orders
						WHERE	order_date BETWEEN '2019-01-01' AND '2019-12-31'
						INTERSECT
						SELECT	DISTINCT customer_id
						FROM	sale.orders
						WHERE	order_date BETWEEN '2020-01-01' AND '2020-12-31'


-----------------


-- Write a query that contains only products ordered in 2019 (Result not include products ordered in other years)

except
select a.product_id,a.product_name
from product.product A,sale.order_item B,sale.orders C
where A.product_id=B.product_id
and B.order_id=C.order_id
and YEAR(C.order_date)=2019
EXCEPT
select a.product_id,a.product_name
from product.product A,sale.order_item B,sale.orders C
where A.product_id=B.product_id
and B.order_id=C.order_id
and YEAR(C.order_date)<>2019


--------------------------------------------------------

SELECT	order_id, order_status,
		CASE order_status
			WHEN 1 THEN 'Pending'
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			ELSE 'Completed'
		END AS ord_status_mean
FROM	sale.orders


------------------
-- Create a new column that shows which email service provider ("Gmail", "Hotmail", "Yahoo" or "Other" ).

SELECT	first_name, last_name, email,
		CASE 
			WHEN email LIKE '%gmail.com' THEN 'Gmail'
			WHEN email LIKE '%yahoo.com' THEN 'Yahoo'
			WHEN email LIKE '%hotmail.com' THEN 'Hotmail'
			ELSE 'Other'
		END AS email_service_provider
FROM	sale.customer

---------------------


select * from sale.orders
select * from product.category



SELECT	first_name, last_name
		CASE 
			WHEN cat THEN 'Gmail'
			WHEN email LIKE '%yahoo.com' THEN 'Yahoo'
			WHEN email LIKE '%hotmail.com' THEN 'Hotmail'
			ELSE 'Other'
		END AS email_service_provider
SELECT*
FROM	sale.customer A, sale.orders B, product.category C,product.product D,sale.order_item E
where A.customer_id=B.customer_id
and C.category_id=D.category_id
and d.product_id=E.product_id
and B.order_id=E.order_id

------------------------

--Write a query that returns the count of the orders day by day in a pivot table format that has been shipped two days later.
SELECT	
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Sunday' THEN 1 ELSE 0 END ) AS Sunday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Monday' THEN 1 ELSE 0 END )AS Monday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Tuesday' THEN 1 ELSE 0 END )AS Tuesday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Wednesday' THEN 1 ELSE 0 END) AS Wednesday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Thursday' THEN 1 ELSE 0 END )AS Thursday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Friday' THEN 1 ELSE 0 END) AS Friday,
		SUM(CASE WHEN DATENAME(DW, order_date) = 'Saturday' THEN 1 ELSE 0 END )AS Saturday
FROM	sale.orders
WHERE	DATEDIFF (DAY, order_date, shipped_date) >2


--------------------


select distinct product_id,
SUM(quantity) over (Partition by product_id) Total_Quantity
from product.stock

-----------------


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id

---HER BÝR KAYDIN ÜRÜN SAYISI GELÝYOR.


SELECT	category_id, model_year,
		COUNT(*) OVER()	NOTHING
from product.product



-----3. satýr= brand_id ye göre grupla, oder by ile model_year da kümülaif iþlemler yaptýrýyor. brand_id 1 için 2018 de 13, 2019 de 8 ürün var. Ýlerledikçe toplaya toplaya gidiyor. 

SELECT	distinct brand_id, model_year
		,COUNT(*) OVER()	NOTHING
		,COUNT(*) OVER(PARTITION BY brand_id,model_year)
		,COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year)
from product.product

---- default oalrak windows frame= range ile kümülatif oluyor, row ile kümülatif ilerliyor.

SELECT	brand_id, model_year
		,COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year)
		,COUNT(*) OVER(PARTITION BY brand_id  ORDER BY model_year Range BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)-- default frame
		,COUNT(*) OVER(PARTITION BY brand_id  ORDER BY model_year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)-- satýr sayýsý
		,COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)-- toplam satýr sayýsý
from product.product


--------------her bir markaya göre satýr sayýsýný çarparken, kayýt sayýsýnný topla

SELECT	brand_id, model_year
		,COUNT(*) OVER(PARTITION BY brand_id range BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
from product.product


---------------------------


SELECT	brand_id, model_year,list_price
		,sum(list_price) OVER(PARTITION BY brand_id order by model_year range BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
from product.product

SELECT	brand_id, model_year,list_price
		,count(list_price) OVER(PARTITION BY brand_id order by model_year range BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
from product.product

--------------------


SELECT	brand_id, model_year,list_price
		,sum(list_price) OVER(PARTITION BY brand_id order by model_year range BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) as total, round ( list_price/sum(list_price) OVER(PARTITION BY brand_id order by model_year range BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING),2,1)*100 as oran
from product.product


----------------------- UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING olunca tüm verileri dahil et.


SELECT	brand_id, model_year
		,COUNT(*) OVER(PARTITION BY brand_id ORDER BY model_year ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
from product.product

-------------------

SELECT	distinct category_id
		,min(list_price) OVER(PARTITION BY category_id ORDER BY category_id  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
from product.product

SELECT	distinct category_id
		,min(list_price) OVER(PARTITION BY category_id ORDER BY category_id )
from product.product

---------------------How many different product in the product table?

SELECT distinct count(*) OVER() 
FROM product.product



------- What is the cheapest product price for each category?
SELECT	DISTINCT category_id,
		MIN (list_price) OVER (PARTITION BY category_id)
FROM	product.product

---MÝN MAX ÝÇÝN ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING GEREKSÝZ OLUYOR.

SELECT	distinct category_id
		,min(list_price) OVER(PARTITION BY category_id ORDER BY category_id  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as cheapest_price
from product.product


----------distinct windows functionda kullanýlmýyor.


SELECT distinct count(distinct product_id)
FROM	sale.order_item

SELECT distinct count(*) OVER() 
FROM product.product





-------
-- Write a query that returns how many products are in each order?

select * from sale.order_item



select distinct  order_id,
	sum (quantity) over (partition by order_id)
from sale.order_item

----How many different product are in each brand in each category?

select * from product.product

select  distinct category_id,brand_id,count(product_id) over (partition by category_id,brand_id)
from product.product




--------------------------------- Analytic Navigaiton Functions--------------------
--order by yazmak zorunlu


--Write a query that returns one of the most stocked product in each store.

---First_value 

select distinct store_id,
First_value(product_id) over (partition by store_id order by quantity DESC)
from product.stock

select * from product.stock
order by store_id, quantity DEsc


-------------

select *,
First_value(product_id) over (partition by store_id order by quantity DESC)
from product.stock


----------


SELECT *,
	FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC ROWS BETWEEN 1 PRECEDING AND CURRENT ROW )
FROM product.stock;

-----


	


SELECT *,
	FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC ROWS BETWEEN 1 PRECEDING AND CURRENT ROW )
FROM product.stock;




--Write a query that returns customers and their most valuable order with total amount of it.

SELECT	A.customer_id, first_name, last_name, B.order_id,
		SUM(quantity*list_price* (1-discount)) total_amount
FROM	sale.customer A, sale.orders B, sale.order_item C
WHERE	A.customer_id = B.customer_id
AND		B.order_id = C.order_id
GROUP BY
		A.customer_id, first_name, last_name, B.order_id
ORDER BY
		1,5 desc

WITH T1 AS
(
	SELECT	A.customer_id, first_name, last_name, B.order_id,
			SUM(quantity*list_price* (1-discount)) total_amount
	FROM	sale.customer A, sale.orders B, sale.order_item C
	WHERE	A.customer_id = B.customer_id
	AND		B.order_id = C.order_id
	GROUP BY
			A.customer_id, first_name, last_name, B.order_id
)
SELECT	DISTINCT customer_id, first_name, last_name,
		FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY total_amount DESC) most_val_order
		, FIRST_VALUE(total_amount) OVER (PARTITION BY customer_id ORDER BY total_amount DESC) total_amount
FROM	T1


---Write a query that returns first order date by month

select * from sale.orders

select Distinct YEAR(order_date),MONTH(order_date),
FIRST_VALUE(order_date) OVER (PARTITION BY YEAR(order_date),MONTH(order_date) ORDER BY YEAR(order_date)) first_order_date
from sale.orders


SELECT	DISTINCT YEAR(order_date) year,
		MONTH(order_date) month,
		FIRST_VALUE(order_date) OVER (PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date) first_ord_date
FROM	sale.orders




--Write a query that returns most stocked product in each store. (Use Last_Value)
SELECT	DISTINCT store_id,
		FIRST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity DESC),--RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		LAST_VALUE (product_id) OVER (PARTITION BY store_id ORDER BY quantity, product_id desc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	product.stock


--------------------------------------------------------------------------------------

--LAG / LEAD  Neye göre sýralandýðý önemli.


--Write a query that returns the order date of the one previous sale of each staff (use the LAG function)
SELECT	A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LAG(order_date) OVER (PARTITION BY A.staff_id ORDER BY order_id) prev_order_date
FROM	sale.staff A, sale.orders B
WHERE	A.staff_id = B.staff_id

--Write a query that returns the order date of the one next sale of each staff (use the lead function)
SELECT	A.staff_id, A.first_name, A.last_name, B.order_id, B.order_date,
		LEAD (order_date) OVER (PARTITION BY A.staff_id ORDER BY order_id) prev_order_date
FROM	sale.staff A, sale.orders B
WHERE	A.staff_id = B.staff_id


--- Row_Nuber() Rank() Dense_Rank()

--Row_Nuber() Rank() 

select category_id,list_price,
ROW_NUMBER()Over(Partition by category_id order by list_price) As RN,
Rank() Over ( Partition by category_id order by list_price) As RNK
from product.product

--Dense_rank Rank() 

select category_id,list_price,
ROW_NUMBER()Over(Partition by category_id order by list_price) As RN,
Rank() Over ( Partition by category_id order by list_price) As RNK,
Dense_Rank() Over ( Partition by category_id order by list_price) As DRNK
from product.product


--- Cume_Dist() Percent_Rank()   Ntile(N)


--Assign an ordinal number to the product prices for each category in ascending order

select category_id,list_price,
ROW_NUMBER()Over(Partition by category_id order by list_price) As ROW_Numbe
from product.product

select category_id,list_price,
ROW_NUMBER()Over(order by category_id) As ROW_Numbe
from product.product


--Write a query that returns both of the followings:
--Average product price.
--The average product price of orders.

 -- bu soruda ilk avg nin yanýna over yazýlmasýnýn sebebi her satýr için deðerin gelmesinin istenmesi
Select Distinct order_id,AVG(list_price) Over(),
avg(list_price) Over( Partition by order_id)
from sale.order_item 
