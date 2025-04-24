create database groupby;
use groupby;

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    sale_date DATE,
    quantity INT,
    price DECIMAL(10, 2)
);

INSERT INTO Sales (sale_id, product_name, category, sale_date, quantity, price) VALUES
(1, 'Laptop', 'Electronics', '2023-01-15', 10, 1000.00),
(2, 'Smartphone', 'Electronics', '2023-02-20', 20, 500.00),
(3, 'Tablet', 'Electronics', '2023-03-10', 15, 300.00),
(4, 'Headphones', 'Accessories', '2023-01-25', 50, 50.00),
(5, 'Mouse', 'Accessories', '2023-02-15', 30, 25.00),
(6, 'Keyboard', 'Accessories', '2023-03-20', 25, 45.00),
(7, 'Chair', 'Furniture', '2023-01-30', 5, 150.00),
(8, 'Desk', 'Furniture', '2023-02-25', 3, 200.00),
(9, 'Monitor', 'Electronics', '2023-03-15', 12, 300.00),
(10, 'Webcam', 'Accessories', '2023-03-25', 20, 75.00),
(11, 'Printer', 'Electronics', '2023-01-10', 8, 120.00),
(12, 'Scanner', 'Electronics', '2023-02-28', 10, 100.00);


-- Basic questions 

-- Q1) Calculate the total quantity sold for each product.
SELECT 
    product_name, SUM(quantity)
FROM
    sales
GROUP BY product_name;

-- Q2) Find the total revenue for each category.
SELECT 
    category, SUM(quantity * price) AS total_revenue
FROM
    sales
GROUP BY category;

-- Q3) Get the average price of products in each category.
SELECT 
    category, AVG(price)
FROM
    sales
GROUP BY category;

-- Q4) Count the number of sales transactions for each product.
SELECT 
    product_name, COUNT(*) AS transactions_count
FROM
    sales
GROUP BY product_name;


-- Q5) Find the maximum price of products in each category.
SELECT 
    category, MAX(price)
FROM
    sales
GROUP BY category;

-- Q6) Retrieve the minimum quantity sold for each product.
SELECT 
    product_name, MIN(quantity) AS quantity_sold
FROM
    sales
GROUP BY product_name;


-- Q7) Calculate the total revenue for each month.
SELECT 
    MONTH(sale_date) AS sales_per_month,
    SUM(quantity * price) AS total_revenue
FROM
    sales
GROUP BY MONTH(sale_date); 

-- Q8) Get the average quantity sold per transaction for each category.
SELECT 
    category, AVG(quantity) AS average_quantity
FROM
    sales
GROUP BY category;

-- Q9) Find the total number of products sold in each category.
SELECT 
    category, SUM(quantity) AS total_number_of_products_sold
FROM
    sales
GROUP BY category;

-- Q10) Retrieve the highest and lowest revenue generated from each product.
SELECT 
    product_name,
    MIN(quantity * price) AS lowest_revenue_generated,
    MAX(quantity * price) AS highest_revenue_generated
FROM
    sales
GROUP BY product_name;

-- Q11) Calculate the total revenue generated for each product in each month.
SELECT 
    product_name,
    MONTH(sale_date) AS month_sale,
    SUM(quantity * price) AS total_revenue
FROM
    sales
GROUP BY product_name , month_sale;

-- 12) Get the average revenue per sale for each product.
SELECT 
    sale_id, product_name, AVG(quantity * price)
FROM
    sales
GROUP BY sale_id , product_name;

-- Q13) Find the number of distinct products sold in each category.
SELECT 
    COUNT(DISTINCT product_name) AS number_of_distinct_products,
    category
FROM
    sales
GROUP BY category;

-- Q14) Retrieve the total quantity sold and the total number of transactions for each category.
SELECT 
    category,
    SUM(quantity) AS total_quantity,
    COUNT(*) AS total_number_of_transations
FROM
    sales
GROUP BY category;

-- Q15) Calculate the percentage contribution of each product to the total revenue.
SELECT product_name, 
       (SUM(quantity * price) / (SELECT SUM(quantity * price) FROM Sales) * 100) AS revenue_percentage
FROM Sales
GROUP BY product_name;




