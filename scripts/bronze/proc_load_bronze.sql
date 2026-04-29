create or alter procedure bronze.load_bronze as 
begin
	declare @start_time datetime, @end_time datetime,@load_start_time datetime,@load_end_time datetime
	begin try
		print '============================================================='; 
		print '------------------Loading Bronze layer-----------------------'; 
		print '============================================================='; 

		print '-------------------------------------------------------------'; 
		print '-----------------------Loading CRM Tables--------------------'; 
		print '-------------------------------------------------------------'; 
		
		set @load_start_time = getdate();
		set @start_time =getdate();
		print'>> Truncating crm_cust_info';
		truncate table bronze.crm_cust_info;

		print'>> Inserting crm_cust_info';
		Bulk insert bronze.crm_cust_info
		from 'C:\Users\304so\OneDrive\Desktop\ME\Data_Analyst\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
			firstrow =2,
			fielDTerminator=',',
			tablock
		);
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';

		print '--------------------------------------------------------------------------------'
		set @start_time =getdate();
		print'>> Truncating crm_prd_info';
		truncate table bronze.crm_prd_info;

		print'>> Inserting crm_prd_info';
		Bulk insert bronze.crm_prd_info
		from 'C:\Users\304so\OneDrive\Desktop\ME\Data_Analyst\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
			firstrow =2,
			fielDTerminator=',',
			tablock
		);
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';

		print '--------------------------------------------------------------------------------'
		set @start_time =getdate();
		print'>> Truncating crm_sales_details';
		truncate table bronze.crm_sales_details;

		print'>> Inserting crm_sales_details';
		Bulk insert bronze.crm_sales_details
		from 'C:\Users\304so\OneDrive\Desktop\ME\Data_Analyst\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
			firstrow =2,
			fielDTerminator=',',
			tablock
		);
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
	
		print '-------------------------------------------------------------'; 
		print '-----------------------Loading ERP Tables--------------------'; 
		print '-------------------------------------------------------------'; 

		print '--------------------------------------------------------------------------------'
		set @start_time =getdate();
		print'>> Truncating erp_cust_az12';
		truncate table bronze.erp_cust_az12;

		print'>> Inserting erp_cust_az12';
		Bulk insert bronze.erp_cust_az12
		from 'C:\Users\304so\OneDrive\Desktop\ME\Data_Analyst\SQL\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		with (
			firstrow =2,
			fielDTerminator=',',
			tablock
		);
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';

		print '--------------------------------------------------------------------------------'
		set @start_time =getdate();
		print'>> Truncating erp_loc_a101';
		truncate table bronze.erp_loc_a101;

		print'>> Inserting erp_loc_a101';
		Bulk insert bronze.erp_loc_a101
		from 'C:\Users\304so\OneDrive\Desktop\ME\Data_Analyst\SQL\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		with (
			firstrow =2,
			fielDTerminator=',',
			tablock
		);
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';

		print '--------------------------------------------------------------------------------'
		set @start_time =getdate();
		print'>> Truncating erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2;

		print'>> Inserting erp_px_cat_g1v2';
		Bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\304so\OneDrive\Desktop\ME\Data_Analyst\SQL\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		with (
			firstrow =2,
			fielDTerminator=',',
			tablock
		);
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
		set @load_end_time = getdate();
		print 'Entire Bronze Load Duration ' + cast(datediff(second,@load_start_time,@load_end_time)as nvarchar) +' seconds';
	end try
	begin catch
		print '==========================================================';
		print 'Error Occured during loading bronze layer';	
		print 'Error Messsage ' + Error_Message();
		print 'Error Line ' + cast(Error_Line() as nvarchar);
		print 'Error Number ' + cast(Error_Number() as nvarchar);
		print 'Error State ' + cast(Error_State() as nvarchar);
		print '==========================================================';
	end catch
end

exec bronze.load_bronze;
