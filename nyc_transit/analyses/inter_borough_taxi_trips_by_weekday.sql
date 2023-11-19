-- by weekday, count of total trips, trips starting and ending in a different borough, 
-- and percentage w/ different start/end
with renamed as (
select
    weekday(pickup_datetime) as weekday,
    (case when pulocationid != dolocationid then 1 else 0 end) as inter_borough
from {{ ref('mart__fact_all_taxi_trips') }}
)
select 
    weekday, 
    count(*) as total_trips,
    sum(inter_borough) as total_inter_borough_trips,
    total_inter_borough_trips/total_trips*100 as percentage
from renamed
group by weekday
order by weekday