-- DROP FUNCTION public.event_log_trigger();

CREATE OR REPLACE FUNCTION public.event_log_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    enable_logging BOOLEAN := TRUE; -- Setzen der Variablen auf TRUE, um das Logging zu aktivieren
BEGIN
    -- Überprüfen, ob das Logging aktiviert ist
    IF enable_logging THEN
        IF TG_OP = 'INSERT' THEN
            INSERT INTO event_log(table_name, action, audit_time, new_values)
            VALUES (TG_TABLE_NAME, TG_OP, current_timestamp, row_to_json(NEW));
        ELSIF TG_OP = 'UPDATE' THEN
            INSERT INTO event_log(table_name, action, audit_time, old_values, new_values)
            VALUES (TG_TABLE_NAME, TG_OP, current_timestamp, row_to_json(OLD), row_to_json(NEW));
        ELSIF TG_OP = 'DELETE' THEN
            INSERT INTO event_log(table_name, action, audit_time, old_values)
            VALUES (TG_TABLE_NAME, TG_OP, current_timestamp, row_to_json(OLD));
        END IF;
    END IF;

    RETURN NEW;
END;
$function$
;