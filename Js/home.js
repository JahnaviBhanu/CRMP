// Toggle the dropdown menu visibility when clicking the hamburger icon
function toggleMenu() {
    var menu = document.getElementById("dropdownMenu");
    menu.classList.toggle("show");
}

// Close menu if user clicks outside
document.addEventListener("click", function(e) {
    var menu = document.getElementById("dropdownMenu");
    var menuContainer = document.querySelector(".menu-container");

    // Close the menu if click is outside of the menu and the menu button
    if (!menu.contains(e.target) && !menuContainer.contains(e.target)) {
        menu.classList.remove("show");
    }
});
