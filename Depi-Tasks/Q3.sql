-- 1. Count the total number of products in the database
SELECT COUNT(*) AS total_products
FROM products;

-- 2. Find the average, minimum, and maximum price of all products
SELECT 
    AVG(price) AS avg_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM products;

-- 3. Count how many products are in each category
SELECT 
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY c.category_name;

-- 4. Find the total number of orders for each store
SELECT 
    s.store_name,
    COUNT(o.order_id) AS order_count
FROM stores s
LEFT JOIN orders o ON s.store_id = o.store_id
GROUP BY s.store_name
ORDER BY s.store_name;

-- 5. Show customer first names in UPPERCASE and last names in lowercase for the first 10 customers
SELECT 
    UPPER(first_name) AS first_name,
    LOWER(last_name) AS last_name
FROM customers
LIMIT 10;

-- 6. Get the length of each product name. Show product name and its length for the first 10 products
SELECT 
    product_name,
    LENGTH(product_name) AS name_length
FROM products
LIMIT 10;

-- 7. Format customer phone numbers to show only the area code (first 3 digits) for customers 1-15
SELECT 
    customer_id,
    SUBSTRING(phone_number, 1, 3) AS area_code
FROM customers
WHERE customer_id BETWEEN 1 AND 15;

-- 8. Show the current date and extract the year and month from order dates for orders 1-10
SELECT 
    CURRENT_DATE AS current_date,
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month
FROM orders
WHERE order_id BETWEEN 1 AND 10;

-- 9. Join products with their categories. Show product name and category name for first 10 products
SELECT 
    p.product_name,
    c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
LIMIT 10;

-- 10. Join customers with their orders. Show customer name and order date for first 10 orders
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
LIMIT 10;

-- 11. Show all products with their brand names, even if some products don't have brands
SELECT 
    p.product_name,
    COALESCE(b.brand_name, 'No Brand') AS brand_name
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id;

-- 12. Find products that cost more than the average product price
SELECT 
    product_name,
    price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price;

-- 13. Find customers who have placed at least one order using IN
SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name
FROM customers
WHERE customer_id IN (SELECT DISTINCT customer_id FROM orders);

-- 14. For each customer, show their name and total number of orders using subquery
SELECT 
    CONCAT(first_name, ' ', last_name) AS customer_name,
    (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id) AS order_count
FROM customers c;

-- 15. Create view easy_product_list and query products > $100
CREATE VIEW easy_product_list AS
SELECT 
    p.product_name,
    c.category_name,
    p.price
FROM products p
JOIN categories c ON p.category_id = c.category_id;

SELECT *
FROM easy_product_list
WHERE price > 100
ORDER BY price;

-- 16. Create view customer_info and find California customers
CREATE VIEW customer_info AS
SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    email,
    CONCAT(city, ', ', state) AS location
FROM customers;

SELECT *
FROM customer_info
WHERE location LIKE '%, CA';

-- 17. Find products that cost between $50 and $200
SELECT 
    product_name,
    price
FROM products
WHERE price BETWEEN 50 AND 200
ORDER BY price;

-- 18. Count how many customers live in each state
SELECT 
    state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY state
ORDER BY customer_count DESC;

-- 19. Find the most expensive product in each category
SELECT 
    c.category_name,
    p.product_name,
    p.price
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE (p.category_id, p.price) IN (
    SELECT category_id, MAX(price)
    FROM products
    GROUP BY category_id
);

-- 20. Show all stores and their cities, including total number of orders
SELECT 
    s.store_name,
    s.city,
    COUNT(o.order_id) AS order_count
FROM stores s
LEFT JOIN orders o ON s.store_id = o.store_id
GROUP BY s.store_name, s.city
ORDER BY s.store_name;