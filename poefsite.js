var totalPoef = document.getElementById("totalPoef");
var selectPerson = document.getElementById("selectPerson")
var selected = "VK";
var preference = "Totem";

var vkButton = document.getElementById("selectVK");
var lButton = document.getElementById("selectL");
var aButton = document.getElementById("selectA");

var searchButton = document.getElementById("search");
var selectedPerson = "";

var homeDivs = document.getElementsByClassName("home");
var personalDivs = document.getElementsByClassName("personal");


showHome();

$.getJSON("dataHome.json", function (data) {
    data.forEach(function (d) {
        if (d > 0) {
            totalPoef.style.color = 'lightred';
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
                if (preference == "Totem") {
                    options.innerHTML = d.Totem;
                } else {
                    options.innerHTML = d.Naam;
                }

                selectPerson.appendChild(options);
            }
        })
    })
}



vkButton.onclick = function () {
    resetButtons();
    vkButton.style.background = "#407ccd";
    vkButton.style.color = "#fff";
    selected = "VK";
    setSelect();
}

lButton.onclick = function () {
    resetButtons();
    lButton.style.background = "#407ccd";
    lButton.style.color = "#fff";
    selected = "L";
    setSelect();
}

aButton.onclick = function () {
    resetButtons();
    aButton.style.background = "#407ccd";
    aButton.style.color = "#fff";
    selected = "A";
    setSelect();
}


searchButton.onclick = function () {
    selectedPerson = selectPerson.options[selectPerson.selectedIndex].value;
    showPersonal()
    document.getElementById("totem").innerHTML = selectedPerson;
}

function showHome() {
    for (i = 0; i < personalDivs.length; i++) {
        personalDivs[i].style.display = "none";
    }
    for (i = 0; i < homeDivs.length; i++) {
        homeDivs[i].style.display = "flex";
    }
}

function showPersonal() {
    for (i = 0; i < personalDivs.length; i++) {
        personalDivs[i].style.display = "flex";
    }
    for (i = 0; i < homeDivs.length; i++) {
        homeDivs[i].style.display = "none";
    }

    $.getJSON("personDetails.json", function (data) {
        console.log(selectedPerson)
        var price = 0;
        data.forEach(function (d) {
            
            if (preference == "Totem") {
                
                if (d.totem == selectedPerson) {
                    price = d.price * -1;
                    document.getElementById("amount").innerHTML = "€" + price;
                }
            } else {
                console.log(d.name)
                if (d.name == selectedPerson) {
                    console.log(d)
                    price = d.price * -1;
                    document.getElementById("amount").innerHTML = "€" + price;
                }
            }
        })
        if(price < 0){
            document.getElementById("amount").style.color = 'red';
        } else {
            document.getElementById("amount").style.color = 'limegreen';
        }
    })
}

function resetButtons() {
    vkButton.style.background = "#fff";
    vkButton.style.color = "#407ccd";
    lButton.style.background = "#fff";
    lButton.style.color = "#407ccd";
    aButton.style.background = "#fff";
    aButton.style.color = "#407ccd";
}

document.getElementById("totemP").onclick = function () {
    preference = "Totem";
    setSelect();
}

document.getElementById("nameP").onclick = function () {
    preference = "Name";
    setSelect();
}
