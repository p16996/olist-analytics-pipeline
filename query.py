import duckdb

conn = duckdb.connect('olist_pipeline/dev.duckdb')

# Change this query anytime you want to check something
# query = """
# select 
#     seller_city,
#     avg_price,
#     avg_delivery_days,
#     avg_review_score,
#     delayed_orders,
#     on_time_orders,
#     price_rank,
#     delivery_rank,
#     quality_rank
# from mart_seller_value_score
# where product_id = 'd285360f29ac7fd97640bf0baef03de0'
# order by price_rank
# """

# print(conn.sql(query))

results = conn.execute("describe mart_seller_value_score").fetchall()
for row in results:
    print(row[0], '-', row[1])