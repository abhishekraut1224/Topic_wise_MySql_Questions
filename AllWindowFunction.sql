Create database window_functions;
use window_functions;



-- -----------------------------------------------------------------------------------------------------------------------------------------
-- OVER() Clause
-- -----------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    region VARCHAR(255),
    product VARCHAR(255),
    sales_amount DECIMAL(10, 2),
    sales_date DATE
);

INSERT INTO sales (region, product, sales_amount, sales_date) VALUES 
('North', 'Product A', 1000, '2024-05-01'),
('North', 'Product B', 1500, '2024-05-01'),
('South', 'Product A', 800, '2024-05-01'),
('South', 'Product B', 1200, '2024-05-01'),
('East', 'Product A', 2000, '2024-05-01'),
('East', 'Product B', 2500, '2024-05-01');

-- Q1) Calculate Total Sales Amount per Region:
select s.region, sum(s.sales_amount) 
over(partition by region) as Toatl_sales_as_per_region
from sales as s;

-- Q2) Rank Products by Sales Amount within Each Region:
select region, product, sales_amount,
rank() over(partition by region order by sales_amount desc) as rank_withen_region
from sales;

-- Q3) Calculate Cumulative Sales Amount within Each Region:
SELECT region, 
       product, 
       sales_amount,
       SUM(sales_amount) OVER(PARTITION BY region ORDER BY sales_date) AS cumulative_sales_within_region
FROM sales;

-- Q4) Determine Maximum Sales Amount per Region:
select region, max(sales_amount) 
over(partition by region) as max_sales_per_region
from sales;

-- Q5) Calculate Percentage of Total Sales Amount by Product:
select product, sales_amount, sales_amount/sum(sales_amount)
over() *100 percentage_of_total_sales
from sales
order by percentage_of_total_sales;

-- Q6) Calculate Difference in Sales Amount from Previous Row within Each Region:
select region, sales_amount, sales_amount - lag(sales_amount)
over(partition by region order by sales_date) as Difference_in_sales_and_prev_sales
from sales;

-- Q7) Calculate Running Total of Sales Amount within Each Region:
select region, product, sales_amount, sum(sales_amount)
over(partition by region order by sales_date desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT row) as running_total_withen_region
from sales;

-- Q8) Calculate Average Sales Amount per Product:
select product, avg(sales_amount) 
over(partition by product) as avg_sales_amount_per_products
from sales;

-- Q9) Calculate Percentage Change in Sales Amount from Previous Row:
select region, product, sales_amount, 
(sales_amount - lag(sales_amount) over (order by sales_date))/ lag(sales_amount) over(order by sales_date) * 100 as percentage_change_from_previous_row
from sales; 

-- Q10) Calculate Moving Average of Sales Amount within Each Region:
select region, 
	   product, 
       sales_amount,
	   avg(sales_amount)
       over(partition by region ORDER BY sales_date desc rows between unbounded preceding and current row) as moving_avg_sales_withen_region
       from sales;
       
-- 11) Calculate Lead of Sales Amount from Next Row within Each Region:
select region, product, sales_amount, lead(sales_amount) 
over (partition by region order by sales_date desc) as lead_sales_amount_within_region
from sales;

-- 12) Calculate Median Sales Amount per Product:



-- 13) Calculate Sales Amount Rank within Each Region (Dense Rank):
Select region,
	   product,
       sales_amount,
       dense_rank()
       over(partition by region order by sales_amount desc) as sales_rank_within_region
from sales;
    
-- Q14) Calculate Sum of Sales Amount for the Current Row and Next Row:
select region, 
	   product,
	   sales_amount + lead(sales_amount)
       over(order by sales_date ) sum_of_current_and_next_sales
       from sales;
       
-- Q15) Calculate Percentage of Sales Amount Compared to Maximum Sales Amount within Each Region:
select region,
	   product,
       sales_amount,
       sales_amount / max(sales_amount) over(partition by region )*100 as percentage_of_max_sales_within_region
from sales;

-- ==============================================================================================================================
-- Intermediate level questions 
create database Intermediate;
use Intermediate;

CREATE TABLE CriticalPatients (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(100),
    Age INT,
    Disease VARCHAR(100),
    AdmissionDate DATE,
    DoctorAssigned VARCHAR(100),
    SeverityLevel INT,  -- Ranges from 1 (Least Critical) to 5 (Most Critical)
    DaysAdmitted INT
);



INSERT INTO CriticalPatients (PatientID, PatientName, Age, Disease, AdmissionDate, DoctorAssigned, SeverityLevel, DaysAdmitted) 
VALUES 
(1, 'Rajesh Kumar', 55, 'Heart Attack', '2024-02-01', 'Dr. Mehta', 5, 10),
(2, 'Anita Sharma', 42, 'Pneumonia', '2024-02-05', 'Dr. Kapoor', 3, 7),
(3, 'John Doe', 67, 'Kidney Failure', '2024-01-28', 'Dr. Mehta', 4, 15),
(4, 'Suresh Yadav', 39, 'Liver Cirrhosis', '2024-02-10', 'Dr. Khan', 2, 5),
(5, 'Fatima Begum', 75, 'Stroke', '2024-02-02', 'Dr. Kapoor', 5, 12),
(6, 'Amit Verma', 50, 'COVID-19', '2024-02-12', 'Dr. Rao', 3, 8),
(7, 'Rohan Patil', 60, 'Cancer', '2024-01-30', 'Dr. Khan', 4, 20),
(8, 'Pooja Mishra', 29, 'Tuberculosis', '2024-02-14', 'Dr. Rao', 2, 6),
(9, 'David Smith', 71, 'Heart Failure', '2024-01-25', 'Dr. Mehta', 5, 18),
(10, 'Sneha Iyer', 35, 'Brain Tumor', '2024-02-07', 'Dr. Kapoor', 4, 9);

Select * From CriticalPatients;



-- All 10 Questions

Select * From CriticalPatients;
-- Q1) Rank patients based on severity level (highest first). 
-- If two patients have the same severity, rank them by days admitted (highest first).
-- Q2). Find the average number of days admitted for each doctor’s patients using window functions.
-- Q3). Show each patient’s severity level along with the next patient’s severity level using LEAD.
-- Q4) Find the difference in days admitted between a patient and the previous patient admitted using LAG.
-- Q5) For each patient, show the cumulative sum of days admitted for their doctor’s patients.
-- Q6) Assign a dense rank to patients based on the number of days admitted, with the longest stays ranked first.
-- Q7). Calculate the moving average of days admitted over the last three patients admitted (including the current patient).
-- Q8) Determine the percentile rank of each patient based on their severity level.
-- Q9). Find the total number of days admitted for all patients along with each patient’s percentage contribution to the total.
-- Q10). Get the first and last admission dates for each doctor’s patients using FIRST_VALUE and LAST_VALUE.
-- ================================================================================================================================
-- Q1) Rank patients based on severity level (highest first). 
-- If two patients have the same severity, rank them by days admitted (highest first).

select Patientid, PatientName, severitylevel, DaysAdmitted,
rank() over(order by severitylevel desc, Daysadmitted desc) as RnkOnSeverityLevel
from CriticalPatients;

 -- Q2). Find the average number of days admitted for each doctor’s patients using window functions.
select  PatientID, PatientName, DoctorAssigned,
avg(DaysAdmitted) over(partition by DoctorAssigned) as AvgDysAdmitted
from CriticalPatients;

-- Q3). Show each patient’s severity level along with the next patient’s severity level using LEAD.
select PatientName, severitylevel,
lead(severitylevel) over(order by severitylevel desc) as NextPatientsseverity
from CriticalPatients;

-- Q4) Find the difference in days admitted between a patient and the previous patient admitted using LAG.
select  PatientName, daysadmitted, 
lag(daysadmitted)
over(order by admissionDate) as Previousdays,
daysadmitted - lag(daysadmitted) over (order by admissionDate) as DifferenceInDays
from CriticalPatients;

-- Q5) For each patient, show the cumulative sum of days admitted for their doctor’s patients.
Select  PatientName, DoctorAssigned, Daysadmitted,
sum(Daysadmitted) over(partition by DoctorAssigned order by AdmissionDate) as Cumulativedays
from CriticalPatients;

-- Q6) Assign a dense rank to patients based on the number of days admitted, with the longest stays ranked first.
 select PatientName, DoctorAssigned, Daysadmitted,
 dense_rank() over(order by Daysadmitted desc) PatientRank
 from CriticalPatients;
 
-- Q7). Calculate the moving average of days admitted over the last three patients admitted (including the current patient).
select PatientName, Daysadmitted,
avg(Daysadmitted) over (order by AdmissionDate rows between 2 preceding and current row) MovingDaysAvg
from CriticalPatients;

-- Q8) Determine the percentile rank of each patient based on their severity level.
select PatientName, Daysadmitted, severitylevel,
percent_rank() over(order by severitylevel desc) as PecentileRankSecuritylevel
from CriticalPatients;

-- Q9). Find the total number of days admitted for all patients along with each patient’s percentage contribution to the total.
select PatientName, Daysadmitted, 
sum(Daysadmitted) over() as TotalNoOFDayAdmitted, 
(Daysadmitted*100)/sum(Daysadmitted)over()  as PercentDaysPerPatient
from CriticalPatients;

-- Q10). Get the first and last admission dates for each doctor’s patients using FIRST_VALUE and LAST_VALUE.
select PatientName, Daysadmitted, admissionDate, DoctorAssigned,
first_value(admissionDate)over(partition by DoctorAssigned order by admissionDate ) as FirstAdmissionDate,
last_value(admissionDate)over(partition by DoctorAssigned order by admissionDate 
rows between unbounded preceding and unbounded following) as LastAdmissionDate
from CriticalPatients;

Alter table CriticalPatients add DischargeDate DATE;

Update CriticalPatients 
SET DischargeDate = DATE_ADD(AdmissionDate, INTERVAL DaysAdmitted DAY);

SET SQL_SAFE_UPDATES = 1;
