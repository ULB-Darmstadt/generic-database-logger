DO $$
DECLARE
    table_record RECORD;
    trigger_exists BOOLEAN;
    trigger_count INTEGER := 0; -- Zähler für die erstellten Trigger
    max_triggers INTEGER := 1000; -- Maximale Anzahl von zu erstellenden Triggern in einer einzelnen Skript-Ausführung
BEGIN
    FOR table_record IN SELECT table_schema, table_name FROM information_schema.tables
                        WHERE table_schema = 'public' -- Schema gegebenenfalls anpassen
                        AND table_type = 'BASE TABLE'
                        -- AND table_name LIKE 'eperson%' -- Einschränkung der Tabellen, für die Trigger erstellt werden
                        AND table_name NOT LIKE 'event_log' -- Logging-Tabelle selbst ausschließen, sonst zirkuläre Referenz
    LOOP
        IF trigger_count >= max_triggers THEN
            EXIT; -- Schleife verlassen, wenn das Limit erreicht ist
        END IF;

        -- Überprüfen, ob ein ähnlicher Trigger bereits existiert
        SELECT EXISTS (
            SELECT 1 FROM information_schema.triggers
            WHERE event_object_table = table_record.table_name
            AND event_object_schema = table_record.table_schema
            AND trigger_name = 'event_log_trigger'
        ) INTO trigger_exists;

        IF NOT trigger_exists THEN
            -- Starten Sie eine neue Transaktion für jede Trigger-Erstellung
            BEGIN
                EXECUTE 'CREATE TRIGGER event_log_trigger
                         AFTER INSERT OR UPDATE OR DELETE ON ' || quote_ident(table_record.table_schema) || '.' || quote_ident(table_record.table_name) || '
                         FOR EACH ROW EXECUTE FUNCTION event_log_trigger();';
                trigger_count := trigger_count + 1; -- Erhöhen des Zählers
                RAISE NOTICE 'Trigger auf Tabelle %.% erfolgreich erstellt.', table_record.table_schema, table_record.table_name;
            END;
        END IF;
    END LOOP;
END;
$$;