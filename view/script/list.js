// Liste
function generateListTable() {
    const column_names = new Set();
    database_events.forEach(database_event => column_names.add(database_event.table_name));

    // Tabellenkopf aufbauen
    const listTable = document.createElement('table');
    const headerRow = document.createElement('tr');
    headerRow.appendChild(document.createElement('th')); // Leere obere linke Zelle
    column_names.forEach(column_name => {
        const headerCell = document.createElement('th');
        headerCell.textContent = column_name;
        headerRow.appendChild(headerCell);
    });
    listTable.appendChild(headerRow);

    // Tabelle mit Inhalt füllen
    database_events.forEach((item, index) => {
        // Zeilen
        row = document.createElement('tr');
        const rowHeader = document.createElement('td');
        rowHeader.textContent = item.log_id;
        row.appendChild(rowHeader);
        column_names.forEach(column_name => {
            // Zellen
            let cell = document.createElement('td');
            row.appendChild(cell); // Leere Zellen für jede Spalte
            if (item.table_name === column_name) {
                // Erstellen Sie ein div, das die Action enthält und fügen Sie die Daten als Attribute hinzu
                const actionElement = document.createElement('div');
                actionElement.textContent = item.action; // Setzen Sie den Textinhalt auf action
                actionElement.setAttribute('data-index', index);
                cell.appendChild(actionElement);
            }
        });
        listTable.appendChild(row);
    });
    return listTable;
}

// Funktion zum Hinzufügen der Hover-Event-Listener
function addHoverListenersToListDivs() {
    const divsWithDataAttributes = document.querySelectorAll('div[data-index]');
    divsWithDataAttributes.forEach(div => {
        div.addEventListener('mouseenter', updateDetailDivs);
    });
}
