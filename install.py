from service import util

sql_file_path = './sql/installation/create_log_table.sql'
util.execute_sql(sql_file_path)

sql_file_path = './sql/disable_logging.sql'
util.execute_sql(sql_file_path)

sql_file_path = './sql/installation/create_triggers.sql'
util.execute_sql(sql_file_path)
