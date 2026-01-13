-- create table
DROP TABLE IF EXISTS  retail_sales;
CREATE TABLE  retail_sales
 ( 
	 transactions_id INT PRIMARY KEY,
	 sale_date DATE,
	 sale_time TIME,
	 customer_id INT,
	 gender VARCHAR(10),
	 age INT,
	 category VARCHAR(20),
	 quantity INT,
	 price_per_unit FLOAT,
	 cogs FLOAT,
	 total_sale FLOAT
  );

-- 
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;

-- see first 5 rows 
SELECT * FROM retail_sales
LIMIT 5;

-- get total length of the dataset
SELECT 
	COUNT(*)
FROM retail_sales;

-- Data cleaning
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    category IS NULL
    OR
    quantity iS NULL
    OR
    gender IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

    
-- DATA Exploration

-- How many sales records and unique customers do we have?

SELECT COUNT(*) as total_sales FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales;

-- How many unique categories do we have?

SELECT COUNT(DISTINCT category) FROM retail_sales;

-- Data Analysis and Exploration of Business Problems

-- Q1. All columns for sales from november 5 2022
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Retrieve all transactions from 'Clothing' category and the quanitty sold when its more than 10 in Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	  AND
      DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
      AND 
      quantity >=4;
      
-- Q3. Calculate total_sales for each category
SELECT category, 
		SUM(total_sale) AS total_sales,
        COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

-- Q4. Average age of customers from beauty category
SELECT category, ROUND(AVG(age),0) as avg_age
FROM retail_sales
WHERE category='Beauty';

-- Q5. All transactions where total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale>1000;

-- Q6. Total transactions made by each gender in each category
SELECT category,
	   gender, 
	   COUNT(transactionS_id) as total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

-- Q7. Calculate average sales for each month. Find the best selling month in each year

SELECT *
FROM (
	SELECT year,
		   month,
		   avg_sales,
		   RANK() OVER(PARTITION BY year ORDER BY avg_sales DESC) AS sales_rank
	FROM (
	SELECT DATE_FORMAT(sale_date, '%Y') as year,
		   DATE_FORMAT(sale_date, '%m') as month,
		   ROUND(AVG(total_sale),2) as avg_sales
	FROM retail_sales
	GROUP BY 1,2
		 ) AS t1
	) AS t2
WHERE sales_rank=1;

-- Q8. Find the top 5 customers based on the highest total sales
SELECT customer_id,
	   SUM(total_sale) as net_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY net_sale DESC
LIMIT 5;

-- Q9. Find the number of unique customers who purchased items from each category
SELECT COUNT(DISTINCT customer_id),
	   category
FROM retail_sales
GROUP BY 2;

-- Find customers who purchased from all 3 categories
SELECT customer_id
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(DISTINCT category) = 3; 

-- Q10. Create each shift and the number of orders (Example: Morning <12, Afternoon between 12-17,  Evening >17)
SELECT *,
	CASE
    WHEN HOUR(sale_time) <12 THEN 'Morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening' 
    END AS shift,
    COUNT(transactionS_id) as num_of_orders
FROM retail_sales
GROUP BY shift


-- End of practice project 1
	






