create or alter procedure silver.load_silver as
begin
	declare @start_time datetime, @end_time datetime,@load_start_time datetime,@load_end_time datetime
	begin try
		print '============================================================='; 
		print '------------------Loading Silver layer-----------------------'; 
		print '============================================================='; 

		print '-------------------------------------------------------------'; 
		print '-----------------------Loading CRM Tables--------------------'; 
		print '-------------------------------------------------------------'; 

		set @load_start_time = getdate();
		set @start_time =getdate();


		print '>> Truncating table silver.crm_cust_info'
		truncate table silver.crm_cust_info

		print '>> Inserting table silver.crm_cust_info'
		insert into silver.crm_cust_info (
		cust_id,
		cust_key,
		cust_firstname,
		cust_lastname,
		cust_marital_status,
		cust_gndr,
		cust_create_date
		)
		select 
		cust_id,
		cust_key,
		Trim(cust_firstname) cust_firstname,
		Trim(cust_lastname) cust_lastname,
		case 
			when upper(trim(cust_marital_status)) = 'S' then 'Single'
			when upper(trim(cust_marital_status)) = 'M' then 'Married'
			else 'n/a'
		end cust_marital_status,
		case 
			when upper(trim(cust_gndr)) = 'F' then 'Female'
			when upper(trim(cust_gndr)) = 'M' then 'Male'
			else 'n/a'
		end cust_gndr,
		cust_create_date
		from (
			 select *,
			 ROW_NUMBER() over(partition by cust_id order by cust_create_date desc) as flag_list from bronze.crm_cust_info
			 where cust_id is not null
			 )t where flag_list =1
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';

		print '--------------------------------------------------------------------------------'
		set @start_time =getdate();
		print '>> Truncating table silver.crm_prd_info'
		truncate table silver.crm_prd_info
		print '>> Inserting table silver.crm_prd_info'
		insert into silver.crm_prd_info (
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
		)
		select
		prd_id,
		replace(substring(prd_key,1,5),'-','_') cat_id,
		substring(prd_key,7,len(prd_key)) as prd_key,
		prd_nm,
		isnull(prd_cost,0) prd_cost,
		case upper(trim(prd_line))
			 when 'M' Then 'Mountain'
			 when 'R' Then 'Road'
			 when 'S' Then 'Other Sales'
			 when 'T' Then 'Touring'
			 else 'n/a'
		end prd_line,
		cast(prd_start_dt as date) prd_start_dt,
		cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as date) prd_end_dt
		from 
		bronze.crm_prd_info 
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';

		print '--------------------------------------------------------------------------------'
		set @start_time =getdate();
		print '>> Truncating table silver.crm_sales_details'
		truncate table silver.crm_sales_details
		print '>> Inserting table silver.crm_sales_details'
		insert into silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
		)
		select 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		case 
			when sls_order_dt=0 or len(sls_order_dt) !=8 Then Null
			else cast(cast(sls_order_dt as varchar) as date)
		end sls_order_dt,
		case 
			when sls_ship_dt=0 or len(sls_ship_dt) !=8 Then Null
			else cast(cast(sls_ship_dt as varchar) as date)
		end sls_ship_dt,
		case 
			when sls_due_dt=0 or len(sls_due_dt) !=8 Then Null
			else cast(cast(sls_due_dt as varchar) as date)
		end sls_due_dt,
		case 
			when sls_sales is null or sls_sales<=0 or sls_sales!= sls_quantity * abs(sls_price) then sls_quantity*abs(sls_price)
			else sls_sales
		end  sls_sales,
		sls_quantity,
		case
			when sls_price is null or sls_price<=0 then sls_sales/nullif(sls_quantity,0)
			else sls_price
		end sls_price
		from bronze.crm_sales_details
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';

		print '-------------------------------------------------------------'; 
		print '-----------------------Loading ERP Tables--------------------'; 
		print '-------------------------------------------------------------'; 

		print '--------------------------------------------------------------------------------'
		set @start_time =getdate();
		print '>> Truncating table silver.erp_cust_az12'
		truncate table silver.erp_cust_az12
		print '>> Inserting table silver.erp_cust_az12'
		insert into silver.erp_cust_az12(cid,bdate,gen)
		select 
		case
			when cid like 'NAS%' then substring(cid,4,len(cid))
			else cid
		end cid,
		case 
			when bdate >getdate() then null 
			else bdate
		end bdate,
		case
			when upper(trim(gen)) in ('F', 'Female') then 'Female'
			when upper(trim(gen)) in ('M', 'Male') then 'Male'
			else 'n/a'
		end gen
		from bronze.erp_cust_az12
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';

		print '--------------------------------------------------------------------------------'
		set @start_time =getdate();
		print '>> Truncating table silver.erp_loc_a101'
		truncate table silver.erp_loc_a101
		print '>> Inserting table silver.erp_loc_a101'
		insert into silver.erp_loc_a101(cid,cntry)
		select 
		replace(cid,'-','') cid,
		case
			when trim(cntry) = 'DE' then 'Germany'
			when trim(cntry) IN ('US','USA') then 'United States'
			when trim(cntry) = '' or cntry is null
			then 'n/a'
			else trim(cntry)
		end cntry
		from bronze.erp_loc_a101

		print '>> Truncating table silver.erp_px_cat_g1v2'
		truncate table silver.erp_px_cat_g1v2
		print '>> Inserting table silver.erp_px_cat_g1v2'
		insert into silver.erp_px_cat_g1v2 (id,cat,subcat,MAINTENANCE)
		select * from bronze.erp_px_cat_g1v2;
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
		set @load_end_time = getdate();
		print 'Entire Silver Load Duration ' + cast(datediff(second,@load_start_time,@load_end_time)as nvarchar) +' seconds';
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

 exec silver.load_silver
