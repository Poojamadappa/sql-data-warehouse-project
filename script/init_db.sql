/* CREATE DATABASE AND SCHEMAS
Script purpose:
the script creates a new database called 'datawarehouse' , and also it creates a three schemas called 'bronze', 'silver' and 
'gold'
*/


--Connect to master database
USE master;

--create and use new database
Create database DataWarehouse;
use DataWarehouse;

--create bronze, silver and gold schema 
create schema BRONZE;
create schema SILVER;
create schema GOLD;
