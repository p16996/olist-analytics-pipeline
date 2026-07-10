---
title: Revenue Analysis
---

Monthly revenue trends and category performance across the Olist marketplace.

---

## Monthly Revenue Trend

```sql monthly_revenue
select 
    revenue_month,
    round(sum(total_revenue), 2) as total_revenue,
    round(sum(total_item_revenue), 2) as item_revenue,
    round(sum(total_freight_revenue), 2) as freight_revenue,
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

---

## Revenue by Category

```sql category_revenue
select 
    category_name_english,
    round(sum(total_revenue), 2) as total_revenue,
    sum(order_count) as total_orders,
    round(sum(total_revenue) / sum(order_count), 2) as avg_order_value
from olist.mart_revenue
where category_name_english is not null
group by category_name_english
order by total_revenue desc
limit 15
```

<BarChart 
    data={category_revenue} 
    x=category_name_english 
    y=total_revenue
    title="Top 15 Categories by Revenue (BRL)"
    swapXY=true
/>

<DataTable data={category_revenue}/>