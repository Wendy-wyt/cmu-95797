import duckdb

conn = duckdb.connect("main.db")

table_query="SELECT table_name FROM duckdb_tables()"
tables=conn.sql(table_query).fetchall()

for table in tables:
    table_name=table[0]
    count_query=f"SELECT COUNT(*) FROM {table_name}"
    count=conn.sql(count_query).fetchone()[0]
    print(f"{table_name} {count}")