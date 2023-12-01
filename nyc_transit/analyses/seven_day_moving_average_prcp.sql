-- Write a query to calculate the 7 day moving average precipitation for every day in
-- the weather data.
-- The 7 day window should center on the day in question (for a given date, 
-- the average over the 3 days before, the date & 3 days after
-- It is guaranteed that the dates are consecutive

select 
    date,
    (prcp
        +lag(prcp, 1) over (order by date)
        +lag(prcp, 2) over (order by date)
        +lag(prcp, 3) over (order by date)
        +lead(prcp, 1) over (order by date)
        +lead(prcp, 2) over (order by date)
        +lead(prcp, 3) over (order by date)
    )/7 as avg_prcp_7d
from {{ ref('stg__central_park_weather') }}
-- exclude boundary cases
qualify avg_prcp_7d is not null
order by date