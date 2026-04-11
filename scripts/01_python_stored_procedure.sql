-- Python stored procedure to merge data
CREATE OR REPLACE PROCEDURE merge_customer_data(
    source_table VARCHAR,
    target_table VARCHAR
)
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'run'
AS
$$
def run(session, source_table: str, target_table: str) -> str:
    source_df = session.table(source_table)
    row_count = source_df.count()

    session.sql(f"\""
        MERGE INTO {target_table} t
        USING {source_table} s
        ON t.customer_id = s.customer_id
        WHEN MATCHED THEN UPDATE SET
            t.customer_name = s.customer_name,
            t.email = s.email,
            t.updated_at = CURRENT_TIMESTAMP()
        WHEN NOT MATCHED THEN INSERT (customer_id, customer_name, email, created_at)
            VALUES (s.customer_id, s.customer_name, s.email, CURRENT_TIMESTAMP())
    "\"").collect()

    return f"Merged {row_count} records from {source_table} into {target_table}"
$$;

-- Call the procedure
CALL merge_customer_data('RAW.STAGING.CUSTOMERS', 'ANALYTICS.MARTS.DIM_CUSTOMERS');
