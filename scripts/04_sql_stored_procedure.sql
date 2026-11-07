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
