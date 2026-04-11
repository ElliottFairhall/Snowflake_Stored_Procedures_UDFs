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
SELECT
customer_name,
revenue,
categorise_revenue(revenue) AS segment
FROM customers;
