with multi_seller_products as (

    select
        product_id,
        count(distinct seller_id)                   as seller_count,
        count(distinct order_id)                    as total_orders,
        round(min(item_price), 2)                   as min_price,
        round(max(item_price), 2)                   as max_price,
        round(avg(item_price), 2)                   as avg_price,
        round(max(item_price) - min(item_price), 2) as price_range
    from {{ ref('int_order_items_enriched') }}
    group by product_id
    having count(distinct seller_id) > 1

),

seller_product_stats as (

    select
        oi.product_id,
        oi.seller_id,
        oi.seller_city,
        oi.seller_state,
        oi.category_name_english,
        round(avg(oi.item_price), 2)        as avg_price,
        count(distinct oi.order_id)         as order_count,
        round(avg(o.delivery_days), 1)      as avg_delivery_days,
        round(avg(r.review_score), 2)       as avg_review_score,
        count(case when o.delivered_at > o.estimated_delivery_at
              then 1 end)                   as delayed_orders,
        count(case when o.delivered_at <= o.estimated_delivery_at
              then 1 end)                   as on_time_orders
    from {{ ref('int_order_items_enriched') }} oi
    left join {{ ref('int_orders_enriched') }} o
        on oi.order_id = o.order_id
    left join {{ ref('stg_order_reviews') }} r
        on oi.order_id = r.order_id
    group by 1, 2, 3, 4, 5
    having count(distinct oi.order_id) >= 3

),

final as (

    select
        sp.product_id,
        sp.seller_id,
        sp.seller_city,
        sp.seller_state,
        sp.category_name_english,
        sp.avg_price,
        sp.order_count,
        sp.avg_delivery_days,
        sp.avg_review_score,
        sp.delayed_orders,
        sp.on_time_orders,
        mp.seller_count,
        mp.min_price,
        mp.max_price,
        mp.price_range,

        rank() over (
            partition by sp.product_id
            order by sp.avg_price asc
        ) as price_rank,

        rank() over (
            partition by sp.product_id
            order by sp.avg_delivery_days asc
        ) as delivery_rank,

        rank() over (
            partition by sp.product_id
            order by sp.avg_review_score desc
        ) as quality_rank

    from seller_product_stats sp
    join multi_seller_products mp
        on sp.product_id = mp.product_id

)

select * from final