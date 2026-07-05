import duckdb

conn = duckdb.connect('olist_pipeline/dev.duckdb')

# Change this query anytime you want to check something
query = """
select 
    *
from int_orders_enriched
where total_payment_amount is null
"""

print(conn.sql(query))