-- reference: duckdb documentation https://duckdb.org/docs/sql/introduction
-- reference: ChatGPT
-- dba is a nullable field

-- pull fhv_bases from source
with source as (
    select * from {{ source('main','fhv_bases') }}
),
-- perform data cleanup
renamed as (
    select
        trim(base_number) as base_number,
        trim(base_name) as base_name,
        trim(dba) as dba,
        trim(dba_category) as dba_category,
        trim(filename) as filename
    from source
)

select * from renamed