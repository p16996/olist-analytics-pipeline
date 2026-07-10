---
title: Olist E-Commerce Analytics
---

# Olist E-Commerce Analytics Dashboard

An end-to-end analytics pipeline built with dbt, DuckDB, and Dagster.

---

## Revenue Overview

```sql monthly_revenue
select 
    revenue_month,
    sum(total_revenue) as total_revenue,
    sum(total_item_revenue) as item_revenue,
    sum(total_freight_revenue) as freight_revenue,
    sum(order_count) as orders
from olist.mart_revenue
group by revenue_month
order by revenue_month
```

<LineChart 
    data={monthly_revenue} 
    x=revenue_month 
    y=total_revenue
    title="Monthly Revenue (BRL)"
/>

<DataTable data={monthly_revenue}/>

---

## Delivery Performance

```sql delivery_performance
select 
    delivery_status,
    count(*) as order_count,
    round(count(*) * 100.0 / sum(count(*)) over(), 1) as percentage
from olist.mart_orders
group by delivery_status
order by order_count desc
```

<BarChart 
    data={delivery_performance} 
    x=delivery_status 
    y=order_count
    title="Orders by Delivery Status"
/>

---

## Top Sellers

```sql top_sellers
select 
    seller_id,
    seller_city,
    seller_state,
    total_orders,
    total_revenue,
    avg_delivery_days,
    avg_review_score
from olist.mart_seller_performance
order by total_revenue desc
limit 20
```

<DataTable data={top_sellers}/>