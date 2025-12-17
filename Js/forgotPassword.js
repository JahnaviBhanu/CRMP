document.addEventListener("DOMContentLoaded", function () {

    const pw1 = document.getElementById("newPassword");
    const pw2 = document.getElementById("confirmPassword");
    const msg = document.getElementById("matchMsg");

    if (pw1 && pw2) {
        function checkMatch() {
            if (!pw1.value && !pw2.value) {
                msg.textContent = "";
                return;
            }
            if (pw1.value === pw2.value) {
                msg.style.color = "green";
                msg.textContent = "Passwords match ✔";
            } else {
                msg.style.color = "red";
                msg.textContent = "Passwords do not match ✖";
            }
        }
        pw1.addEventListener("input", checkMatch);
        pw2.addEventListener("input", checkMatch);
    }

    document.querySelectorAll(".toggle").forEach(icon => {
        icon.addEventListener("click", function () {
            let id = icon.getAttribute("data-target");
            let input = document.getElementById(id);

            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                input.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        });
    });

});
