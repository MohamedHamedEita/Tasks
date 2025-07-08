SELECT * 
FROM products 
WHERE list_price > 1000;

SELECT * 
FROM customers 
WHERE state IN ('CA', 'NY');

SELECT * 
FROM orders 
WHERE YEAR(order_date) = 2023;

SELECT * 
FROM customers 
WHERE email LIKE '%@gmail.com';

SELECT * 
FROM staff 
WHERE active = 0;

SELECT * 
FROM products 
ORDER BY list_price DESC 
LIMIT 5;

SELECT * 
FROM orders 
ORDER BY order_date DESC 
LIMIT 10;

SELECT * 
FROM customers 
ORDER BY last_name ASC 
LIMIT 3;

SELECT * 
FROM customers 
WHERE phone IS NULL OR phone = '';

SELECT * 
FROM staff 
WHERE manager_id IS NOT NULL;

SELECT category_id, COUNT(*) AS product_count
FROM products
GROUP BY category_id;

SELECT state, COUNT(*) AS customer_count
FROM customers
GROUP BY state;

SELECT brand_id, AVG(list_price) AS average_price
FROM products
GROUP BY brand_id;
SELECT staff_id, COUNT(*) AS order_count
FROM orders
GROUP BY staff_id;


SELECT * 
FROM products 
WHERE list_price BETWEEN 500 AND 1500;

SELECT * 
FROM customers 
WHERE city LIKE 'S%';

SELECT * 
FROM orders 
WHERE order_status IN (2, 4);

SELECT * 
FROM products 
WHERE category_id IN (1, 2, 3);

SELECT * 
FROM staff 
WHERE store_id = 1 OR phone IS NULL OR phone = '';
