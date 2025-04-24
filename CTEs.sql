create database CTEs;
use CTEs;




CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL
);

INSERT INTO employee (emp_id, emp_name, Salary) VALUES
(1, 'Rahul Sharma', 50000.00),
(2, 'Priya Singh', 60000.50),
(3, 'Amit Verma', 45000.75),
(4, 'Neha Patil', 70000.00),
(5, 'Vikram Das', 55000.25);

Select * from employee;


-- Employee who earn more than avg salary of all the employees

with average_salary as
	(select round(avg(salary),0) as av_salary from employee)
    
select * from employee as e, average_salary as av
	where salary > av.av_salary;
    
    
CREATE TABLE sales (
    store_id INT,
    store_name VARCHAR(100) NOT NULL,
    product VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    cost DECIMAL(10,2) NOT NULL
);

INSERT INTO sales (store_id, store_name, product, quantity, cost) VALUES
(1, 'Store A', 'Laptop', 5, 50000.00),
(1, 'Store A', 'Mouse', 20, 500.00),
(2, 'Store B', 'Smartphone', 10, 20000.50),
(2, 'Store B', 'Charger', 25, 1500.00),
(3, 'Store C', 'Headphones', 15, 1500.75),
(3, 'Store C', 'Keyboard', 12, 2000.00),
(4, 'Store D', 'Tablet', 7, 30000.00),
(4, 'Store D', 'Smartwatch', 8, 12000.25);

select * from sales;
-- find store whose sales where better than avg sales of accross all stores

-- total sales per each store
select store_name, sum(quantity * cost) as total_sales
from sales
group by store_name
order by store_name;

-- avg_sales with respect to all the stores
select  avg(quantity * cost) as avg_sales
from sales;

-- find the store where total sales are greater than avg_sales of all stores
select store_name, sum(quantity * cost) as total_sales
from sales
group by store_name
having total_sales > (select avg(total_sales)
from (select store_name, sum(quantity * cost) as total_sales
from sales
group by store_name) as store_sales) 
order by total_sales desc 
limit 1;

-- USing CTEs	

with store_sales as 
	(select store_name, sum(quantity *cost) as total_sales 
    from sales
    group by store_name)
,av_store_sales as 
	(select avg(total_sales) av_sales 
    from store_sales)
    
select store_name, total_sales
from store_sales as ss, av_store_sales as ass
where ss.total_sales > ass.av_sales
order by total_sales desc
limit 1;

-- =========================================================================================================================================

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

select * from departments;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    salary DECIMAL(10,2),
    dept_id INT,
    manager_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance'),
(4, 'Marketing');

select * from departments;

INSERT INTO employees (emp_id, emp_name, salary, dept_id, manager_id) VALUES
(101, 'Alice', 75000, 2, NULL),
(102, 'Bob', 50000, 2, 101),
(103, 'Charlie', 55000, 1, 101),
(104, 'David', 62000, 3, 103),
(105, 'Eve', 47000, 4, 102),
(106, 'Frank', 52000, 4, 102),
(107, 'Grace', 68000, 2, 101),
(108, 'Hank', 70000, 3, 103);

select * from employees;

-- Q1. 1. Find employees earning more than the average salary of their department.

select e1.emp_name, e1.salary, e1.dept_id
from employees as e1
where salary > (select avg(salary)
	from employees as e2
    where e1.dept_id = e2.dept_id);
    
with av_cte as
	(select dept_id, avg(salary) as av_salary
    from employees
    group by dept_id)
    
select e.emp_name, e.dept_id, e.salary
from employees as e
join 
av_cte as av
on av.dept_id = e.dept_id
where e.salary > av.av_salary; 

-- 2. Find the highest-paid employee in each department.
select emp_name, salary , dept_id
from employees as e
where salary =  (select max(e1.salary) 
from employees as e1
where e.dept_id = e1.dept_id);
    
with max_CTEs as 
	(select dept_id, max(salary) as max_salary
    from employees
    group by dept_id)
    
select e.dept_id, e.salary, e.emp_name
from employees as e
join 
max_CTEs as CTE
on e.dept_id = cte.dept_id
where e.salary =  cte.max_salary
order by e.dept_id; 
		
-- 3. Find departments where the total salary expense is higher than the average total salary expense across all departments.

select dept_id, sum(salary) as total_salary
from employees 
group by dept_id;

select dept_id, sum(salary) as total_salary
from employees 
group by dept_id
having total_salary >
(select avg(total_salary)
from (select dept_id, sum(salary) as total_salary
from employees 
group by dept_id) as Total_salary_expance_per_dept);

-- using CTEs

with total_Salary_expance as
	(select dept_id, sum(salary) as salary_expance
    from employees 
    group by dept_id)
,avg_salary_expance as
	(select avg(salary_expance) as avg_expance from total_salary_expance)
    
select tse.dept_id, tse.salary_expance
from total_Salary_expance as tse
join 
avg_salary_expance as ase
on tse.salary_expance > ase.avg_expance;


-- 4. Find employees who are the only ones in their department.
SELECT emp_name, dept_id
FROM employees e1
WHERE 1 = (
    SELECT COUNT(*)
    FROM employees e2
    WHERE e1.dept_id = e2.dept_id
);


-- Using CTEs

WITH dept_count_cte AS (
    SELECT dept_id, COUNT(*) AS emp_count
    FROM employees
    GROUP BY dept_id
)
SELECT e.emp_name, e.dept_id
FROM employees e
JOIN dept_count_cte d ON e.dept_id = d.dept_id
WHERE d.emp_count = 1;

-- 5. Find employees who are the only ones in their department.
 
select count(emp_id) no_of_employees, dept_id
from employees as e
group by dept_id
having no_of_employees = 1;

-- With Subquery
select  emp_name, dept_id, emp_id
from employees as e
where 1 = (
			select count(*) 
			from employees as e2
            where e.dept_id = e2.dept_id
);

-- With CTEs

WITH only_once_InDept as (
	select dept_id , count(emp_id) as no_of_employees
    from employees
    group by dept_id
)

select e.emp_name, e.dept_id
from employees as e
join 
only_once_InDept as ooi
on ooi.dept_id = e.dept_id
where ooi.no_of_employees = 1;



	








