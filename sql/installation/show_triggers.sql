SELECT
    trigger_schema,
    event_object_table AS table_name,
    trigger_name,
    action_timing AS trigger_timing,
    event_manipulation AS trigger_event,
    action_statement
FROM information_schema.triggers
WHERE event_object_schema = 'public'
  AND event_object_table IN (
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_type = 'BASE TABLE'
  )
ORDER BY table_name, trigger_name;