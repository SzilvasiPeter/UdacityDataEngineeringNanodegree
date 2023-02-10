IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'DelimitedFormat') 
	CREATE EXTERNAL FILE FORMAT [DelimitedFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'v3R!2tr0n6P4ssW0rD';
CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential WITH IDENTITY = 'user', Secret = '<storage_account_access_key>';
CREATE EXTERNAL DATA SOURCE AzureStorage WITH (  
      TYPE = HADOOP,
      LOCATION ='wasbs://<blob_container_name>@<storage_account_name>.blob.core.windows.net',  
      CREDENTIAL = AzureStorageCredential  
)
GO

CREATE SCHEMA staging;
GO

CREATE EXTERNAL TABLE staging.riders (
	[rider_id] bigint,
	[first] nvarchar(100),
	[last] nvarchar(100),
	[address] nvarchar(100),
	[birthday] nvarchar(100),
	[account_start_date] nvarchar(100),
	[account_end_date] nvarchar(100),
	[is_member] bit
	)
	WITH (
	LOCATION = 'public.rider.csv',
	DATA_SOURCE = [AzureStorage],
	FILE_FORMAT = [DelimitedFormat]
	)
GO

CREATE EXTERNAL TABLE staging.payments (
	[payment_id] bigint,
	[date_id] nvarchar(100),
	[amount] float,
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'public.payment.csv',
	DATA_SOURCE = [AzureStorage],
	FILE_FORMAT = [DelimitedFormat]
	)
GO

CREATE EXTERNAL TABLE staging.stations (
	[station_id] nvarchar(100),
	[name] nvarchar(100),
	[latitude] float,
	[longitude] float
	)
	WITH (
	LOCATION = 'public.station.csv',
	DATA_SOURCE = [AzureStorage],
	FILE_FORMAT = [DelimitedFormat]
	)
GO

CREATE EXTERNAL TABLE staging.trips (
	[trip_id] nvarchar(100),
	[rideable_type] nvarchar(100),
	[started_at] nvarchar(100),
	[ended_at] nvarchar(100),
	[start_station_id] nvarchar(100),
	[end_station_id] nvarchar(100),
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'public.trip.csv',
	DATA_SOURCE = [AzureStorage],
	FILE_FORMAT = [DelimitedFormat]
	)
GO

SELECT TOP 100 * FROM staging.riders
SELECT TOP 100 * FROM staging.payments
SELECT TOP 100 * FROM staging.stations
SELECT TOP 100 * FROM staging.trips
GO