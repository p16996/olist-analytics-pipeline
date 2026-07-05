with orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

payments as (

    select
        order_id,
        sum(payment_amount)     as total_payment_amount,
        count(*)                as payment_count
    from {{ ref('stg_order_payments') }}
    group by order_id

),

final as (

    select
        o.order_id,
        o.customer_id,
        c.customer_unique_id,
        c.city                  as customer_city,
        c.state                 as customer_state,
        o.order_status,
        o.ordered_at,
        o.approved_at,
        o.shipped_at,
        o.delivered_at,
        o.estimated_delivery_at,
        coalesce(p.total_payment_amount, 0)  as total_payment_amount,
        coalesce(p.payment_count, 0)         as payment_count,
        datediff('day', o.ordered_at, o.delivered_at) as delivery_days

    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join payments p on o.order_id = p.order_id

)

select * from final