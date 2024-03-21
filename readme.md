
Generic Database Logger (GDL)  
  
Zusammenfassung:  
- Funktion: Aufzeichnung und Visualisierung aller Datenbank-Veränderungen  
- Zweck: Logging, Debugging, Verstehen von Software und ihrer Datenbank 

Einschränkungen:
- Zugriff auf eingesetzte Datenbank nötig (Login mit ausreichend Rechten)
- SQL und Treiber sind zurzeit auf Postgres abgestimmt, für andere DB: anpassen
- Code geht von public-Schema aus, bei Nutzung eines anderen Schemas: anpassen
  
Aufbau/Funktionsweise:  
- Datenbank (SQL): Es werden Tabellen-Trigger erstellt, welche bei Veränderungen eine Logging-Funktion aufrufen. Diese speichert alle Veränderungen in einer Logging-Tabelle  
- Mini-API (Python): Ruft die Daten aus der Logging-Tabelle ab und stellt diese als JSON bereit  
- Webseite (HTML, CSS, JS): Ruft die JSON-Daten aus der API auf und visualisiert diese  
  
Einmalige Einrichtung:
 - Python-Umgebung
   - Voraussetzungen: Python 3.11 und pip 23.3
   - Pakete installieren: pip install -r requirements.txt
 - Datenbank-Zugang
   - db_config_EXAMPLE.yml als db_config.yml kopieren
   - in neuer db_config.yml: Datenbank-Zugang eintragen
 - install.py ausführen, um Datenbank einzurichten:
   - Logging-Tabelle erstellen: sql/installation/create_log_table.sql
   - Logging-Funktion (deaktiviert) erstellen: sql/disable_logging.sql
   - Logging-Trigger erstellen: sql/installation/create_triggers.sql
 
Anwendung:  
 - start_log.py ausführen, das Skript übernimmt folgende Schritte:
   - main.py starten, um die API zu aktivieren
   - sql/empty_log_table.sql ausführen (optional, um Log zu leeren)
   - sql/enable_logging.sql ausführen (Starten der Aufzeichnung)
   - Öffnen der Webseite view/index.html (optional)
 - die Aktion in der Software durchführen, die man aufzeichnen will
 - stop_log.py ausführen, übernimmt folgenden Schritt:
   - sql/disable_logging.sql ausführen (Stoppen der Aufzeichnung)
 - Webseite view/index.html aufrufen/aktualisieren