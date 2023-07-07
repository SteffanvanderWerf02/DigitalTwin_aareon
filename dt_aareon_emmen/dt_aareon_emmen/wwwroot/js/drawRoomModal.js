let canvas = document.getElementById("myCanvas");
let ctx = canvas.getContext("2d");
let inputField = document.getElementById('coordinates');

let coordinates = [];

function loadImage() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    let img = new Image();
    img.src = src;
    ctx.drawImage(img, 0, 0, 1156 * (img.width / img.height), 1156);
}

function saveCoordinates(event) {
    let rect = canvas.getBoundingClientRect();
    let x = event.clientX - rect.left;
    let y = event.clientY - rect.top

    coordinates.push({ x: x * 2, y: y * 2 });

    drawPoints();

    console.log("Coördinaten opgeslagen: x=" + x + ", y=" + y);
}

function drawPoints() {
    loadImage();

    coordinates.forEach((coord, i) => {
        if (i + 1 < coordinates.length) {
            ctx.beginPath();
            ctx.moveTo(coord.x, coord.y);
            ctx.lineTo(coordinates[i + 1].x, coordinates[i + 1].y);
            ctx.lineWidth = 3;
            ctx.strokeStyle = "green";
            ctx.stroke();
        }

        if (coordinates.length > 2) {
            if (i == coordinates.length - 1) {
                ctx.beginPath();
                ctx.moveTo(coord.x, coord.y);
                ctx.lineTo(coordinates[0].x, coordinates[0].y);
                ctx.lineWidth = 3;
                ctx.strokeStyle = "green";
                ctx.stroke();
            }
        }

        ctx.beginPath();
        ctx.arc(coord.x, coord.y, 10, 0, 2 * Math.PI);
        ctx.fillStyle = "#30529c";
        ctx.fill();
    })
}

function updateOutputString() {
    var returnString = "";

    coordinates.forEach((coord) => {
        returnString += Math.round(coord.x / 2) + "," + Math.round(coord.y / 2) + " "
    })

    inputField.value = returnString;
}

function clearCanvas() {
    inputField.value = "";
    coordinates = [];
    loadImage();
}

loadImage();
canvas.addEventListener("click", saveCoordinates);