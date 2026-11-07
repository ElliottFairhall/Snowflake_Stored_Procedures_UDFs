# 🚀 Snowflake Stored Procedures & UDFs

> Architecture and design rationale: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)

[![Snowflake](https://img.shields.io/badge/Snowflake-Cloud%20Data%20Platform-29B5E8?style=flat&logo=snowflake)](https://www.snowflake.com/)
[![SQL & Python](https://img.shields.io/badge/Language-SQL%20%7C%20Python-orange)](https://docs.snowflake.com/)
[![Status](https://img.shields.io/badge/Status-Educational-success)](https://github.com/ElliottFairhall/Snowflake_Stored_Procedures_UDFs)

A practical guide to extending Snowflake's functionality using **Stored Procedures** and **User-Defined Functions
(UDFs)**. Learn how to encapsulate business logic, automate data workflows, and execute code using both SQL (Snowflake
Scripting) and Python.

______________________________________________________________________

## Key Features

- **Stored Procedures**: Automating DML operations and workflow orchestration.
- **Scalar UDFs**: Writing custom inline functions for data transformation.
- **Table Functions (UDTFs)**: Expanding rows and flattening JSON data.
- **Polyglot Processing**: Leveraging both SQL and Python for optimal performance.

______________________________________________________________________

## Project Structure

```text
Snowflake_Stored_Procedures_UDFs/
├── README.md               # You are here
├── Tutorial/
│   └── STORED_PROCEDURES_UDFS_TUTORIAL.md # Step-by-step walkthrough
├── scripts/                # Extracted implementation scripts
│   ├── 01_python_stored_procedure.sql
│   ├── 02_python_scalar_udf.sql
│   ├── 03_python_tabular_udtf.sql
│   └── 04_sql_stored_procedure.sql
├── notebook/
│   └── Stored_Procedures_UDFs_Tutorial.ipynb
└── data/                   # Initialised as empty
```

______________________________________________________________________

## Getting Started

> **Environment Setup:** Before beginning, execute `scripts/00_setup_environment.sql` to provision the necessary
> databases, schemas, and sample data for this project.

1. Read the **[Stored Procedures & UDFs Tutorial](Tutorial/STORED_PROCEDURES_UDFS_TUTORIAL.md)**.
2. Deploy the functions and procedures from the `scripts/` directory to test their behaviour.

______________________________________________________________________

## Author

**Elliott Fairhall** *Data Engineering Educational Series*
