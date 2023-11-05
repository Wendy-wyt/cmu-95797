-- reference: duckdb documentation https://duckdb.org/docs/sql/introduction
-- reference: ChatGPT

-- pull fhvhv_tripdata from source
with source as (
    select * from {{ source('main','fhvhv_tripdata') }}
),
-- perform data cleanup
renamed as (
    select
        trim(hvfhs_license_num) as hvfhs_license_num,
        trim(dispatching_base_num) as dispatching_base_num,
        trim(originating_base_num) as originating_base_num,
        request_datetime,
        on_scene_datetime,
        pickup_datetime,
        dropoff_datetime,
        PULocationID::int AS PULocationID,
        DOLocationID::int AS DOLocationID,
        trip_miles,
        base_passenger_fare,
        tolls,
        bcf,
        sales_tax,
        congestion_surcharge,
        COALESCE(airport_fee,0.0)::float AS airport_fee,
        tips,
        driver_pay,
        trim(shared_request_flag) as shared_request_flag,
        trim(shared_match_flag) as shared_match_flag,
        trim(CASE
            WHEN access_a_ride_flag=' ' THEN 'Y'
            ELSE access_a_ride_flag
        END) AS access_a_ride_flag,
        trim(wav_request_flag) as wav_request_flag,
        trim(wav_match_flag) as wav_match_flag,
        trim(filename) as filename
    from source
    where request_datetime <= on_scene_datetime
        and on_scene_datetime <= pickup_datetime
        and pickup_datetime <= dropoff_datetime
        and dropoff_datetime <= '2022-12-31'
        and trip_miles >= 0
        and trip_time >= 0
        and base_passenger_fare >= 0
        and tolls >= 0
        and bcf >= 0
        and sales_tax>=0
        and congestion_surcharge >= 0
        and airport_fee >= 0
        and tips >=0
        and driver_pay>=0
)

select * from renamed