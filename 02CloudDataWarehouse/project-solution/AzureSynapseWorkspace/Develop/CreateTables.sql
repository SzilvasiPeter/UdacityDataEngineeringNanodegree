IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'DelimitedFormat') 
	CREATE EXTERNAL FILE FORMAT [DelimitedFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'udacitydivvy') 
	CREATE EXTERNAL DATA SOURCE [udacitydivvy] 
	WITH (
		LOCATION = 'abfss://udacitydivvy@udacitydivvy.dfs.core.windows.net', 
		TYPE = HADOOP
	)
GO

CREATE EXTERNAL TABLE stage_riders (
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
	DATA_SOURCE = [udacitydivvy],
	FILE_FORMAT = [DelimitedFormat]
	)
GO

CREATE EXTERNAL TABLE stage_payments (
	[payment_id] bigint,
	[date_id] nvarchar(100),
	[amount] float,
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'public.payment.csv',
	DATA_SOURCE = [udacitydivvy],
	FILE_FORMAT = [DelimitedFormat]
	)
GO

CREATE EXTERNAL TABLE stage_stations (
	[station_id] nvarchar(100),
	[name] nvarchar(100),
	[latitude] float,
	[longitude] float
	)
	WITH (
	LOCATION = 'public.station.csv',
	DATA_SOURCE = [udacitydivvy],
	FILE_FORMAT = [DelimitedFormat]
	)
GO

CREATE EXTERNAL TABLE stage_trips (
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
	DATA_SOURCE = [udacitydivvy],
	FILE_FORMAT = [DelimitedFormat]
	)
GO

SELECT TOP 100 * FROM stage_riders
GO

SELECT TOP 100 * FROM stage_payments
GO

SELECT TOP 100 * FROM stage_stations
GO

SELECT TOP 100 * FROM stage_trips
GO