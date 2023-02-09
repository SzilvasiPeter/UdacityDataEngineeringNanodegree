# SQL scripts

## Date Dimension

Generating date and time dimension for the `trips` and `payments` tables are very time-consuming. The date range is large (especially for the `trips` table) so choosing a smaller range is advisable.

Replace the time range in the `GenerateDateDimensions.sql` script example:

```
SET @StartTime = '2021-02-01T01:00:00'
SET @EndTime = '2021-03-01T1:00:00'
```

Replace the date range in the `GenerateDateDimensions.sql` script example:

```
SET @StartTime = '2013-02-01'
SET @EndTime = '2014-02-01'
```

## References

* Truncate date to only hour / minute: https://stackoverflow.com/a/9783814/10721627
* Generate Dates betweeen date ranges: https://stackoverflow.com/a/7824919/10721627
* Create comprehensive Date dimension: https://gist.github.com/jrgcubano/c4dbaa879a1cfc9899f961d6eafa737c