with order_items as (

    select * from {{ ref('int_order_items_enriched') }}

),
orders as (

    select * from {{ ref('int_orders_enriched') }}

),
final as (

    select
        cast(date_trunc('month', o.ordered_at) as date)   as revenue_month,
        oi.category_name_english,
        round(sum(oi.item_price), 2)       as total_item_revenue,
        round(sum(oi.freight_price), 2)              as total_freight_revenue,
        round(sum(oi.item_price + oi.freight_price), 2) as total_revenue,
        count(distinct o.order_id)          as order_count

    from order_items oi
    left join orders o on oi.order_id = o.order_id

    group by 1, 2

)

select * from final