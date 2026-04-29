--create database and schemas
use master;
go

if Exists (select 1 from sys.databases where name='DataWarehouse')
Begin
alter database datawarehouse set single_user with rollback immediate;
drop database datawarehouse;
end;
go

create database DataWarehouse;
go

use DataWarehouse;
go

create schema bronze;
go

create schema silver;
go 

create schema gold;
go
