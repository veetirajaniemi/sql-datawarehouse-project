/*
===============================================
DDL: Creating bronze tables
===============================================

Script purpose:
	This script creates tables for the bronze layer and drops the existing tables
	if they exist.
*/

IF OBJECT_ID('bronze.crm_cst_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cst_info;
CREATE TABLE bronze.crm_cst_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cst_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

IF OBJECT_ID('bronze.erp_cst_info', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cst_info;
CREATE TABLE bronze.erp_cst_info (
	cst_id NVARCHAR(50),
	cst_bd_dt DATE,
	cst_gender NVARCHAR(10)
);

IF OBJECT_ID('bronze.erp_loc_info', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_info;
CREATE TABLE bronze.erp_loc_info (
	cst_id NVARCHAR(50),
	cst_country NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.erp_prd_info;
CREATE TABLE bronze.erp_prd_info (
	prd_id NVARCHAR(50),
	prd_cat NVARCHAR(50),
	prd_subcat NVARCHAR(50),
	prd_maintenance NVARCHAR(10)
);

