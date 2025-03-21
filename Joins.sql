Create database sql_joins;
use sql_joins;

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10 , 2 ),
    hire_date DATE
);



INSERT INTO employees (first_name, last_name, department, salary, hire_date) VALUES
('John', 'Doe', 'Engineering', 75000, '2019-03-15'),
('Jane', 'Smith', 'Marketing', 65000, '2021-06-22'),
('Alice', 'Johnson', 'Engineering', 80000, '2018-11-10'),
('Bob', 'Brown', 'HR', 55000, '2020-01-05'),
('Carol', 'White', 'Finance', 90000, '2017-09-14');



CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(15, 2)
);

INSERT INTO projects (project_name, start_date, end_date, budget) VALUES
('Project Alpha', '2023-01-01', '2023-12-31', 200000),
('Project Beta', '2022-05-15', '2023-05-15', 150000),
('Project Gamma', '2024-02-01', '2024-08-31', 50000),
('Project Delta', '2023-07-01', '2024-06-30', 300000),
('Project Epsilon', '2021-10-01', '2022-09-30', 100000);


CREATE TABLE employee_projects (
    employee_id INT,
    project_id INT,
    role VARCHAR(50),
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO employee_projects (employee_id, project_id, role) VALUES
(1, 1, 'Developer'),
(1, 2, 'Lead Developer'),
(2, 2, 'Marketing Specialist'),
(3, 1, 'Senior Developer'),
(3, 3, 'Project Manager'),
(4, 4, 'HR Coordinator'),
(5, 5, 'Financial Analyst'),
(2, 4, 'Marketing Lead'),
(4, 1, 'HR Assistant');

Select * from employee_projects;



-- Basecs Questions

-- Q1) List all employees and their respective projects.
SELECT 
    e.first_name, e.last_name, p.project_name
FROM
    employees AS e
        JOIN
    employee_projects AS EP ON e.employee_id = EP.employee_id
        JOIN
    projects AS p ON Ep.project_id = p.project_id;

-- Q2) List all employees who are not assigned to any project.
SELECT 
    e.first_name, e.last_name
FROM
    employees AS e
        LEFT JOIN
    employee_projects AS ep ON e.employee_id = ep.employee_id
WHERE
    ep.employee_id IS NULL;

-- Q3) List all projects and their assigned employees
SELECT 
    p.project_name, e.first_name, e.last_name
FROM
    employees AS e
        RIGHT JOIN
    employee_projects AS ep ON e.employee_id = ep.employee_id
        RIGHT JOIN
    projects AS p ON ep.project_id = p.project_id;

-- Q4) Find all projects with a budget greater than $100,000 and the employees working on them.
SELECT 
    p.project_name, p.budget, e.first_name, e.last_name
FROM
    employees AS e
        RIGHT JOIN
    employee_projects AS ep ON e.employee_id = ep.employee_id
        RIGHT JOIN
    projects AS p ON ep.project_id = p.project_id
WHERE
    p.budget > 100000;

-- Q5) List all employees along with the number of projects they are working on.
SELECT 
    e.last_name AS lastname,
    COUNT(ep.project_id) AS no_projects_given
FROM
    employees AS e
        RIGHT JOIN
    employee_projects AS ep ON e.employee_id = ep.employee_id
GROUP BY lastname
ORDER BY lastname;

-- Q6) Find the total salary of employees working on each project.
SELECT 
    p.project_name AS projectName, SUM(e.salary) AS Total_salary
FROM
    employees AS e
        RIGHT JOIN
    employee_projects AS ep ON e.employee_id = ep.employee_id
        RIGHT JOIN
    projects AS p ON ep.project_id = p.project_id
GROUP BY p.project_id;

-- Q7) List the projects that started after January 1, 2022, and the employees working on them.
SELECT 
    p.project_name, p.start_date, e.first_name, e.last_name
FROM
    employees AS e
        RIGHT JOIN
    employee_projects AS ep ON e.employee_id = ep.employee_id
        RIGHT JOIN
    projects AS p ON ep.project_id = p.project_id
WHERE
    p.start_date > '2022-01-01';

-- Q8) Find employees who are working on more than one project.
SELECT 
    e.first_name, e.last_name, COUNT(project_id)
FROM
    employees AS e
        JOIN
    employee_projects AS EP ON e.employee_id = ep.employee_id
GROUP BY e.employee_id
HAVING COUNT(project_id) > 1;

-- Q9) List employees and their roles in each project
SELECT 
    e.first_name, e.last_name, p.project_name, ep.role
FROM
    employees AS e
        JOIN
    employee_projects AS ep ON e.employee_id = ep.employee_id
        JOIN
    projects AS p ON ep.project_id = p.project_id;

-- Q10) Find the highest paid employee in each department.
SELECT 
    first_name, last_name, department, salary
FROM
    employees
WHERE
    (department , salary) IN (SELECT 
            department, MAX(salary)
        FROM
            employees
        GROUP BY department);
        
-- Q11) List all projects along with the number of employees working on each project.

	SELECT 
    p.project_name, COUNT(ep.employee_id)
FROM
    projects AS p
        JOIN
    employee_projects AS ep ON p.project_id = ep.project_id
GROUP BY p.project_name;
    
-- Q12) Find employees who have joined before 2020 and are working on at least one project;
SELECT 
    e.first_name, e.last_name
FROM
    employees e
        JOIN
    employee_projects ep ON e.employee_id = ep.employee_id
WHERE
    e.hire_date < '2020-01-01'
GROUP BY e.employee_id;

-- Q13) List all departments and the total number of employees in each department
SELECT 
    department, COUNT(employee_id) Total_emp_in_each_dept
FROM
    employees
GROUP BY department;

-- Q14) Find projects that have not started yet and list employees assigned to them.
SELECT 
    p.project_name, e.first_name, e.last_name, p.start_date
FROM
    employees AS e
        JOIN
    employee_projects AS ep ON e.employee_id = ep.employee_id
        JOIN
    projects AS p ON ep.project_id = p.project_id
WHERE
    p.start_date > CURDATE();

-- Q15) List employees who are working on projects with a budget less than $50,000
SELECT 
    e.first_name, e.last_name, p.project_name, p.budget
FROM
    employees AS e
        JOIN
    employee_projects AS ep ON e.employee_id = ep.employee_id
        JOIN
    projects AS p ON ep.project_id = p.project_id
WHERE
    p.budget < 50000;




-- Advance Questions


SELECT 
    e.first_name,
    e.last_name,
    COUNT(ep.project_id) AS projectCount
FROM
    employees AS e
        JOIN
    employee_projects AS ep ON e.employee_id = ep.employee_id
GROUP BY e.first_name , e.last_name
ORDER BY projectCount DESC
LIMIT 1;

-- Q2) List all projects that have more than 2 employees assigned to them.
SELECT 
    p.project_name AS ProjectName, COUNT(ep.employee_id)
FROM
    employee_projects AS ep
        JOIN
    projects AS p ON ep.project_id = p.project_id
GROUP BY ProjectName
HAVING COUNT(ep.employee_id) > 2;

-- Q3) Find the names of employees who are working on both 'Project Alpha' and 'Project Beta'.
SELECT 
    e.first_name, e.last_name, p1.project_name, p2.project_name
FROM
    employees AS e
        JOIN
    employee_projects AS ep1 ON e.employee_id = ep1.employee_id
        JOIN
    projects AS p1 ON ep1.project_id = p1.project_id
        AND p1.project_name = 'Project Alpha'
        JOIN
    employee_projects AS ep2 ON e.employee_id = ep2.employee_id
        JOIN
    projects AS p2 ON ep2.project_id = p2.project_id
        AND p2.project_name = 'Project Beta';

-- Q4) List the total budget of projects each department is involved in
SELECT 
    e.department, SUM(budget)
FROM
    employees AS e
        JOIN
    employee_projects AS ep ON e.employee_id = ep.employee_id
        JOIN
    projects AS p ON ep.project_id = p.project_id
GROUP BY e.department;

-- Q5) 	Find employees who are only working on one project.
SELECT 
    e.first_name, e.last_name, COUNT(ep.project_id)
FROM
    employees AS e
        JOIN
    employee_projects AS ep ON e.employee_id = ep.employee_id
GROUP BY e.first_name , e.last_name
HAVING COUNT(ep.project_id) = 1;

-- Q6) Get the names of employees who are working on the project with the highest budget.
SELECT 
    e.first_name, e.last_name
FROM
    employees e
        JOIN
    employee_projects ep ON e.employee_id = ep.employee_id
        JOIN
    projects p ON ep.project_id = p.project_id
WHERE
    p.budget = (SELECT 
            MAX(budget)
        FROM
            projects);

-- From here you have to solve it

SELECT 
    p.project_name, AVG(e.salary) AS average_salary
FROM
    projects p
        JOIN
    employee_projects ep ON p.project_id = ep.project_id
        JOIN
    employees e ON ep.employee_id = e.employee_id
GROUP BY p.project_id;

-- Q8) Find the name of the employee with the lowest salary who is working on 'Project Delta'.
SELECT 
    e.first_name, e.last_name, e.salary
FROM
    employees e
        JOIN
    employee_projects ep ON e.employee_id = ep.employee_id
        JOIN
    projects p ON ep.project_id = p.project_id
WHERE
    p.project_name = 'Project Delta'
ORDER BY e.salary ASC
LIMIT 1;


-- Q9) Get the list of projects along with the maximum salary of employees working on them.
SELECT 
    p.project_name, MAX(e.salary) AS max_salary
FROM
    projects p
        JOIN
    employee_projects ep ON p.project_id = ep.project_id
        JOIN
    employees e ON ep.employee_id = e.employee_id
GROUP BY p.project_id;


-- Q10) Find employees who joined before 2020 and have worked on at least one project in 2023.
SELECT DISTINCT
    e.first_name, e.last_name
FROM
    employees e
        JOIN
    employee_projects ep ON e.employee_id = ep.employee_id
        JOIN
    projects p ON ep.project_id = p.project_id
WHERE
    e.hire_date < '2020-01-01'
        AND YEAR(p.start_date) = 2023;


-- Q11)List the projects where no employee from the 'HR' department is assigned.
SELECT 
    p.project_name
FROM
    projects p
        LEFT JOIN
    employee_projects ep ON p.project_id = ep.project_id
        LEFT JOIN
    employees e ON ep.employee_id = e.employee_id
        AND e.department = 'HR'
WHERE
    e.employee_id IS NULL;


-- Q12)Find the total number of projects managed by each project manager.
SELECT 
    e.first_name,
    e.last_name,
    COUNT(p.project_id) AS project_count
FROM
    employees e
        JOIN
    employee_projects ep ON e.employee_id = ep.employee_id
        JOIN
    projects p ON ep.project_id = p.project_id
WHERE
    ep.role = 'Project Manager'
GROUP BY e.employee_id;



-- Q13)List employees and the names of the projects they have not been assigned to.
SELECT 
    e.first_name, e.last_name, p.project_name
FROM
    employees e
        CROSS JOIN
    projects p
        LEFT JOIN
    employee_projects ep ON e.employee_id = ep.employee_id
        AND p.project_id = ep.project_id
WHERE
    ep.project_id IS NULL;



-- Q14) Get a list of employees who are working on projects with a budget between $50,000 and $150,000.
SELECT 
    e.first_name, e.last_name, p.project_name, p.budget
FROM
    employees e
        JOIN
    employee_projects ep ON e.employee_id = ep.employee_id
        JOIN
    projects p ON ep.project_id = p.project_id
WHERE
    p.budget BETWEEN 50000 AND 150000;


-- Q15) Find departments with employees assigned to projects that have already ended.
SELECT DISTINCT
    e.department
FROM
    employees e
        JOIN
    employee_projects ep ON e.employee_id = ep.employee_id
        JOIN
    projects p ON ep.project_id = p.project_id
WHERE
    p.end_date < CURDATE();

