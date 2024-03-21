-- Beim Löschen der Trigger darauf achten, dass keine andere Session (z.B. der betroffenen App) läuft, die auf Tabellen zugreift, sonst keine Ausführung möglich
DO $$
DECLARE
    table_record RECORD;
    trigger_record RECORD;
BEGIN
    FOR table_record IN SELECT table_schema, table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' -- AND table_name LIKE 'eperson%'
    LOOP
        FOR trigger_record IN SELECT trigger_name FROM information_schema.triggers WHERE event_object_table = table_record.table_name AND event_object_schema = table_record.table_schema AND trigger_name = 'event_log_trigger'
        LOOP
            BEGIN
                IF EXISTS (SELECT 1 FROM information_schema.triggers WHERE trigger_name = trigger_record.trigger_name AND event_object_table = table_record.table_name AND event_object_schema = table_record.table_schema) THEN
                    EXECUTE 'DROP TRIGGER ' || quote_ident(trigger_record.trigger_name) || ' ON ' || quote_ident(table_record.table_schema) || '.' || quote_ident(table_record.table_name) || ';';
                END IF;
            EXCEPTION
                WHEN OTHERS THEN
                    RAISE NOTICE 'Failed to drop trigger % on table %.%', trigger_record.trigger_name, table_record.table_schema, table_record.table_name;
            END;
        END LOOP;
    END LOOP;
END;
$$;