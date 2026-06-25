// Initial flight data

const originalFlights = [

{
    time:"15:05",
    flight:"NH 0175",
    dest:"TOKYO",
    gate:"D02",
    status:"ON TIME"
},
{
    time:"15:15",
    flight:"WN 0612",
    dest:"LAS VEGAS",
    gate:"B09",
    status:"BOARDING"
},
{
    time:"12:59",
    flight:"F9 1635",
    dest:"BOSTON",
    gate:"B05",
    status:"DELAYED"
},
{
    time:"13:11",
    flight:"AS 3188",
    dest:"NEW YORK",
    gate:"D12",
    status:"ON TIME"
},
{
    time:"13:37",
    flight:"BA 1760",
    dest:"SAN FRANCISCO",
    gate:"B20",
    status:"BOARDING"
}

];

// Working copy

let flights = originalFlights.map(f => ({...f}));

// DOM references

const board = document.getElementById("board");
const counter = document.getElementById("counter");

// Store status cell references

const statusCells = [];

// Update live clock

function updateClock(){

    const now = new Date();

    document.getElementById("clock").textContent =
    now.toLocaleTimeString("en-US",{
        hour12:false
    });
}

setInterval(updateClock,1000);
updateClock();


// Create one cell

function createCell(text){

    const cell = document.createElement("div");

    cell.classList.add("cell");

    cell.textContent = text;

    return cell;
}


// Apply status color

function applyStatusClass(cell,status){

    cell.classList.remove(
        "on-time",
        "boarding",
        "delayed",
        "closed",
        "departed"
    );

    switch(status){

        case "ON TIME":
            cell.classList.add("on-time");
            break;

        case "BOARDING":
            cell.classList.add("boarding");
            break;

        case "DELAYED":
            cell.classList.add("delayed");
            break;

        case "GATE CLOSED":
            cell.classList.add("closed");
            break;

        case "DEPARTED":
            cell.classList.add("departed");
            break;
    }
}


// Build a flight row entirely with DOM

function createFlightRow(flight,index){

    const row = document.createElement("div");
    row.classList.add("row");

    const timeCell = createCell(flight.time);
    const flightCell = createCell(flight.flight);
    const destCell = createCell(flight.dest);
    const gateCell = createCell(flight.gate);

    const statusCell = createCell(flight.status);

    applyStatusClass(statusCell,flight.status);

    // Store reference for live updates

    statusCells[index] = statusCell;

    row.appendChild(timeCell);
    row.appendChild(flightCell);
    row.appendChild(destCell);
    row.appendChild(gateCell);
    row.appendChild(statusCell);

    board.appendChild(row);
}


// Update summary counter

function updateCounter(){

    const boarding =flights.filter(f => f.status === "BOARDING").length;

    const delayed =flights.filter(f => f.status === "DELAYED").length;

    counter.textContent =  `${flights.length} departures · ${boarding} boarding · ${delayed} delayed`;

    
}


// Render entire board

function renderBoard(){

    board.textContent = "";

    statusCells.length = 0;

    const headerRow = document.createElement("div");
    headerRow.classList.add("row","header-row");

    headerRow.appendChild(createCell("TIME"));
    headerRow.appendChild(createCell("FLIGHT"));
    headerRow.appendChild(createCell("DESTINATION"));
    headerRow.appendChild(createCell("GATE"));
    headerRow.appendChild(createCell("STATUS"));

    board.appendChild(headerRow);

    flights.forEach((flight,index)=>{

        createFlightRow(flight,index);

    });

    updateCounter();
}


// Add Departure Button
const extraFlights = [

{
    time:"16:45",
    flight:"UA 9901",
    dest:"DALLAS",
    gate:"A15",
    status:"ON TIME"
},
{
    time:"17:10",
    flight:"EK 204",
    dest:"DUBAI",
    gate:"C18",
    status:"ON TIME"
},
{
    time:"17:25",
    flight:"SQ 801",
    dest:"SINGAPORE",
    gate:"D06",
    status:"BOARDING"
},
{
    time:"18:05",
    flight:"LH 441",
    dest:"FRANKFURT",
    gate:"B12",
    status:"ON TIME"
}
];

document.getElementById("addBtn")
.addEventListener("click",()=>{

    const randomFlight =
    extraFlights[
        Math.floor(Math.random()*extraFlights.length)
    ];

    flights.push({...randomFlight});

    renderBoard();
});

// Reset Button

document.getElementById("resetBtn").addEventListener("click",()=>{

    flights = originalFlights.map(f => ({...f}));

    renderBoard();
});


// Live status updates

const statusFlow = [

    "ON TIME",
    "BOARDING",
    "GATE CLOSED",
    "DEPARTED"
];

function updateRandomFlightStatus(){

    if(flights.length === 0) return;

    const randomIndex =Math.floor(Math.random()*flights.length);

    const currentStatus =flights[randomIndex].status;

    let nextStatus;

    const currentPosition =statusFlow.indexOf(currentStatus);

    if(currentPosition === -1){

        nextStatus = "ON TIME";
    }
    else{

        nextStatus =
        statusFlow[(currentPosition + 1) % statusFlow.length];
    }

    flights[randomIndex].status = nextStatus;

    // Update ONLY the affected status cell

    const statusCell =statusCells[randomIndex];

    if(statusCell){

        statusCell.textContent = nextStatus;

        applyStatusClass(
            statusCell,
            nextStatus
        );
    }

    updateCounter();
}

setInterval(updateRandomFlightStatus,5000);

// Initial render

renderBoard();