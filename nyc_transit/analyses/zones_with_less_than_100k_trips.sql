-- Write a query which finds all the Zones where there are less than 100000 trips.

select 
    zone,
    count(*) as total_trips
-- With right join, the zones with no trips will be kept.
-- And the invalid trips will be excluded
from {{ ref('mart__fact_all_taxi_trips') }}  as trips
    right join  {{ ref('taxi+_zone_lookup') }} as puzones
        on trips.pulocationid=puzones.locationid
group by zone
having total_trips < 100000
order by zone