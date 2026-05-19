/*
===============================================
Creating Database and Schemas
===============================================

Script purpose:
	This script creates a new database 'DataWarehouse' after checking if it already exists.
	In this case, it's dropped and recreated. Also three schemas are set up.

WARNING:
	Running the script will drop the entire 'DataWarehouse' database if it exists!
	All data will be deleted. Proceed with caution and ensure backups before running.
*/


USE master;
GO

-- Drop and recreate database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Create database
CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;
GO

-- Create schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;