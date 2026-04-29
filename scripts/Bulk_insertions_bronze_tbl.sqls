create or alter procedure bronze.load_bronze as 
begin
	
	----------------------------------------------------------------------------------------------
	truncate table bronze.crm_cust_info;
	Bulk insert bronze.crm_cust_info
	from 'C:\Users\304so\OneDrive\Desktop\ME\Data_Analyst\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	with (
		firstrow =2,
		fielDTerminator=',',
		tablock
	);

	----------------------------------------------------------------------------------------------
	truncate table bronze.crm_prd_info;
	Bulk insert bronze.crm_prd_info
	from 'C:\Users\304so\OneDrive\Desktop\ME\Data_Analyst\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	with (
		firstrow =2,
		fielDTerminator=',',
		tablock
	);

	----------------------------------------------------------------------------------------------
	truncate table bronze.crm_sales_details;
	Bulk insert bronze.crm_sales_details
	from 'C:\Users\304so\OneDrive\Desktop\ME\Data_Analyst\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	with (
		firstrow =2,
		fielDTerminator=',',
		tablock
	);

	----------------------------------------------------------------------------------------------
	truncate table bronze.erp_cust_az12;
	Bulk insert bronze.erp_cust_az12
	from 'C:\Users\304so\OneDrive\Desktop\ME\Data_Analyst\SQL\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
	with (
		firstrow =2,
		fielDTerminator=',',
		tablock
	);

	----------------------------------------------------------------------------------------------
	truncate table bronze.erp_loc_a101;
	Bulk insert bronze.erp_loc_a101
	from 'C:\Users\304so\OneDrive\Desktop\ME\Data_Analyst\SQL\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	with (
		firstrow =2,
		fielDTerminator=',',
		tablock
	);

	----------------------------------------------------------------------------------------------
	truncate table bronze.erp_loc_a101;
	Bulk insert bronze.erp_loc_a101
	from 'C:\Users\304so\OneDrive\Desktop\ME\Data_Analyst\SQL\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	with (
		firstrow =2,
		fielDTerminator=',',
		tablock
	);

	----------------------------------------------------------------------------------------------
	truncate table bronze.erp_px_cat_g1v2;
	Bulk insert bronze.erp_px_cat_g1v2
	from 'C:\Users\304so\OneDrive\Desktop\ME\Data_Analyst\SQL\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
	with (
		firstrow =2,
		fielDTerminator=',',
		tablock
	);
	select count(*) from bronze.crm_prd_info

end

exec bronze.load_bronze;
