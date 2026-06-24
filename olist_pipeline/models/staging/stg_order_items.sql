with source as (

    select * from {{ ref('olist_order_items_dataset') }}

),

renamed as (

    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        cast(shipping_limit_date as timestamp) as shipping_limit_at,
        price                                  as item_price,
        freight_value                          as freight_price
    from source

)

select * from renamed