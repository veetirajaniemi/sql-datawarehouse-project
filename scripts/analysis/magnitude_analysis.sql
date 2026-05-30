/*
===============================================
Doing magnitude analysis
===============================================

Script purpose:
	This script does a basic magnitude analysis for the data to get valuable insights
	from the data measures. 

Usage: The gold layer must be created before this analysis. 
*/

-- Total customers
SELECT
	country,
	COUNT(DISTINCT customer_key) total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC

SELECT
	gender,
	COUNT(DISTINCT customer_key) total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC

-- Total products
SELECT
	p.category,
	COUNT(DISTINCT p.product_key) total_products,
	AVG(p.cost) average_cost,
	SUM(s.sales_amount) total_revenue
FROM gold.dim_products AS p
LEFT JOIN gold.fact_sales AS s
ON p.product_number = s.product_key
GROUP BY category
ORDER BY total_revenue DESC

-- Revenue per customer
SELECT TOP 10
	c.customer_key customer_key,
	c.first_name + ' ' + c.last_name customer_name,
	SUM(s.sales_amount) total_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name + ' ' + c.last_name
ORDER BY total_sales DESC

-- Sold items across countries
SELECT
	c.country,
	SUM(s.quantity) products_sold
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.country
ORDER BY products_sold DESC

