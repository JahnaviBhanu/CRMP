document.addEventListener("DOMContentLoaded", function () {

    /* ================= SHOW / HIDE PASSWORD ================= */
    const showPasswordCheckbox = document.getElementById("showPassword");
    const passwordInput = document.getElementById("password");
    const confirmPasswordInput = document.getElementById("confirmPassword");

    if (showPasswordCheckbox && passwordInput && confirmPasswordInput) {
        showPasswordCheckbox.addEventListener("change", function () {
            const type = this.checked ? "text" : "password";
            passwordInput.type = type;
            confirmPasswordInput.type = type;
        });
    }

    /* ================= OTP TIMER ================= */
    const timerEl = document.getElementById("timer");
    const resendBtn = document.getElementById("resendBtn");

    if (timerEl) {
        let timeLeft = 120; // 2 minutes

        if (resendBtn) {
            resendBtn.disabled = true;
        }

        const interval = setInterval(function () {
            let minutes = Math.floor(timeLeft / 60);
            let seconds = timeLeft % 60;

            timerEl.innerText =
                `${minutes}:${seconds < 10 ? "0" : ""}${seconds}`;

            timeLeft--;

            if (timeLeft < 0) {
                clearInterval(interval);
                timerEl.innerText = "OTP Expired";
                timerEl.style.color = "red";

                if (resendBtn) {
                    resendBtn.disabled = false;
                }
            }
        }, 1000);
    }

});
