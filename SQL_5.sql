-----Session 7

--Pivot Table


--Question: Write a query using summary table that returns the total turnover from each category by model year. 
--(in pivot table format)


SELECT	Category, Model_Year ,SUM(total_sales_price) total_amount
FROM	sale.sales_summary
GROUP BY
		category, model_year
ORDER BY 1,2



SELECT *
FROM
(
SELECT	Category, Model_Year, total_sales_price
FROM	sale.sales_summary
) A
PIVOT
(
	SUM(total_sales_price)
	FOR model_year
	IN ([2018], [2019], [2020], [2021])
) as pvt_tbl



SELECT *
FROM
(
SELECT	Model_Year, total_sales_price
FROM	sale.sales_summary
) A
PIVOT
(
	SUM(total_sales_price)
	FOR model_year
	IN ([2018], [2019], [2020], [2021])
) as pvt_tbl



--Write a query that returns count of the orders day by day in a pivot table format that has been shipped two days later.




SELECT	order_id, DATENAME(DW, order_date) ORDER_WEEKDAY
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2




SELECT	DATENAME(DW, order_date) ORDER_WEEKDAY, COUNT (order_id)
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2
GROUP BY 
		DATENAME(DW, order_date) 



SELECT *
FROM
		(
		SELECT	order_id, DATENAME(DW, order_date) ORDER_WEEKDAY
		FROM	sale.orders
		WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2
		) A
PIVOT
(
	COUNT (order_id)
	FOR	ORDER_WEEKDAY
	IN ([Sunday], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday])
) AS PVT_TBL



------------////////////////

--////////////////////////

-------------///////////////////////////


----Subqueries

----Write a query that shows all employees in the store where Davis Thomas works.




SELECT	store_id
FROM	sale.staff
WHERE	first_name = 'Davis'
AND		last_name = 'Thomas'



SELECT *
FROM	sale.staff
WHERE	store_id = (SELECT	store_id
					FROM	sale.staff
					WHERE	first_name = 'Davis'
					AND		last_name = 'Thomas')



-- Write a query that shows the employees for whom Charles Cussona is a first-degree manager. 
--(To which employees are Charles Cussona a first-degree manager?)


select * from sale.staff

select * from sale.staff
where manager_id=2







SELECT	staff_id
FROM	sale.staff
WHERE	first_name = 'Charles'
AND		last_name = 'Cussona'


SELECT *
FROM	sale.staff
WHERE	manager_id = (SELECT	staff_id
						FROM	sale.staff
						WHERE	first_name = 'Charles'
						AND		last_name = 'Cussona')



-- Write a query that returns the customers located where ‘The BFLO Store' is located.
-- 'The BFLO Store' isimli maðazanýn bulunduðu þehirdeki müþterileri listeleyin.

SELECT	city
FROM	sale.store
WHERE	 store_name = 'The BFLO Store'


SELECT *
FROM	SALE.customer
WHERE	city = (SELECT	city
				FROM	sale.store
				WHERE	 store_name = 'The BFLO Store')


--Write a query that returns the list of products that are more expensive than the product named 
--'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'

select product_name 
from product.product
where list_price> (select list_price 
from product.product
where product_name='Pro-Series 49-Class Full HD Outdoor LED TV (Silver)')







SELECT *
FROM product.product
WHERE list_price > (SELECT list_price
					FROM product.product
					WHERE product_name LIKE 'Pro-Series%')


-- Write a query that returns customer first names, last names and order dates. 
-- The customers who are order on the same dates as Laurel Goldammer.


select * from sale.orders
where order_date = any (select order_date from sale.orders
where customer_id=(select customer_id from sale.customer 
where first_name='Laurel' and last_name='Goldammer'))






SELECT	b.first_name, b.last_name , a.order_date
FROM	sale.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND		A.order_date = ANY (
							SELECT	order_date
							FROM	SALE.orders A, sale.customer B
							WHERE	A.customer_id = B.customer_id
							AND		B.first_name = 'Laurel'
							and		B.last_name = 'Goldammer'
						)


						SELECT	order_date
FROM	SALE.orders A, sale.customer B
WHERE	A.customer_id = B.customer_id
AND		B.first_name = 'Laurel'
and		B.last_name = 'Goldammer'


--List the products that ordered in the last 10 orders in Buffalo city.


select TOP 10 order_id from sale.orders
where customer_id= any(select customer_id from sale.customer
where city= 'Buffalo')
ORDER BY 
		order_id DESC


			   

SELECT	TOP 10 order_id
FROM	sale.customer A, sale.orders B
WHERE	a.city= 'Buffalo'
AND		A.customer_id = B.customer_id
ORDER BY 
		order_id DESC


SELECT	DISTINCT A.order_id , B.product_name
FROM	sale.order_item A, product.product B
WHERE	order_id IN (
						SELECT	TOP 10 order_id
						FROM	sale.customer A, sale.orders B
						WHERE	a.city= 'Buffalo'
						AND		A.customer_id = B.customer_id
						ORDER BY 
								order_id DESC
						)
AND		A.product_id = B.product_id


--Write a query that returns the list of product names that were made in 2020
--and whose prices are higher than maximum product list price of Receivers Amplifiers category.




SELECT	list_price
FROM	product.product A, product.category B
WHERE	A.category_id = B.category_id
AND		b.category_name = 'Receivers Amplifiers'
ORDER BY 
		list_price DESC



SELECT *
FROM	product.product
WHERE	model_year = 2020
AND		list_price > ALL (
						SELECT	list_price
						FROM	product.product A, product.category B
						WHERE	A.category_id = B.category_id
						AND		b.category_name = 'Receivers Amplifiers'
						)
