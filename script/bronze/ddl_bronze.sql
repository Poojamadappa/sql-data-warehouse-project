/* DDl Script: create bronze tables
This script creates tables in the  bronze schema, dropping the existing tables
if thet already exist.*/

If OBJECT_ID ('BRONZE.crm_cust_info1' , 'U') IS NOT NULL
	DROP TABLE BRONZE.crm_cust_info1;

Create table BRONZE.crm_cust_info1(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);


If OBJECT_ID ('BRONZE.crm_prd_info' , 'U') IS NOT NULL
	DROP TABLE BRONZE.crm_prd_info;

CREATE table BRONZE.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt date,
	prd_end_dt Date
	);

If OBJECT_ID ('BRONZE.crm_sales_details' , 'U') IS NOT NULL
	DROP TABLE BRONZE.crm_sales_details;

CREATE TABLE BRONZE.crm_sales_details(
	sls_ord_no NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_ord_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

If OBJECT_ID ('BRONZE.erp_cust_az12' , 'U') IS NOT NULL
	DROP TABLE BRONZE.erp_cust_az12;

CREATE TABLE BRONZE.erp_cust_az12(
	cid NVARCHAR(50),
	bdate date,
	gen NVARCHAR(50)
);

If OBJECT_ID ('BRONZE.erp_loc_a101' , 'U') IS NOT NULL
	DROP TABLE BRONZE.erp_loc_a101;

create table BRONZE.erp_loc_a101(
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
);

If OBJECT_ID ('BRONZE.erp_px_cat_g1v2' , 'U') IS NOT NULL
	DROP TABLE BRONZE.erp_px_cat_g1v2;

create table BRONZE.erp_px_cat_g1v2(
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintainence NVARCHAR(50)
);
