/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

If OBJECT_ID ('SILVER.crm_cust_info1' , 'U') IS NOT NULL
	DROP TABLE SILVER.crm_cust_info1;

Create table SILVER.crm_cust_info1(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);


If OBJECT_ID ('SILVER.crm_prd_info' , 'U') IS NOT NULL
	DROP TABLE SILVER.crm_prd_info;

CREATE table SILVER.crm_prd_info(
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt date,
	prd_end_dt Date,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
	);

If OBJECT_ID ('SILVER.crm_sales_details' , 'U') IS NOT NULL
	DROP TABLE SILVER.crm_sales_details;

CREATE TABLE SILVER.crm_sales_details(
	sls_ord_no NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_ord_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

If OBJECT_ID ('SILVER.erp_cust_az12' , 'U') IS NOT NULL
	DROP TABLE SILVER.erp_cust_az12;

CREATE TABLE SILVER.erp_cust_az12(
	cid NVARCHAR(50),
	bdate date,
	gen NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

If OBJECT_ID ('SILVER.erp_loc_a101' , 'U') IS NOT NULL
	DROP TABLE SILVER.erp_loc_a101;

create table SILVER.erp_loc_a101(
	cid NVARCHAR(50),
	cntry NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

If OBJECT_ID ('SILVER.erp_px_cat_g1v2' , 'U') IS NOT NULL
	DROP TABLE SILVER.erp_px_cat_g1v2;

create table SILVER.erp_px_cat_g1v2(
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintainence NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
