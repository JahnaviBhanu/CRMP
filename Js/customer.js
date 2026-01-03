let currentPage = 1;
let limit = 5;

// Load customers on page load
window.onload = function () {
    loadCustomers(1);
};

function loadCustomers(page = 1) {
    currentPage = page;

    let searchText = $("#searchBox").val();   // <-- ❗ IMPORTANT

    $.ajax({
        url: "index.cfm?fuse=api_getcustomers",
        type: "GET",
        data: { page, limit, searchText },   // <-- SEND SEARCH TEXT
        dataType: "json",

        success: function (res) {
    let html = "";
    res.DATA.forEach(c => {
        html += `
            <tr>
                <td>${c.ID}</td>
                <td>${c.NAME}</td>
                <td>${c.EMAIL}</td>
                <td>${c.PHONE}</td>
                <td>
                     <button class="btn btn-success btn-sm" onclick="openEditModal(${c.ID}, '${c.NAME}', '${c.EMAIL}', '${c.PHONE}')">Edit</button>
                <button class="btn btn-danger btn-sm" onclick="deleteCustomer(${c.ID})">Delete</button>
                </td>
            </tr>
        `;
    });

    document.querySelector("#customerTableBody").innerHTML = html;
     refreshPagination();
    }


       
    });
}



// 🔵 SEARCH LIVE FILTER
$("#searchBox").on("keyup", function () {
    loadCustomers(1);  // reload with search
});




// ADD CUSTOMER
function addCustomer() {

    let name  = $("#name").val().trim();
    let email = $("#email").val().trim();
    let phone = $("#phone").val().trim();

    if (!name || !email || !phone) {
        return Swal.fire("Error", "All fields are required", "error");
    }

    if (!/^[0-9]{10}$/.test(phone)) {
        return Swal.fire("Error", "Phone must be 10 digits", "error");
    }

    $.ajax({
        url: "index.cfm?fuse=api_addcustomer",
        type: "POST",
        dataType: "json",
        data: { name, email, phone },

        success: function (res) {

            // ✅ EXACT key match
            if (res.SUCCESS === true) {
                Swal.fire("Success", "Customer added successfully", "success");

                loadCustomers(1);

                $("#name").val("");
                $("#email").val("");
                $("#phone").val("");
            } else {
                Swal.fire("Error", res.message || "Failed", "error");
            }
        },

        error: function (xhr) {
            console.error("RAW RESPONSE:", xhr.responseText);
            Swal.fire("Server Error", "Invalid JSON response", "error");
        }
    });
}



// UPDATE CUSTOMER
function updateCustomer() {

    let id = $("#editId").val();
    let name = $("#editName").val();
    let email = $("#editEmail").val();
    let phone = $("#editPhone").val();

    $.ajax({
        url: "index.cfm?fuse=api_editcustomer",
        type: "POST",
        data: { id, name, email, phone },
        success: function () {
            loadCustomers(currentPage);
            closeEditModal();
        }
    });
}

function openEditModal(id, name, email, phone) {
    $("#editId").val(id);
    $("#editName").val(name);
    $("#editEmail").val(email);
    $("#editPhone").val(phone);
    $("#editModal").show();
}

function closeEditModal() {
    $("#editModal").hide();
}



// DELETE CUSTOMER
function deleteCustomer(id) {
    if (!confirm("Delete this customer?")) return;

    $.ajax({
        url: "index.cfm?fuse=api_deletecustomer",
        type: "POST",
        data: { id },
        success: function () {
            loadCustomers(currentPage);
        }
    });
}
