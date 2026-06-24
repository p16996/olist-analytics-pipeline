with source as (

    select * from {{ ref('olist_geolocation_dataset') }}

),

renamed as (

    select
        geolocation_zip_code_prefix    as zip_code,
        geolocation_lat                as latitude,
        geolocation_lng                as longitude,
        geolocation_city               as city,
        geolocation_state              as state
    from source

)

select * from renamed