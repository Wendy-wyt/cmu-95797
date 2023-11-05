-- reference: duckdb documentation https://duckdb.org/docs/sql/introduction
-- reference: ChatGPT
-- combine two data schemas
-- fill null data with 0
-- filter out invalid data

-- pull bike_data from source
with source as (
    select * from {{ source('main','bike_data') }}
),
-- perform data cleanup
renamed as (
        with step1 as (
        select 
            tripduration::BIGINT AS tripduration,
            started_at::TIMESTAMP AS started_at,
            ended_at::TIMESTAMP AS ended_at,
            TRY_CAST(COALESCE(started_at, starttime) AS TIMESTAMP) AS starttime,
            TRY_CAST(COALESCE(ended_at, stoptime) AS TIMESTAMP) AS stoptime,
            trim(COALESCE("start station name",start_station_name)) AS "start station name",
            TRY_CAST(COALESCE("start station id", start_station_id) AS FLOAT) AS "start station id",
            TRY_CAST(COALESCE("start station latitude", start_lat) AS DOUBLE) AS "start station latitude",
            TRY_CAST(COALESCE("start station longitude", start_lng) AS DOUBLE) AS "start station longitude",
            trim(COALESCE("end station name",end_station_name,'')) AS "end station name",
            TRY_CAST(COALESCE("end station id", end_station_id,'0.0') AS FLOAT) AS "end station id",
            TRY_CAST(COALESCE("end station latitude", end_lat, '0.0') AS DOUBLE) AS "end station latitude",
            TRY_CAST(COALESCE("end station longitude", end_lng,'0.0') AS DOUBLE) AS "end station longitude",
            CASE
                WHEN usertype = 'Customer' OR member_casual = 'casual' THEN 'casual'
                WHEN usertype = 'Subscriber' OR member_casual = 'member' THEN 'member'
                ELSE ''
            END AS "member_casual",
            trim(TRY_CAST(
                CASE 
                    WHEN gender IS NULL THEN 0 
                    ELSE gender 
                END AS INTEGER)) AS gender,
            trim(COALESCE(ride_id,bikeid)) AS ride_id,
            trim(COALESCE(rideable_type,'')) AS rideable_type,
            TRY_CAST(
                CASE 
                    WHEN "birth year" IS NULL THEN 0 
                    ELSE "birth year" 
                END AS INTEGER) AS "birth year",
            trim(filename) AS filename
        from source
    )
    select
            COALESCE(tripduration,date_sub('second',started_at,ended_at)) AS tripduration,
            starttime,
            stoptime,
            "start station name",
            "start station id",
            "start station latitude",
            "start station longitude",
            "end station name",
            "end station id",
            "end station latitude",
            "end station longitude",
            "member_casual",
            gender,
            ride_id,
            rideable_type,
            "birth year"
    from step1
    where starttime <= stoptime
        and stoptime <= '2022-12-31'
)

select * from renamed