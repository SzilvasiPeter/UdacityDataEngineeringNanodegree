SELECT
    rider_id,
    first,
    last,
    address,
    CAST(birthday AS DATE) AS birthday,
    CAST(account_start_date AS DATE) AS account_start_date,
    CAST(account_end_date AS DATE) AS account_end_date,
    is_member
INTO riders
FROM staging.riders
GO

SELECT
    station_id,
    name,
    latitude,
    longitude
INTO stations
FROM staging.stations
GO