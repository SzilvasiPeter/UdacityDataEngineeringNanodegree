SELECT
    t.trip_id,
    DATEDIFF(second, t.started_at, t.ended_at) AS duration,
    DATEDIFF(year, r.birthday, t.started_at) -
        CASE
            WHEN (MONTH(r.birthday) >= MONTH(t.started_at) AND DAY(r.birthday) > DAY(t.started_at)) THEN 1
            ELSE 0
        END AS age_at_ride_time,
    t.start_station_id,
    t.end_station_id,
    r.rider_id,
    CAST(t.started_at AS DATE) AS date_id
INTO trips
FROM staging.trips AS t
INNER JOIN staging.riders AS r
ON t.rider_id = r.rider_id
GO

SELECT
    payment_id,
    amount,
    rider_id,
    CAST(date_id AS DATE) AS date_id
INTO payments
FROM staging.payments
GO