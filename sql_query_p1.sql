-- SQL Retail Sales Analysis - P1

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);
SELECT * FROM retail_sales
LIMIT 10;

SELECT
	COUNT(*)
FROM retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

--
DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many unique customers we have
SELECT COUNT(DISTINCT customer_id) as unique_customers FROM retail_sales

SELECT COUNT(DISTINCT category) as unique_category FROM retail_sales

SELECT DISTINCT category FROM retail_sales;

-- Data Analysis 
-- 1: All columns for sales made on '2022-11-05'
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
--2: retrieves all transactions where category is clothing and the quantity sold is more than or equal 4 in the month of NOV-2022
SELECT 
	category,
	SUM(quantiy)
FROM retail_sales
	WHERE category = 'Clothing' AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' AND quantiy >= 4
GROUP by category
--3: Calculate total sales for each category

SELECT
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP by category

--4: Average age of customers who purchased items from 'Beauty' category

SELECT
	ROUND(AVG(age), 2) as average_age
FROM retail_sales
WHERE category = 'Beauty'

--5: All transactions where the total_sale is greater than 1000. 

SELECT * FROM retail_sales WHERE total_sale > 1000

--6: Total number of transactions made by each gender in each category
SELECT
category, 
gender, 
COUNT(transactions_id) as transactions
FROM retail_sales
GROUP by category, gender
ORDER BY category

--7: Average sales per month and best selling month in each year
SELECT * FROM (
	SELECT
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as average_sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
	FROM retail_sales
	GROUP by year, month
	ORDER by year, average_sales DESC
) as t1
WHERE rank = 1

--8: top 5 customers based on highest total sales

SELECT
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5

--9: number of unique customers who purchased items from each category

SELECT
	category,
	COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP by category

--10: number of orders by "shifts" (time blocks)
SELECT 
	shift,
	COUNT(shift) as total_orders
FROM
(
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END	as shift
	FROM retail_sales
)
GROUP by shift

--project end
