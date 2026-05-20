/*
===============================================
Loading data into the bronze layer tables.
===============================================

Script purpose:
	This script uses bulk load for loading data into the bronze layer tables. If
	data exists, the tables are truncated. 
*/


-- EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_time_all DATETIME;
	BEGIN TRY
		PRINT '=================================';
		PRINT 'Loading the bronze layer!';
		PRINT '=================================';

		PRINT '---------------------------------';
		PRINT 'Loading CRM tables';
		PRINT '---------------------------------';

		SET @start_time = GETDATE();
		SET @start_time_all = GETDATE();
		PRINT '>> Truncating table bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting data into bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\veeti\OneDrive - LUT University\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating table bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting data into bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\veeti\OneDrive - LUT University\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating table bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting data into bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\veeti\OneDrive - LUT University\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '---------------------------------';
		PRINT 'Loading ERP tables';
		PRINT '---------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating table bronze.erp_cust_info'
		TRUNCATE TABLE bronze.erp_cust_info;

		PRINT '>> Inserting data into bronze.erp_cust_info'
		BULK INSERT bronze.erp_cust_info
		FROM 'C:\Users\veeti\OneDrive - LUT University\SQL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating table bronze.erp_loc_info'
		TRUNCATE TABLE bronze.erp_loc_info;

		PRINT '>> Inserting data into bronze.erp_loc_info'
		BULK INSERT bronze.erp_loc_info
		FROM 'C:\Users\veeti\OneDrive - LUT University\SQL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating table bronze.erp_prod_info'
		TRUNCATE TABLE bronze.erp_prod_info;

		PRINT '>> Inserting data into bronze.erp_prod_info'
		BULK INSERT bronze.erp_prod_info
		FROM 'C:\Users\veeti\OneDrive - LUT University\SQL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '=================================='
		PRINT 'Loading bronze layer completed'
		PRINT '>> Full bronze layer load duration: ' + CAST(DATEDIFF(second, @start_time_all, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '=================================='
	END TRY
	BEGIN CATCH
		PRINT '=================================='
		PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER'
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error state: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=================================='
	END CATCH
END
