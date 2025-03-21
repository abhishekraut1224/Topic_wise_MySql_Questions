create database indexex;
use indexex;

CREATE TABLE employee (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

DELIMITER $$

CREATE PROCEDURE InsertEmployees()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 300 DO
        INSERT INTO employee (first_name, last_name, department, salary, hire_date)
        VALUES (
            CONCAT('First', i), 
            CONCAT('Last', i), 
            ELT(FLOOR(1 + (RAND() * 5)), 'HR', 'IT', 'Finance', 'Marketing', 'Operations'),
            ROUND(RAND() * 50000 + 30000, 2),
            DATE_ADD('2015-01-01', INTERVAL FLOOR(RAND() * 3650) DAY)
        );
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;

CALL InsertEmployees();


select * from employee;

select * from employee 
where salary = 64704.04;

create index indsal on employee(salary);

create unique index uniqIndSal on employee(emp_id);

-- To Find Existing Indexes
show indexes from employee;

-- Drop an Index (Non-Primary Key)
alter table employee drop index indsal;

-- Drop a Primary Key Index
-- ALTER TABLE table_name DROP PRIMARY KEY;

-- Creating mmultiple indexes;
create index multiindex on employee(salary, department);

show indexes from employee;
EXPLAIN select * from employee 
where department = "Finance" AND salary =	52898.95;


