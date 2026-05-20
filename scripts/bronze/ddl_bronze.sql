
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
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
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

IF OBJECT_ID('bronze.erp_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_info;
CREATE TABLE bronze.erp_cust_info (
	cust_id NVARCHAR(50),
	cust_bd_dt DATE,
	cust_gender NVARCHAR(10)
);

IF OBJECT_ID('bronze.erp_loc_info', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_info;
CREATE TABLE bronze.erp_loc_info (
	cust_id NVARCHAR(50),
	cust_country NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_prod_info', 'U') IS NOT NULL
	DROP TABLE bronze.erp_prod_info;
CREATE TABLE bronze.erp_prod_info (
	prod_id NVARCHAR(50),
	prod_cat NVARCHAR(50),
	prod_subcat NVARCHAR(50),
	prod_maintenance NVARCHAR(10)
);

