-- Create time dimension for trips table
CREATE TABLE trip_dates
(
    [time_id] DATETIME
)

-- Find the minimum and the maximum time from trips table 
DECLARE @StartTime DATETIME
DECLARE @EndTime DATETIME
SET @StartTime = (SELECT TOP 1 MIN(time_id) FROM trips)
SET @EndTime = (SELECT TOP 1 MAX(time_id) FROM trips)

-- Generate time hourly from the minimum to the maximum time 
WHILE(@StartTime <= @EndTime)
BEGIN 
   INSERT INTO trip_dates 
   SELECT @StartTime

   SELECT @StartTime = DATEADD(hour, 1, @StartTime)
END
GO

-- Create date dimension for payments table
CREATE TABLE payment_dates
(
    [date_id] DATE
)

-- Find the minimum and the maximum date from payments table 
DECLARE @StartDate DATE
DECLARE @EndDate DATE
SET @StartDate = (SELECT TOP 1 MIN(date_id) FROM payments)
SET @EndDate = (SELECT TOP 1 MAX(date_id) FROM payments)

-- Generate time daily from the minimum to the maximum date 
WHILE(@StartDate <= @EndDate)
BEGIN 
   INSERT INTO payment_dates 
   SELECT @StartDate

   SELECT @StartDate = DATEADD(day, 1, @StartDate)
END
GO