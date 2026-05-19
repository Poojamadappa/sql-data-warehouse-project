/*
===============================================================================
DDL Scripts: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold Layer represents the final dimension and fact tables (star schema) 

    Each view performs transformations and combines data from the silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
*/

-- ===========================================================================
-- Create Dimension Table: gold.dim_customers
-- ===========================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers;
GO
CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	la.cntry as country,
	ci.cst_material_status as marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the master for gender info
		else coalesce (ca.gen, 'n/a')
    END AS gender,
	ca.bdate as birthdate,
	ci.cst_create_date as create_Date
FROM SILVER.CRM_CUST_INFO1 ci
LEFT JOIN silver.erp_cust_az12 ca
ON		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
on		ci.cst_key = la.cid
GO

-- ===========================================================================
-- Create Dimension Table: gold.dim_products
-- ===========================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products;
GO


CREATE VIEW gold.dim_products as
SELECT 
	row_Number() over (order by pn.prd_start_dt, pn.prd_key) as product_key,
	pn.prd_id AS product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintainence as maintenance,
	pn.prd_cost as cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date
from silver.crm_prd_info pn
left join silver.erp_px_cat_g1v2 pc
on pn.cat_id = pc.id
where prd_end_dt is null ---filter historical data

GO

-- ===========================================================================
-- Create Dimension Table: gold.fact_sales
-- ===========================================================================
  
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO

create view gold.fact_Sales as

select
sd.sls_ord_no as order_number,
pr.product_key,
cu.customer_key,
sd.sls_ship_dt as order_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity,
sd.sls_price
from silver.crm_sales_details sd
left join gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers cu
on sd.sls_cust_id = cu.customer_id
GO
