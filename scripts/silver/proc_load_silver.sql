/*
===============================================
Loading data into the silver layer tables.
===============================================

Script purpose:
	This stored procedure inserts data into the silver layer tables. If
	data exists, the tables are truncated. 

Parameters:
	None

Usage example:
	EXEC silver.load_silver
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_time_all DATETIME;
	BEGIN TRY
		PRINT '=================================';
		PRINT 'Loading the silver layer!';
		PRINT '=================================';

		PRINT '---------------------------------';
		PRINT 'Loading CRM tables';
		PRINT '---------------------------------';

		SET @start_time = GETDATE();
		SET @start_time_all = GETDATE();
		PRINT '>> Truncating table silver.crm_cst_info'
		TRUNCATE TABLE silver.crm_cst_info;

		PRINT '>> Inserting data into silver.crm_cst_info'
		INSERT INTO silver.crm_cst_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date )
		SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE WHEN TRIM(UPPER(cst_marital_status)) = 'S' THEN 'Single'
				 WHEN TRIM(UPPER(cst_marital_status)) = 'M' THEN 'Married'
				 ELSE 'n/a'
			END cst_marital_status,
			CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				 ELSE 'n/a'
			END cst_gndr,
			cst_create_date
		FROM(
			SELECT
				*,
				ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last 
			FROM bronze.crm_cst_info
			WHERE cst_id IS NOT NULL
			)t WHERE flag_last = 1

		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating table silver.crm_prd_info'
		TRUNCATE TABLE silver.crm_prd_info;

		PRINT '>> Inserting data into silver.crm_prd_info'
		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
			prd_nm,
			ISNULL(prd_cost, 0) AS prd_cost,
			CASE UPPER(TRIM(prd_line))
				WHEN 'M' THEN 'Mountain'
				WHEN 'R' THEN 'Road'
				WHEN 'S' THEN 'Other Sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'n/a'
			END AS prd_line,
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(
				LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1
				AS DATE
			) AS prd_end_dt
		FROM bronze.crm_prd_info

		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating table silver.crm_sales_details'
		TRUNCATE TABLE silver.crm_sales_details;

		PRINT '>> Inserting data into silver.crm_sales_details'
		INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cst_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		) 
		SELECT
			sls_ord_num,
			sls_prd_key,
			sls_cst_id,
			CASE
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END AS sls_order_dt,
			CASE
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END AS sls_ship_dt,
			CASE
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END AS sls_due_dt,
			CASE 
				WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales
			END AS sls_sales,
			sls_quantity,
			CASE
				WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
				ELSE sls_price
			END AS sls_price
		FROM bronze.crm_sales_details
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '---------------------------------';
		PRINT 'Loading ERP tables';
		PRINT '---------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating table silver.erp_cst_info'
		TRUNCATE TABLE silver.erp_cst_info;

		PRINT '>> Inserting data into silver.erp_cst_info'
		INSERT INTO silver.erp_cst_info (cst_id, cst_bd_dt, cst_gender)
		SELECT
			CASE WHEN cst_id LIKE 'NAS%' THEN SUBSTRING(cst_id, 4, LEN(cst_id))
				 ELSE cst_id
			END AS cst_id,
			CASE WHEN cst_bd_dt > GETDATE() THEN NULL
				 ELSE cst_bd_dt
			END AS cst_bd_dt,
			CASE WHEN UPPER(TRIM(cst_gender)) IN ('F', 'FEMALE') THEN 'Female'
				 WHEN UPPER(TRIM(cst_gender)) IN ('M', 'MALE') THEN 'Male'
				 ELSE 'n/a'
			END AS cst_gender
		FROM bronze.erp_cst_info
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating table silver.erp_loc_info'
		TRUNCATE TABLE silver.erp_loc_info;

		PRINT '>> Inserting data into silver.erp_loc_info'
		INSERT INTO silver.erp_loc_info (cst_id, cst_country)
		SELECT 
			REPLACE(cst_id, '-', '') cst_id,
			CASE WHEN TRIM(cst_country) = 'DE' THEN 'Germany'
				 WHEN TRIM(cst_country) IN ('USA', 'US') THEN 'United States'
				 WHEN TRIM(cst_country) = '' OR cst_country IS NULL THEN 'n/a'
				 ELSE TRIM(cst_country)
			END AS cst_country
		FROM bronze.erp_loc_info
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating table silver.erp_prd_info'
		TRUNCATE TABLE silver.erp_prd_info;

		PRINT '>> Inserting data into silver.erp_prd_info'
		INSERT INTO silver.erp_prd_info (prd_id, prd_cat, prd_subcat, prd_maintenance)
		SELECT
			prd_id,
			prd_cat,
			prd_subcat,
			prd_maintenance
		FROM bronze.erp_prd_info
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '=================================='
		PRINT 'Loading silver layer completed'
		PRINT '>> Full silver layer load duration: ' + CAST(DATEDIFF(second, @start_time_all, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '=================================='
	END TRY
	BEGIN CATCH
		PRINT '=================================='
		PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER'
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error state: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=================================='
	END CATCH
END
