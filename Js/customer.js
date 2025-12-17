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
        url: "../components/customersAPI.cfc?method=getCustomers&returnformat=json",
        type: "GET",
        data: { page, limit, searchText },   // <-- SEND SEARCH TEXT
        dataType: "json",

        success: function (res) {
    let html = "";
    res.data.forEach(c => {
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

    console.log("AddCustomer CLICKED!");

    let name = $("#name").val().trim();
    let email = $("#email").val().trim();
    let phone = $("#phone").val().trim();

    // ❗ Phone must be EXACT 10 digits
    if (!/^[0-9]{10}$/.test(phone)) {
        return Swal.fire({
            icon: "error",
            title: "Invalid Phone",
            text: "Phone number must be exactly 10 digits!"
        });
    }

    $.ajax({
        url: "../components/customersAPI.cfc?method=addCustomer",
        type: "POST",
        dataType: "json",
        data: { name, email, phone },

        success: function (res) {
            if (res.success) {
                Swal.fire({
                    icon: "success",
                    title: "Customer Added!",
                    text: "Customer saved successfully."
                });

                loadCustomers(1);

                $("#name").val("");
                $("#email").val("");
                $("#phone").val("");
            }
            else {
        Swal.fire({
           icon: "error",
          title: "Error!",
          html: res.message  // show full DB error!
      });
     }
            
        },


        error: function (xhr, status, error) {
            Swal.fire({
                icon: "error",
                title: "Server Error",
                text: "Your CFC didn't return valid JSON. Check console."
            });
            console.error("AJAX Error:", xhr.responseText);
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
        url: "../components/customersAPI.cfc?method=updateCustomer",
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
        url: "../components/customersAPI.cfc?method=deleteCustomer",
        type: "POST",
        data: { id },
        success: function () {
            loadCustomers(currentPage);
        }
    });
}
