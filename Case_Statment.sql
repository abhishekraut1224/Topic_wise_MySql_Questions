create database Case_statment;
use Case_statment;
-- =========================================================================================================================================
CREATE TABLE employee_sales (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    sales INT
);

-- Sample Data
INSERT INTO employee_sales (emp_id, emp_name, sales) VALUES
(101, 'Amit Sharma', 5000),
(102, 'Priya Verma', 3000),
(103, 'Rajesh Gupta', 7000),
(104, 'Neha Iyer', 10000),
(105, 'Vikram Desai', 4000);

Select * from employee_sales;

-- Basic Questions
-- Q1: Classify employees based on their sales as "Low", "Medium", or "High".
select emp_id, emp_name, sales,
	case
		when sales < 5000 then "Low Sales"
		when sales < 7000 or sales = 7000 then "Medium sales"
		else "High sales"
	end as sales_category
from employee_sales;

-- Q2: Display "Bonus Eligible" or "Not Eligible" based on sales greater than 6000.
select emp_id, emp_name, sales,
	case
		when sales > 6000 then "Eligible for Bonus"
        else "Not Eligible For bonus"
	end Bonus_Eligibility
from employee_sales;

-- Q3: Display "Sales Above Average" or "Sales Below Average" based on individual sales compared to the average.
select emp_id, emp_name,sales,  avg(sales)
over() as avg_sale,
	case
		when sales > (select avg(sales) from employee_sales) then "Sales above average"
        else "Sales_below_avg"
	end as avg_performance
from employee_sales;

-- Q4: Show a discount percentage for employees based on their sales.
SELECT emp_id, emp_name, sales,
       CASE
           WHEN sales > 8000 THEN 15
           WHEN sales BETWEEN 5000 AND 8000 THEN 10
           ELSE 5
       END AS discount_percentage
FROM employee_sales;


-- Q5: Display "Sales Target Achieved" or "Sales Target Not Achieved" based on a target of 6000.
SELECT emp_id, emp_name, sales,
	case
		when sales > 6000 or sales = 6000 then "Sales Traget Achived"
		else "sales taraget is not achived"
	end	Traget
from employee_sales;

