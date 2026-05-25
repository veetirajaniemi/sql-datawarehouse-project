/*
===============================================
DDL: Creating silver tables
===============================================

Script purpose:
	This script creates tables for the silver layer and drops the existing tables
	if they exist.
*/

IF OBJECT_ID('silver.crm_cst_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cst_info;
CREATE TABLE silver.crm_cst_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cst_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.erp_cst_info', 'U') IS NOT NULL
	DROP TABLE silver.erp_cst_info;
CREATE TABLE silver.erp_cst_info (
	cst_id NVARCHAR(50),
	cst_bd_dt DATE,
	cst_gender NVARCHAR(10),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.erp_loc_info', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_info;
CREATE TABLE silver.erp_loc_info (
	cst_id NVARCHAR(50),
	cst_country NVARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.erp_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.erp_prd_info;
CREATE TABLE silver.erp_prd_info (
	prd_id NVARCHAR(50),
	prd_cat NVARCHAR(50),
	prd_subcat NVARCHAR(50),
	prd_maintenance NVARCHAR(10),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);


