/*
===============================================
Doing ranking analysis
===============================================

Script purpose:
	This script does a basic ranking analysis to get different insights from 
	the data based on rankings. 

Usage: The gold layer must be created before this analysis. 
*/

-- 5 products with the highest and lowest revenue

SELECT TOP 5
	p.product_name product_name,
	SUM(s.sales_amount) total_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_number
GROUP BY p.product_name
ORDER BY total_sales DESC

SELECT TOP 5
	p.product_name product_name,
	SUM(s.sales_amount) total_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_number
GROUP BY p.product_name
ORDER BY total_sales ASC


-- Top 10 customers with the highest revenue

SELECT 
	customer_key,
	total_sales,
	rank_sales
FROM(
	SELECT 
		customer_key,
		SUM(sales_amount) total_sales,
		RANK() OVER(ORDER BY SUM(sales_amount) DESC) rank_sales
	FROM gold.fact_sales
	GROUP BY customer_key)t
WHERE rank_sales < 6
