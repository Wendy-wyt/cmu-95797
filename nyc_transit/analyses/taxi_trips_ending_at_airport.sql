-- total number of trips ending in service_zones 'Airports' or 'EWR'
select
    count(*) as total_trips_ending_at_airports
from 
    {{ ref('mart__fact_all_taxi_trips') }} as trips
        left join {{ ref('taxi+_zone_lookup') }} as zones 
            on trips.dolocationid=zones.locationid
where service_zone = 'Airports' or service_zone='EWR'