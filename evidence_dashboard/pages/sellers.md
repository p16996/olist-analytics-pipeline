---
title: Seller Performance
---

Analysis of seller revenue, delivery speed, and customer satisfaction.

---

## Top Sellers by Revenue

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

---

## Delivery Speed vs Review Score

```sql delivery_vs_reviews
select 
    seller_city,
    seller_state,
    round(avg(avg_delivery_days), 1) as avg_delivery_days,
    round(avg(avg_review_score), 2) as avg_review_score,
    sum(total_orders) as total_orders
from olist.mart_seller_performance
group by seller_city, seller_state
having sum(total_orders) > 50
order by avg_review_score desc
limit 20
```

<ScatterPlot 
    data={delivery_vs_reviews} 
    x=avg_delivery_days 
    y=avg_review_score
    series=seller_state
    title="Delivery Speed vs Review Score by City"
/>

---

## Performance by State

```sql state_performance
select 
    seller_state,
    count(*) as seller_count,
    sum(total_orders) as total_orders,
    round(sum(total_revenue), 2) as total_revenue,
    round(avg(avg_delivery_days), 1) as avg_delivery_days,
    round(avg(avg_review_score), 2) as avg_review_score
from olist.mart_seller_performance
group by seller_state
order by total_revenue desc
```

<DataTable data={state_performance}/>