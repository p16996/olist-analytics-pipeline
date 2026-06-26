import duckdb

conn = duckdb.connect('olist_pipeline/dev.duckdb')

# Change this query anytime you want to check something
query = """
select * 
from mart_seller_performance 
order by total_revenue desc 
limit 10
"""

print(conn.sql(query))