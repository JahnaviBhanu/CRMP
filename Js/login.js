// Password Visibility Toggle
document.addEventListener("DOMContentLoaded", function () {
    const toggle = document.getElementById("togglePassword");
    const passwordField = document.getElementById("password");

    toggle.addEventListener("click", function () {

        // Switch input type
        const isHidden = passwordField.type === "password";
        passwordField.type = isHidden ? "text" : "password";

        // Switch icon
        if (isHidden) {
            toggle.classList.remove("bi-eye-slash");
            toggle.classList.add("bi-eye");
        } else {
            toggle.classList.remove("bi-eye");
            toggle.classList.add("bi-eye-slash");
        }
    });
});
