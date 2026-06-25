with order_items as (

    select * from {{ ref('stg_order_items') }}

),

products as (

    select * from {{ ref('stg_products') }}

),

sellers as (

    select * from {{ ref('stg_sellers') }}

),

categories as (

    select * from {{ ref('stg_product_categories') }}

),

final as (

    select
        oi.order_id,
        oi.order_item_id,
        oi.product_id,
        oi.seller_id,
        oi.item_price,
        oi.freight_price,
        oi.item_price + oi.freight_price    as total_item_price,
        oi.shipping_limit_at,
        p.category_name,
        c.category_name_english,
        p.weight_grams,
        s.city                              as seller_city,
        s.state                             as seller_state

    from order_items oi
    left join products p on oi.product_id = p.product_id
    left join sellers s on oi.seller_id = s.seller_id
    left join categories c on p.category_name = c.category_name

)

select * from final