CREATE TABLE dates (date_id DATE)

DECLARE @dateFrom DATE
DECLARE @dateTo DATE
SET @dateTo = (SELECT MAX(date_id)
                FROM (
                    SELECT date_id FROM trips AS t
                    UNION
                    SELECT date_id FROM payments AS p
                    ) AS d
                )
SET @dateFrom = DATEADD(year, -1, @dateTo)

WHILE(@dateFrom <= @dateTo)
BEGIN
   INSERT INTO dates SELECT @dateFrom
   SELECT @dateFrom = DATEADD(day, 1, @dateFrom)
END