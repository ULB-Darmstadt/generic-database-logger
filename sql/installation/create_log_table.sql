-- public.event_log definition

-- Drop table

-- DROP TABLE public.event_log;

CREATE TABLE public.event_log (
    log_id serial4 NOT NULL,
    table_name text NULL,
    "action" text NULL,
    audit_time timestamp NULL,
    old_values jsonb NULL,
    new_values jsonb NULL,
    CONSTRAINT event_log_pkey PRIMARY KEY (log_id)
);