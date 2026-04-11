-- =============================================================================
-- 00_SETUP_ENVIRONMENT
-- =============================================================================
-- Purpose:    Provision the necessary databases, schemas, and sample data
--             to serve as the foundation for the Stored Procedures tutorial.
-- =============================================================================

USE ROLE SYSADMIN;

-- 1. Create base DBs and Schemas
CREATE DATABASE IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS RAW.STAGING;

CREATE DATABASE IF NOT EXISTS ANALYTICS;
CREATE SCHEMA IF NOT EXISTS ANALYTICS.MARTS;
CREATE SCHEMA IF NOT EXISTS ANALYTICS.STAGING;

-- 2. Populate Customers in Staging and Marts for Merge procedure
CREATE OR REPLACE TABLE RAW.STAGING.CUSTOMERS (
    CUSTOMER_ID INT,
    CUSTOMER_NAME VARCHAR,
    EMAIL VARCHAR
);

INSERT INTO RAW.STAGING.CUSTOMERS VALUES
    (1, 'Alice Update', 'alice.new@example.com'),
    (2, 'Bob Stable', 'bob@example.com'),
    (4, 'David New', 'david@example.com');

CREATE OR REPLACE TABLE ANALYTICS.MARTS.DIM_CUSTOMERS (
    CUSTOMER_ID INT,
    CUSTOMER_NAME VARCHAR,
    EMAIL VARCHAR,
    CREATED_AT TIMESTAMP_NTZ,
    UPDATED_AT TIMESTAMP_NTZ
);

INSERT INTO ANALYTICS.MARTS.DIM_CUSTOMERS VALUES
    (1, 'Alice Old', 'alice.old@example.com', CURRENT_TIMESTAMP(), NULL),
    (2, 'Bob Stable', 'bob@example.com', CURRENT_TIMESTAMP(), NULL),
    (3, 'Charlie Delete', 'charlie@example.com', CURRENT_TIMESTAMP(), NULL);

-- 3. Populate base customers table for UDF categorisation
CREATE OR REPLACE TABLE PUBLIC.CUSTOMERS (
    CUSTOMER_NAME VARCHAR,
    REVENUE NUMBER(10, 2)
);

INSERT INTO PUBLIC.CUSTOMERS VALUES
    ('Enterprise Corp', 150000.00),
    ('Small Shop', 15000.00),
    ('Mid-Market Inc', 45000.00),
    ('Unknown Entity', NULL);

-- 4. Populate orders table for Table Function (UDTF)
CREATE OR REPLACE TABLE PUBLIC.ORDERS (
    ORDER_ID INT,
    TAGS VARCHAR
);

INSERT INTO PUBLIC.ORDERS VALUES
    (101, 'electronics,sale,priority'),
    (102, 'clothing,clearance'),
    (103, 'grocery');

-- 5. Populate staging tables for SQL procedure
CREATE OR REPLACE TABLE ANALYTICS.STAGING.TABLE_A (ID INT);
CREATE OR REPLACE TABLE ANALYTICS.MARTS.TABLE_A (ID INT);
INSERT INTO ANALYTICS.STAGING.TABLE_A VALUES (1), (2), (3);

CREATE OR REPLACE TABLE ANALYTICS.STAGING.TABLE_B (ID INT);
CREATE OR REPLACE TABLE ANALYTICS.MARTS.TABLE_B (ID INT);
INSERT INTO ANALYTICS.STAGING.TABLE_B VALUES (4), (5);
