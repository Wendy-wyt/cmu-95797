-- Write a query to compare an individual fare to 
-- the zone, borough and overall average fare 
-- using the fare_amount in yellow taxi trip data.
-- Basic Window Functions
-- The query will only look into the trips with valid pu location id
-- The query considers the zone/borough for each trip according to their pu location id

select
    fare_amount,
    zone,
    avg(fare_amount) over (partition by puzones.zone) as avg_zone,
    borough,
    avg(fare_amount) over (partition by puzones.borough) as avg_borough,
    avg(fare_amount) over () as avg_all
-- With join, the query will exclude trips that doesn't have a valid pu location id
-- or the locations with no trips
from {{ ref('stg__yellow_tripdata') }}  as trips
    join  {{ ref('taxi+_zone_lookup') }} as puzones
        on trips.pulocationid=puzones.locationid