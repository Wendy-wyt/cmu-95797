-- ref: https://www.geeksforgeeks.org/how-to-select-the-first-row-of-each-group-by-in-sql/
-- used in getting the first row for each station id
-- Since we use SCD-I, we will consider the current value is the same as the value in the past.
-- For the rows of the same station id, we will select the row 
-- with the latest timestamp as the values for the station id.
with bikeData as (
select
    distinct
    start_station_id as station_id,
    start_station_name as station_name,
    start_lat station_lat,
    start_lng station_lng,
    started_at_ts as ts
from {{ ref('stg__bike_data') }}
union
select
    distinct
    end_station_id as station_id,
    end_station_name as station_name,
    end_lat station_lat,
    end_lng station_lng,
    ended_at_ts as ts
from {{ ref('stg__bike_data') }}
)
select
    station_id,
    station_name,
    station_lat,
    station_lng
from (
    select 
        *,
        ROW_NUMBER() OVER (PARTITION BY station_id ORDER BY ts DESC, station_name, station_lat, station_lng) AS rn
    from bikeData
)
where rn=1 
    and station_lat is not null 
    and station_lng is not null 