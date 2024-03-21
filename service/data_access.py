import psycopg2 as db_driver
import yaml
import pathlib


def load_database_config():
    path = str(pathlib.Path(__file__).parent.resolve()) + '/../db_config.yml'
    with open(path, 'r') as file:
        config = yaml.safe_load(file)
    return config['database']


def connect_to_database():
    db_config = load_database_config()
    conn = db_driver.connect(**db_config)
    return conn


def fetch_data_from_database(conn, limit=None):
    # Erstellen eines Cursors
    cur = conn.cursor()

    # Ausführen der sql-Abfrage
    if limit:
        query = f"SELECT * FROM event_log ORDER BY log_id ASC LIMIT {limit}"
    else:
        query = f"SELECT * FROM event_log ORDER BY log_id ASC"
    cur.execute(query)

    # Daten abrufen
    rows = cur.fetchall()

    # Schließen des Cursors und der Verbindung
    cur.close()
    conn.close()

    return rows

