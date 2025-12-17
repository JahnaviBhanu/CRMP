// Runs automatically on normal pages
document.addEventListener("DOMContentLoaded", () => {
    initPagination();
});

// Runs manually after any AJAX table update
function refreshPagination() {
    initPagination();
}

function initPagination() {
    const table = document.querySelector("table");
    if (!table) return;

    const rows = Array.from(table.querySelectorAll("tr"));
    if (rows.length <= 1) return;

    const dataRows = rows.slice(1);
    const pageSize = 5;
    let currentPage = 1;

    // Remove old pagination
    const oldControls = document.getElementById("paginationControls");
    if (oldControls) oldControls.remove();

    // Create pagination container
    const controls = document.createElement("div");
    controls.id = "paginationControls";
    table.after(controls);

    function renderTable() {
        dataRows.forEach(row => row.style.display = "none");

        const start = (currentPage - 1) * pageSize;
        const end = start + pageSize;

        dataRows.slice(start, end).forEach(row => {
            row.style.display = "";
        });

        renderButtons();
    }

    function renderButtons() {
        controls.innerHTML = "";
        const totalPages = Math.ceil(dataRows.length / pageSize);

        const prevBtn = createButton("Previous", () => {
            if (currentPage > 1) {
                currentPage--;
                renderTable();
            }
        });
        prevBtn.disabled = currentPage === 1;
        controls.appendChild(prevBtn);

        for (let i = 1; i <= totalPages; i++) {
            const btn = createButton(i, () => {
                currentPage = i;
                renderTable();
            });
            if (i === currentPage) btn.classList.add("active");
            controls.appendChild(btn);
        }

        const nextBtn = createButton("Next", () => {
            if (currentPage < totalPages) {
                currentPage++;
                renderTable();
            }
        });
        nextBtn.disabled = currentPage === totalPages;
        controls.appendChild(nextBtn);
    }

    function createButton(text, onClick) {
        const btn = document.createElement("button");
        btn.textContent = text;
        btn.classList.add("page-btn");
        btn.addEventListener("click", onClick);
        return btn;
    }

    renderTable();
}