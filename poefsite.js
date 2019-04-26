var totalPoef = document.getElementById("totalPoef");
var selectPerson = document.getElementById("selectPerson")
var selected = "VK";
var preference = "Totem";

var vkButton = document.getElementById("selectVK");
var lButton = document.getElementById("selectL");
var aButton = document.getElementById("selectA");

var searchButton = document.getElementById("search");
var selectedPerson = "";

var adminButton = document.getElementById("adminPage");

var homeDivs = document.getElementsByClassName("home");
var adminDivs = document.getElementsByClassName("admin");
var personalDivs = document.getElementsByClassName("personal");


showHome();

$.getJSON("dataHome.json", function (data) {
    data.forEach(function (d) {
        if (d > 0) {
            totalPoef.style.color = 'red';
            totalPoef.innerHTML = "-€" + d;
        } else {
            totalPoef.style.color = 'limegreen';
            totalPoef.innerHTML = d;
        }
    })
})



function setSelect() {
    $.getJSON("dataTotems.json", function (data) {
        selectPerson.innerHTML = "";
        var options = document.createElement('option');
        data.forEach(function (d) {
            options = document.createElement('option');
            if (d.Tak == selected) {
                if (preference == "Totem" && d.Totem != "NA ") {
                    options.innerHTML = d.Totem;
                    selectPerson.appendChild(options);
                } else if (d.Naam != undefined) {
                    options.innerHTML = d.Naam;
                    selectPerson.appendChild(options);
                }
            }

        })
    })
}



vkButton.onclick = function () {
    resetButtons();
    vkButton.style.background = "#0CAD9A";
    vkButton.style.color = "#fff";
    selected = "VK";
    setSelect();
}

lButton.onclick = function () {
    resetButtons();
    lButton.style.background = "#0CAD9A";
    lButton.style.color = "#fff";
    selected = "L";
    setSelect();
}

aButton.onclick = function () {
    resetButtons();
    aButton.style.background = "#0CAD9A";
    aButton.style.color = "#fff";
    selected = "A";
    setSelect();
}


searchButton.onclick = function () {
    selectedPerson = selectPerson.options[selectPerson.selectedIndex].value;
    showPersonal()
    document.getElementById("totem").innerHTML = selectedPerson;
}

adminButton.onclick = function(){
    showAdmin();
}

function showHome() {
    for (i = 0; i < personalDivs.length; i++) {
        personalDivs[i].style.display = "none";
    }
    for (i = 0; i < homeDivs.length; i++) {
        homeDivs[i].style.display = "flex";
    }
    for (i = 0; i < adminDivs.length; i++) {
        adminDivs[i].style.display = "none";
    }
}

function showAdmin() {
    for (i = 0; i < personalDivs.length; i++) {
        personalDivs[i].style.display = "none";
    }
    for (i = 0; i < homeDivs.length; i++) {
        homeDivs[i].style.display = "none";
    }
    for (i = 0; i < adminDivs.length; i++) {
        adminDivs[i].style.display = "flex";
    }
}

function showPersonal() {
    for (i = 0; i < adminDivs.length; i++) {
        adminDivs[i].style.display = "none";
    }
    for (i = 0; i < personalDivs.length; i++) {
        personalDivs[i].style.display = "flex";
    }
    for (i = 0; i < homeDivs.length; i++) {
        homeDivs[i].style.display = "none";
    }

    $.getJSON("personDetails.json", function (data) {
        var price = 0;
        data.forEach(function (d) {
            if (preference == "Totem") {
                if (d.totem[0].totem == selectedPerson) {
                    price = d.price[0].price * -1;
                    document.getElementById("amount").innerHTML = "€" + price;
                    createTables(d)
                }
            } else {
                var name = "";

                if (d.name[0] != null && d.name[0] != undefined) {
                    name = d.name[0].replace(/\s/g, '').toLocaleLowerCase()
                }
                if (name == selectedPerson.replace(/\s/g, '').toLocaleLowerCase()) {

                    price = d.price[0].price * -1;
                    document.getElementById("amount").innerHTML = "€" + price;
                    createTables(d)

                }
            }
        })
        if (price < 0) {
            document.getElementById("amount").style.color = 'red';
        } else {
            document.getElementById("amount").style.color = 'limegreen';
        }
    })
}

function createTables(d) {
    var trH = document.createElement('tr');
    var th1 = document.createElement('th');
    var th2 = document.createElement('th');
    th1.innerHTML = "Datum";
    th2.innerHTML = "Bedrag";
    trH.append(th1, th2);
    var table = document.getElementById("lastBeer");
    table.innerHTML = "";
    table.append(trH);

    var trH = document.createElement('tr');
    var th1 = document.createElement('th');
    var th2 = document.createElement('th');
    th1.innerHTML = "Reden";
    th2.innerHTML = "Bedrag";
    trH.append(th1, th2);
    var tableExp = document.getElementById("lastExpenses");
    tableExp.innerHTML = "";
    tableExp.append(trH);

    var trH = document.createElement('tr');
    var th1 = document.createElement('th');
    var th2 = document.createElement('th');
    th1.innerHTML = "Datum";
    th2.innerHTML = "Bedrag";
    trH.append(th1, th2);
    var tablePay = document.getElementById("payments");
    tablePay.innerHTML = "";
    tablePay.append(trH);
    
    
    var trH = document.createElement('tr');
    var th1 = document.createElement('th');
    var th2 = document.createElement('th');
      var th3 = document.createElement('th');
    th1.innerHTML = "Datum";
    th2.innerHTML = "Aantal";
    th3.innerHTML = "Bedrag";
    trH.append(th1, th2, th3);
    var tableR = document.getElementById("rounds");
    tableR.innerHTML = "";
    tableR.append(trH);

    var maxRows = 0;
    d.bakken[0].forEach(function (b) {
        if (maxRows < 5) {
            //Beer table
            var td1 = document.createElement('td');
            var td2 = document.createElement('td');
            var tr = document.createElement('tr');
            td1.innerHTML = b.date;
            td2.innerHTML = b.amount;
            td2.style.color = "red";
            td1.classList = "left";
            td2.classList = "right";
            tr.append(td1, td2);
            table.appendChild(tr);
            maxRows++;
        }
    })
    while (table.rows.length < 6) {
        var td1 = document.createElement('td');
        var td2 = document.createElement('td');
        var tr = document.createElement('tr');
        td1.innerHTML = "/";
        td2.innerHTML = "/";
        td1.classList = "left";
        td2.classList = "right";
        tr.append(td1, td2);
        table.appendChild(tr);
    }

    maxRows = 0;
    d.betalingen[0].forEach(function (b) {
        if (maxRows < 5) {
            //Payments table
            var td1 = document.createElement('td');
            var td2 = document.createElement('td');
            var tr = document.createElement('tr');
            td1.innerHTML = b.date;
            td2.innerHTML = b.amount;
            td2.style.color = "limegreen";
            td1.classList = "left";
            td2.classList = "right";
            tr.append(td1, td2);
            tablePay.appendChild(tr);
            maxRows++
        }
        maxRows++;
    });
    while (tablePay.rows.length < 6) {
        var td1 = document.createElement('td');
        var td2 = document.createElement('td');
        var tr = document.createElement('tr');
        td1.innerHTML = "/";
        td2.innerHTML = "/";
        td1.classList = "left";
        td2.classList = "right";
        tr.append(td1, td2);
        tablePay.appendChild(tr);
    }

    maxRows = 0;
    d.andereKosten[0].forEach(function (b) {
        if (maxRows < 5) {
            //Expences table
            var td1 = document.createElement('td');
            var td2 = document.createElement('td');
            var tr = document.createElement('tr');
            td1.innerHTML = b.date;
            td2.innerHTML = b.amount;
            td2.style.color = "red";
            td1.classList = "left";
            td2.classList = "right";
            tr.append(td1, td2);
            tableExp.appendChild(tr);
        }
        maxRows++;
    });
    while (tableExp.rows.length < 6) {
        var td1 = document.createElement('td');
        var td2 = document.createElement('td');
        var tr = document.createElement('tr');
        td1.innerHTML = "/";
        td2.innerHTML = "/";
        td1.classList = "left";
        td2.classList = "right";
        tr.append(td1, td2);
        tableExp.appendChild(tr);
    }
    
    maxRows = 0;
    d.rondjes[0].forEach(function (b) {
        if (maxRows < 5) {
            //Rounds table
            var td1 = document.createElement('td');
            var td2 = document.createElement('td');
            var td3 = document.createElement('td');
            var tr = document.createElement('tr');
            td1.innerHTML = b.date;
            td3.innerHTML = b.amount;
            td2.innerHTML = b.count;
            td2.style.color = "red";
            td1.classList = "left";
            td2.classList = "right";
            tr.append(td1, td3, td2);
            tableR.appendChild(tr);
        }
        maxRows++;
    });
    while (tableR.rows.length < 6) {
        var td1 = document.createElement('td');
            var td2 = document.createElement('td');
            var td3 = document.createElement('td');
            var tr = document.createElement('tr');
            td1.innerHTML = "/";
            td3.innerHTML = "/";
            td2.innerHTML = "/";
            td1.classList = "left";
            td2.classList = "right";
            tr.append(td1, td3, td2);
        tableR.appendChild(tr);
    }
}

function resetButtons() {
    vkButton.style.background = "#fff";
    vkButton.style.color = "#0CAD9A";
    lButton.style.background = "#fff";
    lButton.style.color = "#0CAD9A";
    aButton.style.background = "#fff";
    aButton.style.color = "#0CAD9A";
}


document.getElementById("totemP").onclick = function () {
    preference = "Totem";
    setSelect();
}

document.getElementById("nameP").onclick = function () {
    preference = "Name";
    setSelect();
}
