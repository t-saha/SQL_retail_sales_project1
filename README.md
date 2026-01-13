# SQL_retail_sales_project1
A quick analysis of a retail sales dataset with MySQL.

**1. Database Setup
A database is created with a defined schema where the dataset will be stored.
A table 'retail_sales' is created where the data that has columns such as date, time, customer id, gender, age, etc.**

_-- create table_
```sql
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

ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;https://github.com/t-saha/SQL_retail_sales_project1/blob/main/README.md
```

**2. Data Exploration - A quick glance is taken at the dataset to check the length of the dataset and study its columns.**
```sql
_-- see first 5 rows_
SELECT * FROM retail_sales
LIMIT 5;

_-- get total length of the dataset_
SELECT 
	COUNT(*)
FROM retail_sales;

_-- How many sales records and unique customers do we have?_
SELECT COUNT(*) as total_sales FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales;

_-- How many unique categories do we have?_
SELECT COUNT(DISTINCT category) FROM retail_sales;
```

**3. Data Cleaning - The dataset is checked for null values and they are removed, if any.**
```sql
_-- Data cleaning_
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
```
    
**4. Data Analysis - Data related to monthly and yearly sales, orders, shifts are analyzed.**
_-- see first 5 rows_
_-- Q1. All columns for sales from november 5 2022_
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

_-- Q2. Retrieve all transactions from 'Clothing' category and the quanitty sold when its more than 10 in Nov-2022_
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	  AND
      DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
      AND 
      quantity >=4;
      
_-- Q3. Calculate total_sales for each category_
SELECT category, 
		SUM(total_sale) AS total_sales,
        COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

_-- Q4. Average age of customers from beauty category_
SELECT category, ROUND(AVG(age),0) as avg_age
FROM retail_sales
WHERE category='Beauty';

_-- Q5. All transactions where total_sale is greater than 1000_
SELECT *
FROM retail_sales
WHERE total_sale>1000;

_-- Q6. Total transactions made by each gender in each category_
SELECT category,
	   gender, 
	   COUNT(transactionS_id) as total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

_-- Q7. Calculate average sales for each month. Find the best selling month in each year_

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

_-- Q8. Find the top 5 customers based on the highest total sales_
SELECT customer_id,
	   SUM(total_sale) as net_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY net_sale DESC
LIMIT 5;

_-- Q9. Find the number of unique customers who purchased items from each category_
SELECT COUNT(DISTINCT customer_id),
	   category
FROM retail_sales
GROUP BY 2;

_-- Find customers who purchased from all 3 categories_
SELECT customer_id
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(DISTINCT category) = 3; 

_-- Q10. Create each shift and the number of orders (Example: Morning <12, Afternoon between 12-17,  Evening >17)_
SELECT *,
	CASE
    WHEN HOUR(sale_time) <12 THEN 'Morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening' 
    END AS shift,
    COUNT(transactionS_id) as num_of_orders
FROM retail_sales
GROUP BY shift
```


_-- End of project 1_
