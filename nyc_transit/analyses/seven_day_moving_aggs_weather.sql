-- Write a query to calculate the 7 day moving min, max, avg, sum for precipitation
-- and snow for every day in the weather data, defining the window only once.
-- The 7 day window should center on the day in question (for each date, the 3 days
-- before, the date & 3 days after).

select
    date,
    min(prcp) over seven_day as min_precipitation,
    max(prcp) over seven_day as max_precipitation,
    avg(prcp) over seven_day as avg_precipitation,
    sum(prcp) over seven_day as sum_precipitation,
    min(snow) over seven_day as min_snow,
    max(snow) over seven_day as max_snow,
    avg(snow) over seven_day as avg_snow,
    sum(snow) over seven_day as sum_snow
from {{ ref('stg__central_park_weather') }}
window seven_day as (
    order by date ASC
    range between INTERVAL 3 DAYS PRECEDING AND
                  INTERVAL 3 DAYS FOLLOWING
)
-- exclude the boundary cases
qualify min_precipitation is not null
order by date