# 🚀 Snowflake Stored Procedures & UDFs Tutorial

## 🎯 Learning Objectives

1. 🧠 Understand the concepts of stored procedures and user-defined functions (UDFs) within Snowflake.

2. 🛠️ Master the creation and management of SQL and Python-based stored procedures and UDFs.

3. 🔗 Learn the differences between scalar UDFs, table functions (UDTFs), and stored procedures.

## 📚 Table of Contents

- [🚀 Snowflake Stored Procedures & UDFs Tutorial](#-snowflake-stored-procedures--udfs-tutorial)
  - [🎯 Learning Objectives](#-learning-objectives)
  - [📚 Table of Contents](#-table-of-contents)
    - [🎉 Introduction](#-introduction)
    - [📝 Introduction to Stored Procedures](#-introduction-to-stored-procedures)
    - [🧩 Introduction to User-Defined Functions](#-introduction-to-user-defined-functions)
    - [📊 UDF Types Comparison](#-udf-types-comparison)
    - [🐍 Python Stored Procedures](#-python-stored-procedures)
    - [🐍 Python UDFs](#-python-udfs)
    - [📋 SQL Stored Procedures (Snowflake Scripting)](#-sql-stored-procedures-snowflake-scripting)
  - [💡 Tutorial](#-tutorial)
  - [🎈 Conclusion](#-conclusion)
  - [📖 Additional Resources](#-additional-resources)
  - [⚠️ Disclaimer](#%EF%B8%8F-disclaimer)

### 🎉 Introduction

Welcome to this tutorial on Stored Procedures and User-Defined Functions (UDFs) within Snowflake! This tutorial is
designed to help you understand and implement custom logic in your Snowflake environment using both SQL and Python. By
the end of this tutorial, you'll be able to confidently create, deploy, and manage stored procedures and UDFs to extend
Snowflake's built-in capabilities. So, let's dive in! 🏊‍♀️

### 📝 Introduction to Stored Procedures

Stored procedures are named, reusable blocks of code that can perform complex operations including DDL, DML, control
flow, and multi-step data processing. They can be written in SQL (Snowflake Scripting), Python, Java, or Scala.

Key characteristics:

- **Can execute DDL and DML**: CREATE, INSERT, UPDATE, DELETE, MERGE, and more.
- **Support caller's or owner's rights**: Control whether the procedure runs with the caller's or the owner's
  privileges.
- **Can return a single value**: Procedures return a single result (not a result set).
- **Ideal for orchestration**: Complex workflows, data pipelines, administrative tasks.

### 🧩 Introduction to User-Defined Functions

User-Defined Functions (UDFs) extend Snowflake's built-in function library with custom logic. Unlike stored procedures,
UDFs are designed to be called within SQL expressions — such as in SELECT, WHERE, or JOIN clauses.

Key characteristics:

- **Return values inline**: Used within SQL statements like built-in functions.
- **Cannot execute DDL/DML**: UDFs are read-only and cannot modify data.
- **Support multiple languages**: SQL, Python, Java, Scala.
- **Two types**: Scalar (one row in, one value out) and Tabular (one row in, multiple rows out).

### 📊 UDF Types Comparison

| Type               | Abbreviation | Input         | Output        | Use Case                       |
| ------------------ | ------------ | ------------- | ------------- | ------------------------------ |
| **Scalar UDF**     | UDF          | Single row    | Single value  | Formatting, calculations       |
| **Table Function** | UDTF         | Single row    | Multiple rows | Row expansion, JSON flattening |
| **Aggregate UDF**  | UDAF         | Multiple rows | Single value  | Custom aggregations            |

### 🐍 Python Stored Procedures

```sql
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

    session.sql(f"""
        MERGE INTO {target_table} t
        USING {source_table} s
        ON t.customer_id = s.customer_id
        WHEN MATCHED THEN UPDATE SET
            t.customer_name = s.customer_name,
            t.email = s.email,
            t.updated_at = CURRENT_TIMESTAMP()
        WHEN NOT MATCHED THEN INSERT (customer_id, customer_name, email, created_at)
            VALUES (s.customer_id, s.customer_name, s.email, CURRENT_TIMESTAMP())
    """).collect()

    return f"Merged {row_count} records from {source_table} into {target_table}"
$$;

-- Call the procedure
CALL merge_customer_data('SPROC_RAW.STAGING.CUSTOMERS', 'SPROC_ANALYTICS.MARTS.DIM_CUSTOMERS');
```

### 🐍 Python UDFs

```sql
-- Scalar UDF: Categorise revenue
CREATE OR REPLACE FUNCTION categorise_revenue(revenue FLOAT)
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
HANDLER = 'categorise'
AS
$$
def categorise(revenue: float) -> str:
    if revenue is None:
        return "Unknown"
    if revenue > 100000:
        return "Enterprise"
    elif revenue > 25000:
        return "Mid-Market"
    else:
        return "SMB"
$$;

-- Use in a query
SELECT customer_name, revenue, categorise_revenue(revenue) AS segment
FROM customers;
```

```sql
-- Table function (UDTF): Parse a delimited string into rows
CREATE OR REPLACE FUNCTION split_tags(tag_string VARCHAR, delimiter VARCHAR)
RETURNS TABLE(tag VARCHAR)
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
HANDLER = 'SplitTags'
AS
$$
class SplitTags:
    def process(self, tag_string: str, delimiter: str):
        if tag_string:
            for tag in tag_string.split(delimiter):
                yield (tag.strip(),)
$$;

-- Use in a query
SELECT order_id, t.tag
FROM orders, TABLE(split_tags(orders.tags, ',')) AS t;
```

### 📋 SQL Stored Procedures (Snowflake Scripting)

```sql
-- SQL procedure using Snowflake Scripting
CREATE OR REPLACE PROCEDURE refresh_all_marts()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
    table_count INTEGER DEFAULT 0;
    table_cursor CURSOR FOR
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'STAGING'
          AND table_type = 'BASE TABLE';
BEGIN
    FOR record IN table_cursor DO
        EXECUTE IMMEDIATE 'INSERT OVERWRITE INTO sproc_analytics.marts.' || record.table_name ||
            ' SELECT * FROM sproc_analytics.staging.' || record.table_name;
        table_count := table_count + 1;
    END FOR;

    RETURN 'Refreshed ' || table_count || ' mart tables';
END;
$$;

-- Call the procedure
CALL refresh_all_marts();
```

## 💡 Tutorial

In this tutorial, we'll be exploring how to create stored procedures and UDFs in Snowflake using both SQL and Python.
We'll build a scalar UDF for data classification, a table function for row expansion, and a stored procedure to automate
a data merge workflow.

By the end of this tutorial, you'll have gained a comprehensive understanding of how to extend Snowflake's functionality
with custom logic that can be called from SQL, scheduled via tasks, or integrated into data pipelines.

## 🎈 Conclusion

In conclusion, Stored Procedures and UDFs are essential tools for extending Snowflake's capabilities beyond its built-in
functions. Stored Procedures are ideal for orchestrating complex, multi-step workflows that include DDL and DML, whilst
UDFs allow you to embed custom logic directly within SQL queries. With support for Python, Java, Scala, and SQL,
Snowflake provides the flexibility to implement virtually any business logic directly within the platform.

## 📖 Additional Resources

- [Stored Procedures Documentation](https://docs.snowflake.com/en/sql-reference/stored-procedures-overview)
- [UDF Documentation](https://docs.snowflake.com/en/developer-guide/udf/udf-overview)
- [Snowflake Scripting](https://docs.snowflake.com/en/developer-guide/snowflake-scripting/index)
- [Python UDF Guide](https://docs.snowflake.com/en/developer-guide/udf/python/udf-python-introduction)

## ⚠️ Disclaimer

Please note that whilst we strive to keep this tutorial up-to-date, Snowflake's features and capabilities may change
over time. Always refer to the [official Snowflake documentation](https://docs.snowflake.com/) for the most accurate and
current information.
