-- Calculate the number of trips and average duration by borough and zone
-- group by
-- The query only looks into the taxi trips as the bike trips don't have clear relationships with zones

select
    borough,
    zone,
    count(*) as total_trips,
    avg(duration_min) as avg_duration_min,
    avg(duration_sec) as avg_duration_sec
from {{ ref('mart__fact_all_taxi_trips') }}  as trips
    left join  {{ ref('taxi+_zone_lookup') }} as puzones
        on trips.pulocationid=puzones.locationid
group by all 
order by borough, zone