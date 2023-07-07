const togglePassword = document.querySelector("#togglePassword");
const password = document.querySelector("#wachtwoord");

let isVisible = false;
togglePassword.addEventListener("click", function (e) {
    if (isVisible == false) {
        isVisible = true;
        document.getElementById("togglePassword").textContent = "visibility";
    } else {
        isVisible = false;
        document.getElementById("togglePassword").textContent = "visibility_off";
    }
    const type = password.getAttribute("type") === "password" ? "text" : "password";
    password.setAttribute("type", type);
})