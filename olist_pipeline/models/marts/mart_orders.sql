with orders as (

    select * from {{ ref('int_orders_enriched') }}

),

final as (

    select
        order_id,
        customer_id,
        customer_unique_id,
        customer_city,
        customer_state,
        order_status,
        ordered_at,
        approved_at,
        shipped_at,
        delivered_at,
        estimated_delivery_at,
        total_payment_amount,
        payment_count,
        delivery_days,
        case 
            when delivered_at <= estimated_delivery_at then 'On Time' 
            when delivered_at > estimated_delivery_at then 'Delayed' 
            else 'Not Delivered'    
        end as delivery_status

    from orders 

)

select * from final