/* 
Stored Procedure: Load Bronze Layer (Source -> Bronze

Script Purpose: this stored procedure loads data into the bronze schema for external CSV files.
the following actions are:
  - truncated the bronze tables before loading the data
  - Uses the 'BULK INSERT' command to load data from csv files to bronze tables.
  - calculates the total load duration of bronze layer

Usage example: Execute BRONZE.LOAD_BRONZE;
*/

CREATE OR ALTER PROCEDURE BRONZE.LOAD_BRONZE AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time datetime, @batch_end_time datetime;
    BEGIN TRY
        set @batch_start_time = getdate();
        PRINT '_____________________________________';
        PRINT 'lOADING A BRONZE LAYER';
        PRINT '_____________________________________';

        PRINT '______________________________________'
        PRINT 'LOADING CRM TABLES';
         PRINT '______________________________________'

        --customer data load

        set @start_time = GETDATE();
        print '>> truncating tables: BRONZE.crm_cust_info1';
        TRUNCATE TABLE BRONZE.crm_cust_info1;
        print '>> inserting data into tables: BRONZE.crm_cust_info1';
        BULK INSERT BRONZE.crm_cust_info1
        from 'C:\Users\Pooja Madappa\Downloads\data warehouse project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        with ( 
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
        );
        set @end_time = GETDATE();
        print ' >> Load duration : ' +cast(datediff(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
        SELECT COUNT(*) 
        FROM BRONZE.crm_cust_info1;
        

        ---prd data load
        set @start_time = GETDATE();
        print '>> truncating tables: BRONZE.crm_prd_info';
        TRUNCATE TABLE BRONZE.crm_prd_info;
        print '>> inserting data into: BRONZE.crm_prd_info';
        BULK INSERT BRONZE.crm_prd_info
        from 'C:\Users\Pooja Madappa\Downloads\data warehouse project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        with ( 
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
        );
        set @end_time = GETDATE();
        print ' >> Load duration : ' +cast(datediff(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
        SELECT COUNT(*) 
        FROM BRONZE.crm_prd_info;

        --sales data load 
        set @start_time = GETDATE();
        print '>> truncating tables: BRONZE.crm_sales_details';
        TRUNCATE TABLE BRONZE.crm_sales_details;
        print '>> inserting data into: BRONZE.crm_sales_details';
        BULK INSERT BRONZE.crm_sales_details
        from 'C:\Users\Pooja Madappa\Downloads\data warehouse project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        with ( 
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
        );
        set @end_time = GETDATE();
        print ' >> Load duration : ' +cast(datediff(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
        SELECT COUNT(*) 
        FROM BRONZE.crm_sales_details;

        PRINT '-------------------------------------'
        PRINT 'LOAD ERP TABLES';
        PRINT '-------------------------------------'
        --load erp customer data

        set @start_time = GETDATE();
        print '>> truncating tables: BRONZE.erp_cust_az12';
        TRUNCATE TABLE BRONZE.erp_cust_az12;
         print '>> inserting data into: BRONZE.erp_cust_az12';
        BULK INSERT BRONZE.erp_cust_az12
        from 'C:\Users\Pooja Madappa\Downloads\data warehouse project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        with ( 
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
        );
        set @end_time = GETDATE();
        print ' >> Load duration : ' +cast(datediff(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
        SELECT COUNT(*) 
        FROM BRONZE.erp_cust_az12;

        ---load erp loc data

        set @start_time = GETDATE();
        print '>> truncating tables: BRONZE.erp_loc_a101';
        TRUNCATE TABLE BRONZE.erp_loc_a101;
        print '>> inserting data into: BRONZE.erp_loc_a101';
        BULK INSERT BRONZE.erp_loc_a101
        from 'C:\Users\Pooja Madappa\Downloads\data warehouse project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        with ( 
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
        );
        set @end_time = GETDATE();
        print ' >> Load duration : ' +cast(datediff(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
        SELECT COUNT(*) 
        FROM BRONZE.erp_loc_a101;


        ---erp px load 
        set @start_time = GETDATE();
        print '>> truncating tables: BRONZE.erp_px_cat_g1v2';
        TRUNCATE TABLE BRONZE.erp_px_cat_g1v2;
        print '>> inserting data into: BRONZE.erp_px_cat_g1v2';
        BULK INSERT BRONZE.erp_px_cat_g1v2
        from 'C:\Users\Pooja Madappa\Downloads\data warehouse project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        with ( 
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
        );
        set @end_time = GETDATE();
        print ' >> Load duration : ' +cast(datediff(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
        SELECT COUNT(*) 
        FROM BRONZE.erp_px_cat_g1v2;

        set @batch_end_time = GETDATE();
        print '____________________________'
        print 'Loading bronze layer is completed';
        print ' >> Total Load duration : ' +cast(datediff(second,@start_time, @end_time) AS NVARCHAR) + 'seconds';
        print '__________________________________'
    END TRY
    BEGIN CATCH 
        PRINT '-----------------------------------------------------'
        PRINT 'ERROR OCCURED DURING BRONZE LAYER'
        PRINT 'Error Message' + ERROR_MESSAGE();
        PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '-----------------------------------------------------'
    END CATCH
END;
