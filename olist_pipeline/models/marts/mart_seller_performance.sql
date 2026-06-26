with order_items as (

    select * from {{ ref('int_order_items_enriched') }}

),

orders as (

    select * from {{ ref('int_orders_enriched') }}

),

reviews as (

    select * from {{ ref('stg_order_reviews') }}

),

final as (

    select
        oi.seller_id,
        oi.seller_city,
        oi.seller_state,
        count(distinct oi.order_id)        as total_orders,
        round(sum(oi.total_item_price), 2) as total_revenue,
        round(avg(o.delivery_days), 1)     as avg_delivery_days,
        round(avg(r.review_score), 2)      as avg_review_score

    from order_items oi
    left join orders o  on oi.order_id = o.order_id
    left join reviews r on oi.order_id = r.order_id

    group by 1, 2, 3

)

select * from final