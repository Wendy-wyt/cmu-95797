-- Write a query to determine if days immediately preceding precipitation or snow
-- had more bike trips on average than the days with precipitation or snow
-- The query below only looks into the time span when bike trips happens and has weather data
-- The query will find the average trips on the dates that are one day before the dates with precipitation or snow
-- The query will also find the average trips happened on the dates with precipitation or snow

with bike_weather as (
    select 
        coalesce(bc.date, cpw.date) as trip_date,
        coalesce(bc.trips,0) as total_trips,
        (case when cpw.prcp > 0 or cpw.snow > 0 then 1
            else 0
        end ) as is_prcp_snow,
        lead(trip_date,1) over (order by trip_date) as next_date,
        lead(is_prcp_snow,1) over (order by trip_date) as next_is_prcp_snow
    from staging.stg__central_park_weather as cpw
    -- using full join to ensure dates are consecutive
        full join (
            select * from mart.mart__fact_all_trips_daily
            where type = 'bike'
        ) as bc
        on bc.date=cpw.date
    -- trim the time span to the crossing part of both tables 
    where trip_date >= (select min(date) from mart.mart__fact_all_trips_daily where type='bike')
        and trip_date <= (select max(date) from mart.mart__fact_all_trips_daily where type='bike')
        and trip_date >= (select min(date) from staging.stg__central_park_weather)
        and trip_date <= (select max(date) from staging.stg__central_park_weather)
    -- leave out the boundary cases
    qualify next_date is not null
)
select *
from 
    -- average of trips before precipation or snow
    (select
        avg(total_trips) as avg_trips_prev_prcp_snow
    from bike_weather
    where next_is_prcp_snow=1) as prev_prcp_snow
    cross join
    -- average of trips on precipation or snow
    (select
        avg(total_trips) as avg_trips_on_prcp_snow
    from bike_weather
    where is_prcp_snow=1) as on_prcp_snow