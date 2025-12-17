// Auto session timeout after 1 hour
var sessionTimeoutMs = 60 * 60 * 1000;

setTimeout(function () {
    window.location.href = "/CRMP/index.cfm?page=login&msg=sessionExpired";
}, sessionTimeoutMs);

// Toggle dropdown menu
function toggleMenu() {
    var menu = document.getElementById("dropdownMenu");
    if (menu) {
        menu.classList.toggle("show");
    }
}

// Close menu when clicking outside
document.addEventListener("click", function (e) {
    var menu = document.getElementById("dropdownMenu");
    var menuContainer = document.querySelector(".menu-container");

    if (!menu || !menuContainer) return;

    if (!menu.contains(e.target) && !menuContainer.contains(e.target)) {
        menu.classList.remove("show");
    }
});
