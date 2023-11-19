-- by weekday, count of total trips, trips starting and ending in a different borough, 
-- and percentage w/ different start/end

-- It is possible that the pickup/dropoff boroughs are unknown.
-- This query here will consider the all trips 
-- with different pickup/dropoff borough (including the unknown boroughs) 
-- as inter_borough trips.
-- For example, a trip from unknown to queens is inter_borough
with renamed as (
select
    weekday(pickup_datetime) as weekday,
    (case 
        when dozones.borough != puzones.borough then 1 
        else 0 
    end) as inter_borough
from {{ ref('mart__fact_all_taxi_trips') }}  as trips
    left join {{ ref('taxi+_zone_lookup') }} as dozones 
        on trips.dolocationid=dozones.locationid
    left join  {{ ref('taxi+_zone_lookup') }} as puzones
        on trips.pulocationid=puzones.locationid
)
select 
    weekday, 
    count(*) as total_trips,
    sum(inter_borough) as total_inter_borough_trips,
    total_inter_borough_trips/total_trips*100 as percentage
from renamed
group by weekday
order by weekday