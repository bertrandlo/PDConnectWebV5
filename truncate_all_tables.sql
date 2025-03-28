DO $$
DECLARE
    table_name TEXT;
BEGIN
    -- Disable all triggers to avoid constraints issues
    EXECUTE 'ALTER TABLE ALL IN SCHEMA public DISABLE TRIGGER ALL';

    -- Iterate through all tables in the current schema
    FOR table_name IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'public'
    LOOP
        -- Truncate each table
        EXECUTE 'TRUNCATE TABLE ' || quote_ident(table_name) || ' RESTART IDENTITY CASCADE';
    END LOOP;

    -- Enable all triggers back
    EXECUTE 'ALTER TABLE ALL IN SCHEMA public ENABLE TRIGGER ALL';
END $$;
