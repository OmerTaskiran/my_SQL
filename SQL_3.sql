------ LEFT JOIN ------

-- Write a query that returns products that have never been ordered
--Select product ID, product name, orderID

SELECT *
FROM product.product


SELECT * 
FROM sale.orders


SELECT * 
FROM sale.order_item

SELECT	A.product_id, B.order_id, B.product_id
FROM	product.product A
		LEFT JOIN
		sale.order_item B
		ON	A.product_id = B.product_id
WHERE	order_id IS NULL
ORDER BY B.product_id

SELECT	DISTINCT A.product_id, B.order_id, B.product_id
FROM	product.product A
		LEFT JOIN
		sale.order_item B
		ON	A.product_id = B.product_id
WHERE	order_id IS NULL
ORDER BY B.product_id




--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: Product_id, Product_name, Store_id, quantity


SELECT COUNT (DISTINCT product_id)
FROM product.stock
WHERE	product_id > 310




SELECT COUNT (DISTINCT product_id)
FROM product.product
WHERE	product_id > 310



SELECT	A.product_id, B.*
FROM	product.product A
		LEFT JOIN 
		product.stock B
		ON	A.product_id = B.product_id
WHERE	A.product_id > 310



--SELECT	A.product_id, B.*
--FROM	product.product A
--		LEFT JOIN 
--		product.stock B
--		ON	A.product_id = B.product_id
--WHERE	B.product_id > 310


------ RIGHT JOIN ------

--Report (AGAIN WITH RIGHT JOIN) the stock status of the products that product id greater than 310 in the stores.

select * from product.stock

select * from product.product

select A.*,B.*
from product.stock A
left join product.stock B
on A.product_id=B.product_id
where A.product_id>310





SELECT	A.product_id, B.*
FROM	product.stock A
		RIGHT JOIN 
		product.product B
		ON	A.product_id = B.product_id
WHERE	B.product_id > 310


--//////

---Report the orders information made by all staffs.
--Expected columns: Staff_id, first_name, last_name, all the information about orders


SELECT *
FROM	sale.staff



SELECT	COUNT (DISTINCT staff_id)
FROM	sale.orders


SELECT	A.staff_id, B.order_id
FROM	sale.staff A
		LEFT JOIN
		sale.orders B
		ON	A.staff_id = B.staff_id
ORDER BY 2


------ FULL OUTER JOIN ------

--Write a query that returns stock and order information together for all products . (TOP 100)
--Expected columns: Product_id, store_id, quantity, order_id, list_price

select * from product.stock

select * from sale.order_item

select * from sale.orders


SELECT COUNT (DISTINCT product_id)
FROM	product.product

SELECT COUNT (DISTINCT product_id)
FROM	product.stock

SELECT COUNT (DISTINCT product_id)
FROM	sale.order_item


SELECT	DISTINCT A.product_id, A.product_name, B.product_id, C.product_id
FROM	product.product A
		FULL OUTER JOIN 
		product.stock B
		ON	A.product_id = B.product_id
		FULL OUTER JOIN
		sale.order_item C
		ON A.product_id = C.product_id
ORDER BY B.product_id, C.product_id


------ CROSS JOIN ------

/*
In the stocks table, there are not all products held on the product table and you 
want to insert these products into the stock table.
You have to insert all these products for every three stores with “0” quantity.
Write a query to prepare this data.
*/

/*
1	443
2	443
3	443
1	444
2	444
3	444
*/

SELECT	DISTINCT A.store_id, B.product_id, 0 as quantity
FROM	product.stock A
		CROSS JOIN
		product.product B
WHERE	B.product_id NOT IN (SELECT product_id FROM product.stock)



----

------ SELF JOIN ------

--Write a query that returns the staffs with their managers.
--Expected columns: staff first name, staff last name, manager name

SELECT	A.*, B.staff_id, B.first_name, B.last_name
FROM	sale.staff A, sale.staff B
WHERE	A.manager_id = B.staff_id
 

SELECT	A.*, B.staff_id, B.first_name, B.last_name
FROM	sale.staff A
		LEFT JOIN 
		sale.staff B
		ON	A.manager_id = B.staff_id



------------------------

--VIEWS


CREATE VIEW v_sample_summary AS
SELECT	A.customer_id, COUNT(B.order_id) cnt_order
FROM	sale.customer A, SALE.orders B
WHERE	A.customer_id = B.customer_id
AND		A.city = 'Charleston'
GROUP BY A.customer_id


SELECT *
FROM	v_sample_summary



--Geçici tablo

SELECT	*
INTO	#v_sample_sum_2
FROM	v_sample_summary
