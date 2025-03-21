create database Subqueries;
use Subqueries;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    HireDate DATE
);

select * from employeeProjects;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    DepartmentID INT
);


CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    ProjectID INT,
    HoursWorked DECIMAL(5, 2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);


-- Values Insertion in the tables

-- Inserting into Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, HireDate) VALUES
(1, 'John', 'Doe', 1, 50000, '2015-01-10'),
(2, 'Jane', 'Smith', 2, 60000, '2016-02-15'),
(3, 'Peter', 'Johnson', 3, 55000, '2018-03-05'),
(4, 'Lucy', 'Brown', 1, 52000, '2019-04-20'),
(5, 'Mark', 'Davis', 2, 47000, '2017-08-25');

-- Inserting into Departments
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT');

-- Inserting into Projects
INSERT INTO Projects (ProjectID, ProjectName, DepartmentID) VALUES
(1, 'Payroll System', 2),
(2, 'Recruitment Portal', 1),
(3, 'Security Upgrade', 3);

-- Inserting into EmployeeProjects
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked) VALUES
(1, 1, 120),
(2, 1, 100),
(3, 3, 150),
(4, 2, 130),
(5, 1, 110);

-- Scaler subqueries Problms
-- Q1) Retrieve the name of employees who have worked more than 120 hours on any project.
select e.firstname, e.lastname, ep.hoursworked from employees as e
join employeeprojects as ep
on e.employeeid = ep.employeeid
where e.employeeid in (select employeeid from employeeprojects where hoursworked > 120.00);


-- Q2) Find the employees who work in the same department as 'John Doe'.
select firstname, lastname, departmentid from employees
where departmentid = (select departmentid from employees where firstname = 'John' and lastname = 'Doe');

-- Q3) List the departments that have more than one employees
select departmentname, departmentid from departments
where departmentid in (select departmentid from employees group by departmentid having count(*) > 1);

-- Q4) Retrieve the projects that involve employees from the 'IT' department.
select projectname from projects 
where departmentid in (select departmentid from departments where departmentname = "IT");


-- Q5) Find the employee(s) with the highest salary in the company.
select firstname, lastname, salary from employees
where salary = (select max(salary) from employees);

-- Q6) Retrieve the project(s) that 'Jane Smith' has worked on.
select projectname from projects
where departmentid in (select departmentid from departments
where departmentid in (select departmentid from employees where firstname = 'Jane' and lastname = 'smith'));

-- Q7) List the employees who haven't worked on any project.
select firstname from employees 
where employeeid not in (select employeeid from employeeprojects);

-- Q8) Retrieve the employees who were hired after the oldest employee in the 'HR' department
select firstname, lastname, hiredate 
from employees 
where hiredate > (select min(hiredate) 
from employees
where departmentid = (select departmentid from departments where departmentname = 'HR')); 

-- Q9) Find the departments that have projects associated with them.
select departmentname from departments
where departmentid not in (select departmentid from projects);

-- Q10) List the employees who have worked more hours than the average hours worked on any project. 
select e.firstname, e.lastname, ep.hoursworked from employees as e
join employeeprojects as ep
on e.employeeid = ep.employeeid
where ep.hoursworked >(select avg(hoursworked) from employeeprojects);

-- Q11) Find the employees who earn more than the average salary in their department
SELECT FirstName, LastName
FROM Employees AS E1
WHERE Salary > (SELECT AVG(Salary) FROM Employees AS E2 WHERE E1.DepartmentID = E2.DepartmentID);

-- Q12) Retrieve the employees who have worked on all projects of their department.
select e.firstname, e.lastname, e.employeeid, d.departmentname, d.departmentid, p.projectname, p.projectid, 
row_number() over(partition by d.departmentname) as deptwise from employees as e
join departments as d
on e.departmentid = d.departmentid
join projects as p
on d.departmentid = p.departmentid;




-- Q13) List the departments that don't have any employees.
-- Q14) Retrieve the names of employees who have worked on projects in multiple departments.
 
 select * from employees;





-- Write a query to rank employees based on their salaries within their respective departments. 
-- Include their EmployeeID, FirstName, LastName, DepartmentID, Salary, and the rank.

-- Expected Output:

-- EmployeeID
-- FirstName
-- LastName
-- DepartmentID
-- Salary
-- Rank (based on Salary within Department)
-- Ans
select e.employeeid, e.firstname, e.lastname, d.departmentname, e.salary, 
row_number() over(partition by d.departmentname order by e.salary desc) rank_based_on_salery
from employees as e
join
departments as d
on e.departmentid = d.departmentid;


/* Problem 2: Cumulative Salary by Hire Date
Create a query to calculate the cumulative salary of employees ordered by their HireDate. Include EmployeeID, FirstName, LastName, Salary, and CumulativeSalary.

Expected Output:

EmployeeID
FirstName
LastName
Salary
CumulativeSalary (sum of salaries up to and including that employee) */ 
-- Ans 

select employeeid, firstname, lastname, salary as original_salary,
sum(salary) over(order by hiredate asc rows between unbounded preceding and current row) as CumulativeSalary
from employees;


/* Problem 3: Average Hours Worked per Project
Write a query to calculate the average hours worked by employees on each project. Include ProjectID, ProjectName, and the average hours worked. Use a window function to display the average alongside the individual hours worked.

Expected Output:

ProjectID
ProjectName
HoursWorked
AverageHoursWorked*/ 
-- Ans

select p.projectid, p.projectname, ep.hoursworked, 
avg(ep.hoursworked) over(partition by p.projectname ) as AverageHoursWorked
from projects as p
join employeeprojects as ep
on p.projectid = ep.projectid;


/* Problem 4: Employee Project Participation Count
Generate a query that lists all employees along with the number of projects they are working on. Include EmployeeID, FirstName, LastName, and ProjectCount. Use a window function to achieve this.

Expected Output:

EmployeeID
FirstName
LastName
ProjectCount*/
-- Ans

SELECT 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    COUNT(ep.ProjectID) OVER (PARTITION BY e.EmployeeID) AS ProjectCount
FROM 
    Employees AS e
JOIN 
    EmployeeProjects AS ep ON e.EmployeeID = ep.EmployeeID;


/* Problem 5: Top 2 Employees by Hours Worked in Each Project
Write a query to find the top 2 employees with the most hours worked on each project. Include ProjectID, ProjectName, EmployeeID, FirstName, LastName, HoursWorked, and their rank within the project.

Expected Output:

ProjectID
ProjectName
EmployeeID
FirstName
LastName
HoursWorked
Rank (within the project)*/
-- Ans

select p.projectid, p.projectname, e.employeeid, e.firstname, e.lastname, ep.hoursworked,
row_number( ) over (partition by p.projectid order by ep.hoursworked desc) as RankWithenProjects
from employeeprojects  as ep
join projects as p
on p.projectid = ep.projectid	
join employees as e
on e.employeeid = ep.employeeid;

/* Problem 6: Percentage of Total Hours Worked by Each Employee
Create a query that calculates the percentage of total hours worked by each employee relative to the total hours worked on all projects. 
Include EmployeeID, FirstName, LastName, HoursWorked, and PercentageOfTotalHours.

Expected Output:

EmployeeID
FirstName
LastName
HoursWorked
PercentageOfTotalHours (formatted as a percentage)*/

-- Ans
select 
	  e.employeeid,
      e.firstname, 
      e.lastname,
      ep.hoursworked,
      ep.hoursworked/sum(hoursworked) over() * 100 as PercentageOfTotalHours
from 
	employees as e
join 
	employeeprojects as ep on e.employeeid = ep.employeeid;

/*
Problem 8: Highest Salary in Each Department
Generate a query that lists the highest salary in each department along with the employee's details.
 Use a window function to find the highest salary and then filter the results.

Expected Output:

DepartmentID
DepartmentName
EmployeeID
FirstName
LastName
Salary
*/

-- Ans


-- =========================================================================================================================================

-- Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    JoiningDate DATE
);

-- Projects Table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    StartDate DATE,
    EndDate DATE
);


