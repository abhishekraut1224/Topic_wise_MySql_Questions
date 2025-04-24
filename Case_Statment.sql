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

-- =============================================================
-- Intermediate Questions
/* 1)Task: Write a query that ranks employees based on sales and assigns them a bonus percentage using the following logic:
Top 2 employees by sales → '20% Bonus'
Next 2 employees → '10% Bonus'
The rest → '5% Bonus'*/ 

with Ranking As( 
select emp_id, emp_name, sales,
rank() over(
	order by sales desc) as ranking_by_sales
from employee_sales)

select *,
case
	when ranking_by_sales > 4 then '5% Bonus'
    when ranking_by_sales > 2 then '10% Bonus'
    else '20% Bonus'
end as Bonus_by_Ranking
from Ranking;


/* 2) Question: Sales Band Grouping & Summary
Task: Group employees into sales bands based on their sales figures and calculate:
The number of employees in each band
The total sales in each band

Sales Band Logic:
'Low Sales': Sales < 4000
'Moderate Sales': Sales between 4000 and 7000 (inclusive)
'High Sales': Sales > 7000 */

with Band as (
select emp_id, emp_name, sales,
CASE
    WHEN sales < 4000 THEN 'Low Sales'
    WHEN sales BETWEEN 4000 AND 7000 THEN 'Moderate Sales'
    ELSE 'High Sales'
END AS sales_band
from employee_sales
)
select sales_band, count(emp_id) as employee_count, sum(sales) as Total_sales
from band
group by 1;

/* 
3) For each employee, determine whether their sales are:
'Above Average' if their sales are higher than the overall average
'Below Average' if lower
'Average' if exactly equal
Return: emp_name, sales, average_company_sales, and performance_label
*/

select emp_id, emp_name, 
	avg(sales) over() as  avg_sales,
    case
		when sales > (select avg(sales) from employee_sales) then "Above Average"
        else "Below Average"
	end as Performance_label
from employee_sales;


