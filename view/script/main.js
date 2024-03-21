// Globales Array
let database_events;

// Daten aus API abrufen
async function fetchJsonDataFromApi(url) {
    let jsonData;
    try {
        const response = await fetch(url);
        jsonData = await response.json();
        return jsonData;
    } catch (error) {
        console.error("Fehler beim Abrufen der JSON-Daten:", error);
    }
}

// Endpunkt der API
const jsonDataUrl = "http://127.0.0.1:8000/data";

// Sicherstellen, dass addHoverListeners aufgerufen wird, nachdem die Tabelle generiert und ins DOM eingefügt wurde
fetchJsonDataFromApi(jsonDataUrl).then(jsonData => {
    if (jsonData && jsonData.data) {
        database_events = jsonData.data;
        const table = generateListTable();
        document.getElementById('list-container').appendChild(table);
        addHoverListenersToListDivs();
    } else {
        console.error("Keine Daten in JSON-Antwort gefunden");
    }
});