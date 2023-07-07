let monthCounter = 0;

const weekdays = [
  "maandag",
  "dinsdag",
  "woensdag",
  "donderdag",
  "vrijdag",
  "zaterdag",
  "zondag",
];

const calendarDiv = document.getElementById("room-history-list-days");

function load() {
  const date = new Date();

  if (monthCounter !== 0) {
    date.setMonth(new Date().getMonth() + monthCounter);
  }

  const day = date.getDate();
  const month = date.getMonth();
  const year = date.getFullYear();

  const firstDayOfMonth = new Date(year, month, 1);
  const monthDays = new Date(year, month + 1, 0).getDate();

  const dateString = firstDayOfMonth.toLocaleDateString("nl", {
    weekday: "long",
    year: "numeric",
    month: "numeric",
    day: "numeric",
  });

  const emptyDays = weekdays.indexOf(dateString.split(" ")[0]);

  document.getElementById(
    "room-history-month"
  ).innerText = `${date.toLocaleDateString("nl", { month: "long" })}, ${year}`;

  calendarDiv.innerHTML = "";

  for (let i = 1; i <= emptyDays + monthDays; i++) {
    const day = document.createElement("div");
    day.classList.add("day");

    if (i > emptyDays) {
      day.classList.add("border");
      day.innerText = i - emptyDays;
    } else {
      day.classList.add("emptyDay");
    }

    calendarDiv.appendChild(day);
  }
}

function buttonInit() {
  document
    .getElementById("room-history-next-month")
    .addEventListener("click", () => {
      monthCounter++;
      load();
    });

  document
    .getElementById("room-history-previous-month")
    .addEventListener("click", () => {
      monthCounter--;
      load();
    });
}

buttonInit();
load();
