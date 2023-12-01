-- Make a query which finds taxi trips which don’t have a pick up location_id in the locations table
-- Anti-joins
-- Since in mart__fact_all_taxi_trips all trips are guaranteed to have a pulocation id,
-- the query will only look into the pulocation id that is not in the locations table

select *
from {{ ref('mart__fact_all_taxi_trips') }}  as trips
    left join  {{ ref('taxi+_zone_lookup') }} as puzones
        on trips.pulocationid=puzones.locationid
where puzones.locationid is null