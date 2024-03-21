import os
import service.data_access as data_access


def execute_python(script_path):

    # Baut den Befehl zum Starten des Python-Skripts
    command = f'python "{script_path}"'

    # Startet das Skript als eigenständigen Prozess
    os.system(command)


def execute_sql(sql_file_path):
    # Verbindung zur Datenbank herstellen
    try:
        conn = data_access.connect_to_database()
        cursor = conn.cursor()

        # SQL-Anweisungen aus der Datei lesen
        with open(sql_file_path, 'r', encoding='utf-8') as file:
            sql_script = file.read()

        # SQL-Anweisungen ausführen
        cursor.execute(sql_script)
        conn.commit()

        print("SQL-Anweisungen wurden erfolgreich ausgeführt.")

    except ConnectionError as e:
        print(f"Ein Fehler ist aufgetreten: {e}")
        conn.rollback()

