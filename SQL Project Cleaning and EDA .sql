use world_layoffs;
select * from layoffs;

-- Data Cleaning
-- =================================================
-- Remove Duplicate 
-- Standerdize Data
-- Null values
-- Remove unnecessary columns or rows
-- =================================================

-- Create a copy of our original data
Create Table layoffs_Staging2
like layoffs;

select * from layoffs_Staging2;

insert layoffs_Staging2
select * from layoffs;

-- ======================================================

-- Duplicate Rowa Deletion

-- ========================================================
-- add Unique column ID
select * from layoffs_Staging2;
alter table layoffs_Staging2 add column ID int auto_increment primary key ;

-- =========================================================
-- Cheack Duplicate 
with Duplicate_Cte as 
(select *, 
row_number() over(partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions order by (select null)) as row_num
from layoffs_Staging2) 

select * from Duplicate_Cte
where row_num > 1;

-- ==========================================
-- Safe mode off

SET SQL_SAFE_UPDATES = 0;
-- ===========================================
-- Removing Duplicate

with Duplicate_Cte as 
(select *, 
row_number() over(partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions order by (select null)) as row_num
from layoffs_Staging2) 

delete from layoffs_Staging2
where id in (select id from Duplicate_Cte where row_num>1);
-- ================================================
select * from layoffs_Staging2;
-- Drop ID column
alter table layoffs_Staging2 drop column ID;
-- ================================================

-- Standardizing the Data
select * from layoffs_Staging2;
select distinct(trim(location)) from layoffs_Staging2;

-- We have a anamolies in the industry crypto column some where has Crypto currency wome where Cryptocurrency
-- so all we need is Cryto only
select * from layoffs_Staging2
where industry like "Crypto%";

-- update the Crypto value 
update layoffs_Staging2
set  industry = "Crypto"
where industry like "Crypto%";

select distinct(industry) from layoffs_Staging2;
select distinct(location) from layoffs_Staging2 order by 1;
select distinct(Country) from layoffs_Staging2 order by 1;

select * from layoffs_Staging2 
where country like "United States%";

-- found the anamoli "United States."

update layoffs_Staging2
set country = "United States"
where country like "United States%";

select distinct(country), country from layoffs_Staging2
order by 1;


-- Cheack the data types and correct it 
select * from layoffs_Staging2;

-- change for DATE
-- set our Date Format
update layoffs_Staging2
set `date` =  str_to_date(`date`, '%m/%d/%Y'); -- provide your exact date formate present in the date column otherwise you will get the error

-- Change the data type
alter table layoffs_Staging2
modify column `date` date;


select * from layoffs_Staging2;
 
select `date` from layoffs_Staging limit 5;


describe layoffs_Staging;



-- Dealing with NUll and Blank Rows
-- Step 1 imp step --> Think and then take the decision what should we do with the null and blank value
 

select Company, location, industry from layoffs_Staging2
where industry is NUll 
or industry = '' ; -- using this may be we fill the null and blank values of industry 
-- if company and loc is same the we can assume that the industry should be same


-- for example
select * from layoffs_Staging2
where company = 'Airbnb';

-- using this example we can fill the null and blank values of the same industry and the location
select * from layoffs_Staging2;

-- we are cheacking side by side that is there are some industry values null and blank and some are not null
-- where the company and the location is same 
select t1.industry, t2.industry 
from layoffs_Staging2 as t1
join layoffs_Staging2 as t2
on t1.company = t2.company 
where (t1.industry is NULL or t1.industry = "") 
and t2.industry is not NUll;

-- removing the safe mode
SET SQL_SAFE_UPDATES = 0;

-- resert all blanks to null
update layoffs_Staging2
set industry = null
where industry = '';

-- Updating the industry column 
update layoffs_Staging2 t1
join layoffs_Staging2 as t2
on t1.company = t2.company and t1.location = t2.location
set t1.industry = t2.industry
where t1.industry is null and t2.industry is not null;

-- cheacking the update 
select *  from layoffs_Staging2
where company = "Airbnb";

select * from layoffs_Staging2
where industry is null;

-- so now there is only one row where insudtry is null and there not another row populate 
-- where the same company name is present and the indstry row is not null 
-- so we can't update the industry row 

select * from layoffs_Staging2
where company = "Bally's Interactive";


select * from layoffs_Staging2;

select * from layoffs_Staging2
where country is null; 

select * from layoffs_Staging2
where funds_raised_millions is null or funds_raised_millions = '';

-- here we cant really do anything of remaining null values we cant do mean, median or mode
-- we could do something with the columns total_laid_off and percentage_laid_off if we have given Total employee
select * from layoffs_Staging2
where total_laid_off is null 
and percentage_laid_off is null;

-- because of our data is present on the lay of situstions we can do nothing with this data 
-- where total_laid_off and percentage_laid_off is null alter
-- thats why its ok to remove those rows

-- delete the rows where total_laid_off and percentage_laid_off is null
delete from layoffs_Staging2
where total_laid_off is null 
and percentage_laid_off is null;

-- =========================================================================================================================================

-- Exploratory Data Analysis
select * from layoffs_Staging2;

-- Find the maximum number of layoffs and the highest layoff percentage
select max(total_laid_off),
max(percentage_laid_off)
from layoffs_Staging2;

-- Retrieve layoffs where 100% of employees were laid off, sorted by total layoffs (descending)
select total_laid_off, 
	percentage_laid_off from layoffs_Staging2
    where percentage_laid_off = 1
    order by 1 desc;

-- Total layoffs per company, sorted by highest layoffs
select company, sum(total_laid_off) 
from layoffs_Staging2
group by 1
order by 2 desc;

-- Find the earliest and latest layoff dates in the dataset
select min(`date`), max(`date`)
from layoffs_Staging2;

-- Total layoffs per industry, sorted by highest layoffs
select industry, sum(total_laid_off)
from layoffs_Staging2
group by 1
order by 2 desc;

-- Total layoffs per country, sorted by highest layoffs
select country, sum(total_laid_off)
from layoffs_Staging2
group by 1
order by 2 desc;

-- Total layoffs per year, sorted by year (descending)
select year(`date`), sum(total_laid_off)
from layoffs_Staging2
group by 1
order by 1 desc;

select stage, year(`date`), sum(total_laid_off)
from layoffs_Staging2
group by 1, 2
order by 2 desc;


-- Rolling total layoffs progression by month
with rolling_total as
(select substring(`date`, 1, 7) as `month`, sum(total_laid_off) as total_rid_off
from layoffs_Staging2
where substring(`date`, 1, 7) is not null
group by 1
order by 1)
select `month`, total_rid_off, 
sum(total_rid_off) over(
		order by `month`
	) as cumulative_sum_by_months
from rolling_total;




-- Top 5 companies with the highest layoffs per year
with company_year (company, `year`, total_rid_off) 
as (
select company, year(`date`) as `year`, sum(total_laid_off) as total_rid_off
from layoffs_Staging2
group by 1,2)
, company_year_rank as(
select *, dense_rank() over(
		partition by `year` order by total_rid_off desc
        ) as ranking
from company_year
where `year` is not null)
select * from company_year_rank
where ranking <=5;


-- Top 5 industries with the highest layoffs per month in each year
with industry_year (industry, `year_month`, total_rid_off) 
as (
select industry, substring(`date`, 1, 7) as `year_month`, sum(total_laid_off) as total_rid_off
from layoffs_Staging2
group by 1,2)
, industry_year_rank as(
select *, dense_rank() over(
		partition by `year_month` order by total_rid_off desc
        ) as ranking
from industry_year
where `year_month` is not null)
select * from industry_year_rank
where ranking <=5;




        
        