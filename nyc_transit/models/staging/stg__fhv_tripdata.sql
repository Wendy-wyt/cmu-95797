-- reference: duckdb documentation https://duckdb.org/docs/sql/introduction
-- reference: ChatGPT

-- pull fhv_tripdata from source
with source as (
    select * from {{ source('main','fhv_tripdata') }}
),
-- perform data cleanup
renamed as (
        select
        trim(dispatching_base_num) as dispatching_base_num,
        pickup_datetime,
        dropOff_datetime,
        PUlocationID::int AS PUlocationID,
        DOlocationID::int AS DOlocationID,
        trim(Affiliated_base_number) as Affiliated_base_number,
        trim(filename) as filename
    from source
    where pickup_datetime <= dropOff_datetime
        and dropOff_datetime <= '2022-12-31'
        and PUlocationID > 0
        and DOlocationID > 0
)

select * from renamed