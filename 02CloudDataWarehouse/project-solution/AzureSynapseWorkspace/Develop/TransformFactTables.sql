SELECT
    t.trip_id,
    DATEDIFF(second, CAST(t.started_at AS DATETIME2), CAST(t.ended_at AS DATETIME2)) AS duration,
    DATEDIFF(year, CAST(r.birthday AS DATETIME2), CAST(t.started_at AS DATETIME2)) AS age_at_ride_time,
    t.start_station_id,
    t.end_station_id,
    r.rider_id,
    CAST(t.started_at AS DATE) AS date_id
INTO trips
FROM stage_trips AS t
INNER JOIN stage_riders AS r
ON t.rider_id = r.rider_id
GO

SELECT
    payment_id,
    amount,
    rider_id,
    CAST(date_id AS DATE) AS date_id
INTO payments
FROM stage_payments
GO