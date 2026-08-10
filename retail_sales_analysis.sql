create database sql_project1;
use sql_project1;

-- Create table

create table retail_sales (
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(25),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

select * from retail_sales;

SELECT COUNT(*) AS total_rows
FROM retail_sales;

-- Checking Null Values

select * from retail_sales
where transactions_id is null;

select * from retail_sales
where sale_date is null;

select * from retail_sales
where
     transactions_id is null
     OR
     sale_date is null
     OR
     sale_time is null
     OR
     customer_id is null
     OR
     gender is null
     OR
     category is null
     OR
     quantiy is null
     OR
     price_per_unit is null
     OR
     cogs is null
     OR
     total_sale is null;

delete from retail_sales
where
     transactions_id is null
     OR
     sale_date is null
     OR
     sale_time is null
     OR
     customer_id is null
     OR
     gender is null
     OR
     category is null
     OR
     quantiy is null
     OR
     price_per_unit is null
     OR
     cogs is null
     OR
     total_sale is null;
     
     set sql_safe_updates=0;
     
     
     -- Data Exploration
     
     -- How many sales we have
SELECT COUNT(*) AS total_sales
FROM retail_sales;

-- How many unique customers we have
SELECT COUNT(distinct customer_id) AS unique_customers
FROM retail_sales;

select distinct category from retail_sales;


--                        Data Analysis and Business Key Problems and Answer

-- Query to find the sales made on a specific date

select * from retail_sales
where sale_date='2022-11-05';


-- query to retrieve all transactions where the category is Clothing and the quantity sold is greater than or equal to 4 in November 2022


SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy >=4
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
  
  -- SQL query to calculate the total sales (total_sale) for each category.
  
  select category,sum(total_sale) as total_sales,
  count(*) as total_orders
  from retail_sales
  group by category;
  
  -- SQL query to find the average age of customers who purchased items from the Beauty category.
  
  select round(avg(age),2)
  from retail_sales
  where category= 'Beauty';
  
  
  -- SQL query to find all transactions where the total sale is greater than 1,000.
  
  
  select * 
  from retail_sales
  where total_sale>1000;
  
  -- SQL query to calculate the total number of transactions made by each gender in each category
  
  select category,gender,count(*) as transaction
  from retail_sales
  group by category, gender
  order by 1;
  
  
  -- query to calculate the average sales for each month and identify the best-selling month for each year.
  
SELECT year, month, average_sale
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS average_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS ranking
    FROM retail_sales
    GROUP BY 1, 2
) AS t
WHERE ranking = 1
ORDER BY year, month;



-- Write a SQL query to find the top 5 customers based on their highest total sales.
select  customer_id,sum(total_sale) as highest_sales
from retail_sales
group by customer_id
order by sum(total_sale) desc
limit 5;


-- SQL query to find the number of unique customers who purchased items from each category

select category, count(distinct customer_id) as unique_customers from retail_sales
group by category;


-- SQL query to categorize sales into shifts and calculate the number of orders in each shift: Morning (≤ 12:00), Afternoon (> 12:00 and ≤ 17:00), and Evening (> 17:00)
WITH hourly_sales AS
(
    SELECT *,
           CASE
               WHEN HOUR(sale_time) < 12 THEN 'Morning'
               WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
)
SELECT shift,
       COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;


-- Query to find Monthly revenue trend


SELECT
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    ROUND(SUM(total_sale), 2) AS total_sales
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY year, month;



-- Query to find Most popular category by quantity


SELECT
    category,
    SUM(quantiy) AS total_quantity_sold
FROM retail_sales
GROUP BY category
ORDER BY total_quantity_sold DESC;


-- Query to find the most profitable product category


SELECT
    category,
    ROUND(SUM(total_sale), 2) AS revenue,
    ROUND(SUM(cogs), 2) AS total_cogs,
    ROUND(SUM(total_sale - cogs), 2) AS profit
FROM retail_sales
GROUP BY category
ORDER BY profit DESC;
select * from retail_sales;

----- end 