-- number of trips grouped by pickup borough

select 
    puzones.borough as pickup_borough,
    count(*) as total_trips
from {{ ref('mart__fact_all_taxi_trips') }}  as trips
    left join  {{ ref('taxi+_zone_lookup') }} as puzones
        on trips.pulocationid=puzones.locationid
group by pickup_borough