-- Find the average time between taxi pick ups per zone
-- ● Use lead or lag to find the next trip per zone for each record
-- ● then find the time difference between the pick up time for the current record
-- and the next
-- ● then use this result to calculate the average time between pick ups per zone
-- The query only looks into the taxi trips as the bike trips don't have clear relationships with zones


with timediff as (
    -- find the zone and time difference of trips in the zone
    select
        zone,
        datediff('minute', pickup_datetime, lead(pickup_datetime, 1) 
            over (partition by zone order by pickup_datetime)) as diff_min
    from {{ ref('mart__fact_all_taxi_trips') }}  as trips
        left join  {{ ref('taxi+_zone_lookup') }} as puzones
            on trips.pulocationid=puzones.locationid
    -- exclude the boundary cases and the invalid pickup zones
    qualify diff_min is not null and zone is not null
)
-- find the average of time difference for each zone
select
    zone,
    avg(diff_min) as avg_pickup_time_diff_min
from timediff
group by zone
order by zone