from service.data_access import connect_to_database, fetch_data_from_database
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

app = FastAPI()

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # erlaubt Anfragen von allen Ursprünge
    allow_credentials=True,
    allow_methods=["*"],  # erlaubt alle HTTP-Methoden
    allow_headers=["*"],
)


@app.get("/data")
def get_data():
    # Verbindung zur Datenbank herstellen
    conn = connect_to_database()

    # Daten abrufen
    rows = fetch_data_from_database(conn)

    # Jede Zeile in ein Wörterbuch umwandeln
    data = []
    for row in rows:
        row_dict = {
            "log_id": row[0],
            "table_name": row[1],
            "action": row[2],
            "datetime": row[3].isoformat(),
            "old_values": row[4],
            "new_values": row[5]
        }
        data.append(row_dict)

    return {"data": data}


if __name__ == "__main__":
    uvicorn.run("main:app", host="localhost", port=8000, log_level="info")
