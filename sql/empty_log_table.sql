DO $$
DECLARE
    v_sequence_name text;
BEGIN
    TRUNCATE TABLE event_log;

    SELECT pg_get_serial_sequence('event_log', 'log_id') INTO v_sequence_name;

    EXECUTE 'ALTER SEQUENCE ' || v_sequence_name || ' RESTART WITH 1';
END $$;
