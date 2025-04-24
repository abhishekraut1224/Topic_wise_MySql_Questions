create Database TimeSriesData;
Use TimeSriesData;

select now();
select curdate();
select date_format(curdate(), "%d-%1-%y");
select date_sub(curdate(), INTERVAL 1 year);
select datediff( curdate(),"2024-01-02"); -- Only give Day Level difference
select date_add(curdate(), INTERVAL 2 MONTH);
select dayname(curdate());
select monthname(curdate());
select week(curdate());
select quarter(curdate());
select last_day(curdate());
select date_format(curdate(), '%Y-%m-01'); -- Formats an existing DATE/DATETIME into a custom string.
select str_to_date(curdate(),'%d-%m-%y'); -- Converts a string into a proper DATE/DATETIME type.
select timestampdiff(hour, date_sub(now(), interval 10 hour), now()) as substractionBetweenTwoDates;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATETIME,
    delivery_date DATETIME,
    total_amount DECIMAL(10,2)
);

-- Inserting some sample data
INSERT INTO orders (order_id, customer_name, order_date, delivery_date, total_amount) VALUES
(1, 'Emma Johnson', '2024-02-20 14:35:00', '2024-02-25 18:00:00', 250.50),
(2, 'Liam Smith', '2024-02-21 09:15:00', '2024-02-26 12:30:00', 180.75),
(3, 'Sophia Brown', '2024-02-22 16:45:00', '2024-02-27 20:15:00', 320.00),
(4, 'Noah Williams', '2024-02-23 11:30:00', '2024-02-28 15:45:00', 410.25),
(5, 'Olivia Davis', '2024-02-24 08:20:00', '2024-02-29 10:00:00', 275.60);

-- Questions on Date and time 
-- Q1) Retrieve all orders along with the day of the week they were placed
select order_id, order_date, dayname(order_date) order_placed_week
from orders;

-- Q2) Find the difference in days between the order_date and delivery_date for each order.
select order_id, delivery_date, order_date,  datediff(delivery_date, order_date) as diffInOrderAndDelivery
from orders; 

-- Q3) Extract only the date part from the order_date column.
select order_date, date(order_date) as date from orders;

-- Q4) Extract only the time part from the order_date column
select order_date, time(order_date) as time from orders;

-- Q5) Retrieve orders placed in February 2024.
select order_id, order_date
from orders
where year(order_date) = 2024 and monthname(order_date) = "February";

-- Q6) Find all orders where the delivery date is on a weekend.
select order_id , delivery_date from orders
where dayname(delivery_date) = "Sunday" or dayname(delivery_date) = "Saturday";

select order_id , delivery_date, customer_name from orders
where dayofweek(delivery_date) IN (1, 7);

-- Q7) Get the first day of the month for each order_date.
select order_id, order_Date, date_format(order_date, "%y-%m-%1") first_day from orders;

-- Q8) Retrieve orders placed before noon (12:00 PM).
select order_id, order_date from orders
where hour(order_date) < 12;

-- Q9) Find orders where the delivery date is exactly 5 days after the order date.
select order_id, order_date, delivery_date 
from orders
where datediff(delivery_date, order_date) = 5; -- it runs perfectly cause it ignore time cmponents 

select order_id, order_date, delivery_date 
from orders
where delivery_date = date_add(order_date, interval 5 day); -- it won't work cause it doen't ignore time component

-- Q10) Retrieve all orders sorted by order date in descending order.
select order_id, order_date
from orders
order by order_date desc;

-- ============================================================================================================================================
-- Intermediate Questions

 CREATE TABLE employee_attendance (
    emp_id INT,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    check_in DATETIME,
    check_out DATETIME,
    PRIMARY KEY (emp_id, check_in)
);

-- Sample Data
INSERT INTO employee_attendance (emp_id, emp_name, department, check_in, check_out) VALUES
(101, 'Emma Johnson', 'HR', '2024-02-20 09:15:00', '2024-02-20 17:45:00'),
(102, 'Liam Smith', 'Finance', '2024-02-20 08:30:00', '2024-02-20 16:00:00'),
(103, 'Sophia Brown', 'IT', '2024-02-20 10:00:00', '2024-02-20 19:00:00'),
(104, 'Noah Williams', 'Marketing', '2024-02-20 09:45:00', '2024-02-20 18:30:00'),
(105, 'Olivia Davis', 'IT', '2024-02-20 07:55:00', '2024-02-20 15:45:00'),
(101, 'Emma Johnson', 'HR', '2024-02-21 09:10:00', '2024-02-21 17:30:00'),
(102, 'Liam Smith', 'Finance', '2024-02-21 08:20:00', '2024-02-21 15:50:00'),
(103, 'Sophia Brown', 'IT', '2024-02-21 10:05:00', '2024-02-21 19:15:00'),
(104, 'Noah Williams', 'Marketing', '2024-02-21 09:40:00', '2024-02-21 18:25:00'),
(105, 'Olivia Davis', 'IT', '2024-02-21 08:00:00', '2024-02-21 15:30:00');


-- Q1). Extract check-in date and time separately for all employees.
select emp_id, emp_name, 
date(check_in) as checkInDate, 
time(check_in) as checkInTime
from employee_attendance;

-- Q2: Find employees who arrived late (after 9:00 AM) at least once.
select emp_id, emp_name, time(check_in) late_CheckIn
from employee_attendance
where time(check_in) > "09:00:00";

-- Q3) Find the total working hours for each employee per day.
select emp_id, emp_name, date(check_in) as workDate,
timestampdiff(hour, check_in, check_out ) as total_worked_hour
from employee_attendance;

-- Q4) Get the earliest check-in time for each employee.
select emp_id, emp_name, min(time(check_in)) as chcek_in_time
from employee_attendance
group by emp_id, emp_name;

-- Q5). Find employees who worked overtime (more than 8 hours) on any given day.
select emp_id, emp_name, date(check_in) as check_in_date, 
timestampdiff(hour, check_in, check_out) as total_hour_worked
from employee_attendance
having total_hour_worked = 8 or  total_hour_worked > 8; 

-- Q6) Count how many employees were present in each department on a specific date.
select department, date(check_in) work_date, count(*) as employee_present
from employee_attendance
group by department, work_date;

-- Q7) Identify employees who checked in and out on different dates.
select emp_id, emp_name, date(check_in) check_in_date, date(check_out) check_out_date
from employee_attendance
having check_in_date != check_out_date;

-- Q8) Find the department with the highest average working hours.
select department,
round(avg(timestampdiff(hour, check_in, check_out)), 0) as  avg_working_hour 
from employee_attendance
group by department
order by avg_working_hour desc
limit 1;

-- Q9). Get a running total of working hours for each employee (over multiple days).
select emp_id, emp_name, date(check_in) worked_date, 
timestampdiff(hour, check_in, check_out) woring_hours,
sum(timestampdiff(hour, check_in, check_out))
over(partition by emp_id order by check_in) as running_total_hour
from employee_attendance;

-- Q10) Find the employee who had the longest working day across all records.
select emp_id, emp_name, 
timestampdiff(hour, check_in, check_out) working_hour
from employee_attendance
order by working_hour desc
limit 1;
