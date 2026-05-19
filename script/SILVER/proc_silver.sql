/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

create or alter procedure SILVER.LOAD_SILVER AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time datetime, @batch_end_time datetime;
	BEGIN TRY
		set @batch_start_time = getdate();
		PRINT '_____________________________________';
		PRINT 'lOADING A SILVER LAYER';
		PRINT '_____________________________________';

		PRINT '______________________________________'
		PRINT 'LOADING CRM TABLES';
		PRINT '______________________________________'

		set @start_time = GETDATE();
		print '>> truncating tables: SILVER.crm_cust_info1';

		print '>> Truncating Table: silver.crm_cust_info1';
		truncate table silver.crm_cust_info1;
		print '>> inserting data into: silver.crm_cust_info1';
		insert into silver.crm_cust_info1(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_material_status,
			cst_gndr,
			cst_create_date)

		select cst_id, cst_key,
		trim(cst_firstname) As cst_firstname,
		Trim(cst_lastname) as cst_lastname,
		case when upper(trim(cst_material_status)) = 'S' then 'Single'
			when upper(trim(cst_material_status)) = 'M' then 'Married'
			else 'n/a'
		end  as cst_marital_status,
		case when upper(trim(cst_gndr)) = 'F' then 'Female'
			when upper(trim(cst_gndr)) = 'M' then 'Male'
			else 'n/a'
		end cst_gndr,
		cst_create_date
		from (

			SELECT *,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY CST_CREATE_DATE DESC) AS flag_last
			FROM BRONZE.CRM_CUST_INFO1
			where cst_id is not null
		)
		t where flag_last = 1;
		set @end_time = GETDATE();
		print ' >> Load duration : ' +cast(datediff(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';


		set @start_time = GETDATE();
		print '>> Truncating Table: SILVER.crm_prd_info';
		truncate table SILVER.crm_prd_info;
		print '>> inserting data into: SILVER.crm_prd_info';

		insert into SILVER.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
		)

		select prd_id,
		replace(substring(prd_key,1,5), '-', '_') as cat_id,
		substring(prd_key, 7, len(prd_key)) as prd_key,
		prd_nm,
		isnull(prd_cost,0) as prd_cost,
		case upper(trim(prd_line))
			when 'M' then 'Mountain'
			when 'R' then 'Road'
			when 'S' then 'Other Sales'
			when 'T' then 'Touring'
			Else 'n/a'
		end as prd_line,
		cast(prd_start_dt as date) as prd_start_dt, 
		CAST(DATEADD(DAY,-1, LEAD(prd_start_dt) over (partition by prd_key order by prd_start_dt))as date)as prd_end_dt
		from BRONZE.crm_prd_info;
		set @end_time = GETDATE();
		print ' >> Load duration : ' +cast(datediff(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';


		set @start_time = GETDATE();
		print '>> Truncating Table: SILVER.crm_sales_details';
		truncate table SILVER.crm_sales_details;
		print '>> inserting data into: SILVER.crm_sales_details';

		INSERT INTO SILVER.crm_sales_details (
			sls_ord_no,
			sls_prd_key,
			sls_cust_id,
			sls_ord_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price 
		)
		select 
			sls_ord_no,
			sls_prd_key,
			sls_cust_id,
			CASE WHEN sls_ord_dt = 0 OR LEN(sls_ord_dt) != 8 THEN NULL
				else cast(cast(sls_ord_dt As Varchar)as Date)
			End as sls_ord_dt,
			CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				else cast(cast(sls_ship_dt As Varchar)as Date)
			End as sls_ship_dt,
			CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
				else cast(cast(sls_due_dt As Varchar)as Date)
			End as sls_due_dt,
			Case when sls_sales Is null or sls_Sales <=0 or sls_sales != sls_quantity * ABS(sls_price)
					then sls_quantity * ABS(sls_price)
				else sls_sales
			end as sls_sales,
			sls_quantity,
			case when sls_price is null or sls_price <= 0
					then sls_sales / nullif(sls_quantity,0)
				else sls_price
			end as sls_price
		from bronze.crm_sales_details;
		set @end_time = GETDATE();
		print ' >> Load duration : ' +cast(datediff(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';

	
		set @start_time = GETDATE();
		print '>> Truncating Table: silver.erp_cust_az12';
		truncate table silver.erp_cust_az12;
		print '>> inserting data into: silver.erp_cust_az12';
		Insert into silver.erp_cust_az12 (cid, bdate, gen)

		SELECT 
		CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
			ELSE cid
		END AS cid,
		CASE WHEN bdate > GETDATE() THEN NULL	
			ELSE bdate
		END AS bdate,
		CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			WHEN UPPER(TRIM(gen)) IN ('M', 'Male') THEN 'Male'
			ELSE 'n/a'
		END AS gen
		FROM bronze.erp_cust_az12;
		set @end_time = GETDATE();
		print ' >> Load duration : ' +cast(datediff(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';

		set @start_time = GETDATE();
		print '>> Truncating Table: silver.erp_loc_a101';
		truncate table silver.erp_loc_a101;
		print '>> inserting data into: silver.erp_loc_a101';

		insert into silver.erp_loc_a101
		(cid,cntry)

		select 
		replace(cid, '-', '')cid,
		case when trim(cntry) = 'DE' then 'Germany'
			WHEN TRIM (CNTRY) IN ('US', 'USA') THEN 'United States'
			when trim(cntry) = '' or cntry is null then 'n/a'
			else trim(cntry)
		end as cntry
		from bronze.erp_loc_a101;
		set @end_time = GETDATE();
		print ' >> Load duration : ' +cast(datediff(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';

		set @start_time = GETDATE();
		print '>> Truncating Table: SILVER.erp_px_cat_g1v2';
		truncate table SILVER.erp_px_cat_g1v2;
		print '>> inserting data into: SILVER.erp_px_cat_g1v2';

		Insert into SILVER.erp_px_cat_g1v2
		(id, cat, subcat, maintainence)

		select id, cat, subcat, maintainence
		from bronze.erp_px_cat_g1v2;
		set @end_time = GETDATE();
		print '____________________________'
		print 'Loading SILVER layer is completed';
		print ' >> Total Load duration : ' +cast(datediff(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
		print '__________________________________'
	END TRY
	BEGIN CATCH 
		PRINT '-----------------------------------------------------'
		PRINT 'ERROR OCCURED DURING SILVER LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '-----------------------------------------------------'
	END CATCH
END;

