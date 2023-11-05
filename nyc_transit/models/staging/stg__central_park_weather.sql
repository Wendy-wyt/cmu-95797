-- reference: duckdb documentation https://duckdb.org/docs/sql/introduction
-- reference: ChatGPT
-- filter out invalid data: when awnd and snow are null and date is beyond boundary

-- pull central_park_weather from source
with source as (
    select * from {{ source('main','central_park_weather') }}
),
-- perform data cleanup
renamed as (
    select
        trim(station) as station,
        trim(name) as name,
        date::DATE as date,
        awnd::DOUBLE as awnd,
        prcp::DOUBLE as prcp,
        snow::DOUBLE as snow,
        snwd::DOUBLE as snwd,
        tmax::int as tmax,
        tmin::int as tmin,
        trim(filename) as filename
    from source
    where awnd is not null and snow is not null
        and date <= '2022-12-31'
)

select * from renamed