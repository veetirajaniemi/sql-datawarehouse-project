/*
===============================================
Exploring data
===============================================

Script purpose:
	This script explores data by looking into basic information such as tables and columns.
	It explores some dates and measures, generating a simple report with them. 

Usage: The gold layer must be created before this analysis. 
*/

-- Some basic info...
SELECT * FROM INFORMATION_SCHEMA.TABLES

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'

-- Dimensions
SELECT DISTINCT country FROM gold.dim_customers

SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products
ORDER BY 1, 2, 3

-- Dates

-- First and last orders, order range
SELECT 
	MIN(order_date) first_order, 
	MAX(order_date) last_order,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) order_months
FROM gold.fact_sales

-- Youngest and oldest customer ages
SELECT
	DATEDIFF(year, MAX(birthdate), GETDATE()) youngest_customer,
	DATEDIFF(year, MIN(birthdate), GETDATE()) oldest_customer
FROM gold.dim_customers


-- Some measuring :-)

-- Total sales amounts
SELECT
	SUM(sales_amount) total_sales,
	SUM(quantity) items_sold,
	SUM(sales_amount) / SUM(quantity) average_price,
	COUNT(DISTINCT order_number) total_orders
FROM gold.fact_sales

-- Total product amounts
SELECT 
	COUNT(DISTINCT product_id) total_products
FROM gold.dim_products

-- Total customer amounts
SELECT 
	COUNT(DISTINCT customer_id) total_customers
FROM gold.dim_customers

SELECT 
	COUNT(DISTINCT customer_key) total_customers_ordered
FROM gold.fact_sales


-- Generating a report
SELECT 'Total sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total items sold' AS measure_name, SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average price' AS measure_name, SUM(sales_amount) / SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total products' AS measure_name, COUNT(DISTINCT product_id) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total customers' AS measure_name, COUNT(DISTINCT customer_id) AS measure_value FROM gold.dim_customers