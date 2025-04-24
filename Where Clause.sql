create database whereclause;
use whereclause;

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE
);

INSERT INTO Employees (employee_id, first_name, last_name, age, department, salary, hire_date) VALUES
(1, 'John', 'Doe', 30, 'HR', 60000.00, '2018-01-15'),
(2, 'Jane', 'Smith', 25, 'Finance', 65000.00, '2019-03-22'),
(3, 'Michael', 'Johnson', 45, 'IT', 80000.00, '2015-08-12'),
(4, 'Emily', 'Davis', 35, 'Marketing', 70000.00, '2020-11-01'),
(5, 'William', 'Brown', 50, 'Finance', 90000.00, '2010-06-30'),
(6, 'Olivia', 'Wilson', 29, 'IT', 75000.00, '2017-04-10'),
(7, 'James', 'Jones', 40, 'HR', 72000.00, '2012-12-01'),
(8, 'Sophia', 'Garcia', 32, 'Marketing', 68000.00, '2019-07-23'),
(9, 'Mason', 'Martinez', 27, 'IT', 77000.00, '2021-01-11'),
(10, 'Isabella', 'Rodriguez', 38, 'Finance', 88000.00, '2016-05-19');


Select * from employees;

-- Questions on where clause 

-- Q1) Find all employees who work in the 'IT' department.
Select * from employees
where department = "IT";

-- Q2) Retrieve the details of employees whose salary is greater than 70000.
Select * from employees 
where salary > 70000;

-- Q3) Get the list of employees who were hired before the year 2018.
Select first_name, last_name from employees
where hire_date < '2018-01-01';

-- Q4) Find employees who are 30 years old or younger.
Select * from employees 
where age <=30;

-- Q5)  Retrieve the first and last names of employees in the 'HR' or 'Marketing' departments.
select first_name, last_name, department from employees
where department = "HR" or department = "Marketing"; 

-- Q6) List the employees with a salary between 65000 and 80000.
Select * from employees
where salary between 65000 and 80000;

-- Q7) List the employees whose first name has exactly 5 characters
Select * from employees 
where length(first_name) = 5;

-- Q8) Retrieve the details of employees who work in the 'Finance' department and have a salary greater than 85000.
Select * from employees 
where department = "Finance" AND Salary > 85000;

-- Q9) Get the list of employees who were hired on or after '2017-04-10'.
Select * from employees 
where hire_date >= "2017-04-10";

-- Q10) Find employees with a salary that is either 65000 or 90000.
select * from employees 
where salary = 65000 or salary = 90000;

-- Q11) Retrieve the details of employees who are not older than 35 and do not work in 'Marketing'.
select * from employees 
where age <= 35  And department != "Marketing";

-- Q12) List the employees who have the first name 'John' or 'Jane'.
select * from employees
where first_name IN ('John' or 'Jane');

-- Q13) Find employees who were hired in the year 2019.
select * from employees
where year(hire_date) = "2019";

-- Q14) Find employees whose last name starts with 'J'.
Select * from employees 
where last_name like "J%";

-- Q15) Get the list of employees who have a first name containing 'li'.
select * from employees
where first_name LIKE "%li%";
 

-- Advance Questions 

-- Q1) Find employees who are in the 'IT' department and have a salary greater than the average salary of the 'IT' department.
select * from employees 
where department = "IT" And Salary > (select avg(salary) from employees where department = "IT");

-- Q2) Retrieve the details of employees whose hire date is within the last 5 years.
select * from employees 
where hire_date >= date_sub(curdate(), interval 5 year);







