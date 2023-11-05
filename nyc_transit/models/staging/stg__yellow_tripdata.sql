-- reference: duckdb documentation https://duckdb.org/docs/sql/introduction
-- reference: ChatGPT

-- pull yellow_tripdata from source
with source as (
    select * from {{ source('main','yellow_tripdata') }}
),
-- perform data cleanup
renamed as (
    select
        VendorID::int AS VendorID,
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        passenger_count::int AS passenger_count,
        trip_distance,
        RatecodeID::int AS RatecodeID,
        trim(store_and_fwd_flag) as store_and_fwd_flag,
        pulocationid::int AS PUlocationID,
        dolocationid::int AS DOlocationID,
        payment_type::int AS payment_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        congestion_surcharge,
        airport_fee,
        trim(filename) as filename
    from source
    where tpep_pickup_datetime <= tpep_dropoff_datetime 
        and tpep_dropoff_datetime <= '2022-12-31'
        and trip_distance>= 0
        and RatecodeID is not null and RatecodeID <= 6
        and fare_amount >= 0
        and extra >=0
        and mta_tax >=0
        and tip_amount >= 0
        and tolls_amount >= 0
        and improvement_surcharge >=0
        and total_amount >=0
        and congestion_surcharge >= 0
        and airport_fee >=0
)

select * from renamed