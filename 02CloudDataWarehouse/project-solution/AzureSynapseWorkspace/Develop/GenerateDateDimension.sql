SELECT date_id
INTO dates
FROM (
    SELECT date_id FROM trips t
    UNION
    SELECT date_id FROM payments p
) d