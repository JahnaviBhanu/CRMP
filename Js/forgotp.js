// ============================
// SHOW / HIDE PASSWORD
// ============================

const showPass = document.getElementById("showPassword");
const newPass = document.getElementById("newPassword");
const confirmPass = document.getElementById("confirmPassword");

if (showPass && newPass && confirmPass) {
    showPass.addEventListener("change", function () {
        const type = this.checked ? "text" : "password";
        newPass.type = type;
        confirmPass.type = type;
    });
}



// ============================
// OTP COUNTDOWN TIMER (5:00)
// ============================

const timerDisplay = document.getElementById("time");
const resendBtn = document.getElementById("resendBtn");

if (timerDisplay) {
    let timeLeft = 300; // 5 minutes

    let timer = setInterval(function () {
        let minutes = Math.floor(timeLeft / 60);
        let seconds = timeLeft % 60;

        seconds = seconds < 10 ? "0" + seconds : seconds;

        timerDisplay.textContent = `OTP expires in ${minutes}:${seconds}`;

        if (timeLeft <= 0) {
            clearInterval(timer);
            timerDisplay.textContent = "OTP expired!";

            if (resendBtn) {
                resendBtn.style.display = "block";
            }
        }

        timeLeft--;
    }, 1000);
}


// Live password strength check
const password = document.getElementById('password');
const rules = {
    r1: val => val.length >= 8,
    r2: val => /[A-Z]/.test(val),
    r3: val => /[a-z]/.test(val),
    r4: val => /[0-9]/.test(val),
    r5: val => /[^A-Za-z0-9]/.test(val)
};

password.addEventListener('input', () => {
    const val = password.value;
    for (const id in rules) {
        const li = document.getElementById(id);
        if (rules[id](val)) {
            li.style.color = 'green';
        } else {
            li.style.color = 'red';
        }
    }
});
