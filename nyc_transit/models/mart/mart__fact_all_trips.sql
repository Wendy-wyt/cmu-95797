with trips_renamed as (
select 
    'bike' as type, 
    started_at_ts,
    ended_at_ts
from {{ ref('mart__fact_all_bike_trips') }}
union all
select 
    type, 
    pickup_datetime as started_at_ts,
    dropoff_datetime as ended_at_ts
from {{ ref('mart__fact_all_taxi_trips') }}
)

select 
    type, 
    started_at_ts, 
    ended_at_ts, 
    datediff('minute', started_at_ts,ended_at_ts) as duration_min,
    datediff('second', started_at_ts,ended_at_ts) as duration_sec
from trips_renamed