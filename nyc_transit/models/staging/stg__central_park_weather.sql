with source as (

    select * from {{ source('main', 'central_park_weather') }}

),

renamed as (

-- station should be less than 17 characters
    select
        trim(station) as station,
        name,
        date::date as date,
        awnd::double as awnd,
        prcp::double as prcp,
        snow::double as snow,
        snwd::double as snwd,
        tmax::int as tmax,
        tmin::int as tmin,
        filename

    from source

)

select 
    station,
    date,
    awnd,
    prcp,
    snow,
    snwd,
    tmax,
    tmin,
    filename
from renamed