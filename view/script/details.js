// Details
// Funktion zum Einfügen der Werte in die Detail-Divs
function updateDetailDivs(e) {
    const target = e.currentTarget; // Das aktuelle Element, über das gehovert wird
    let index = target.getAttribute('data-index');
    let old_values_string = JSON.stringify(database_events[index].old_values);
    let new_values_string = JSON.stringify(database_events[index].new_values);

    let old_values_object = {};
    if (old_values_string != 'null') {
        old_values_object = JSON.parse(old_values_string)
    }

    let new_values_object = {};
    if (new_values_string != 'null') {
        new_values_object = JSON.parse(new_values_string)
    }

    document.getElementById('meta').innerHTML =
        "log_id: " + database_events[index].log_id + "</br>" +
        "action: " + database_events[index].action + "</br>" +
        "table_name: " + database_events[index].table_name + "</br></br>";
    document.getElementById('values').innerHTML = compareJSON(old_values_object, new_values_object);
}

function compareJSON(obj1, obj2) {
    const result = [];

    function compareValues(key, value1, value2, path) {
        const fullPath = path ? `${path}.${key}` : key;

        if (!(key in obj2)) {
            result.push(`<div class="deleted">${fullPath}: ${JSON.stringify(value1)} (gelöscht)</div>`);
        } else if (typeof value1 === 'object' && value1 !== null && typeof value2 === 'object' && value2 !== null) {
            Object.keys(value1).forEach(subKey => {
                compareValues(subKey, value1[subKey], value2[subKey], fullPath);
            });
            Object.keys(value2).forEach(subKey => {
                if (!(subKey in value1)) {
                    result.push(`<div class="new-value">${fullPath}.${subKey}: ${JSON.stringify(value2[subKey])} (neu)</div>`);
                }
            });
        } else if (value1 !== value2) {
            result.push(`<div>${fullPath}:<div class="old-value">alt: ${JSON.stringify(value1)}</div><div class="new-value">neu: ${JSON.stringify(value2)}</div></div>`);
        } else {
            result.push(`<div class="unchanged">${fullPath}: ${JSON.stringify(value1)}</div>`);
        }
    }

    Object.keys(obj1).forEach(key => {
        compareValues(key, obj1[key], obj2[key], '');
    });

    Object.keys(obj2).forEach(key => {
        if (!(key in obj1)) {
            result.push(`<div class="new-value">${key}: ${JSON.stringify(obj2[key])} (neu)</div>`);
        }
    });

    return result.join('\n');
}
