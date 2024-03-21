from service import util
import webbrowser
import os

empty_log_table = False
open_log_web_page = True

# Empty log table
if empty_log_table:
    sql_file_path = './sql/empty_log_table.sql'
    util.execute_sql(sql_file_path)

# Enable logging
sql_file_path = './sql/enable_logging.sql'
util.execute_sql(sql_file_path)

# Open Webpage
html_file_path = './view/index.html'
absolute_html_file_path = os.path.abspath(html_file_path)
if open_log_web_page:
    webbrowser.open(f'file://{absolute_html_file_path}')

# Start API
script_path = 'main.py'
util.execute_python(script_path)
