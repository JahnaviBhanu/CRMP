
<cfif NOT structKeyExists(session, "role") OR session.role NEQ "admin">
    <h2 style="color:red;">❌ Unauthorized Access</h2>
    <cflocation url="home.cfm" addtoken="false">
    <cfabort>
</cfif>



<link rel="stylesheet" href="css/customer.css">
<link rel="stylesheet" href="css/pagination.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="Js/customer.js"></script>




<div class="container">

    <h2 class="page-title">Customer Management</h2>

    <!-- Search Bar -->
    <div class="search-section">
    <input type="text" id="searchBox" placeholder="Search by Name / Email" 
       class="form-control"
       onkeyup="loadCustomers(1)">
        <button class="">
    <a href="reports/downloadCustomers.cfm" target="_blank" class="download-btn">
    <i class="fa fa-download"></i></a>


    </div>

    <!-- Add form -->
    <div class="add-form">
        <input type="text" id="name" placeholder="Name">
        <input type="email" id="email" placeholder="Email">
        <input type="text" id="phone" placeholder="Phone">
        <button class="btn btn-primary" onclick="addCustomer()">AddCustomer</button>
    </div>

    <!-- Table -->
    <table class="customer-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Action</th>
            </tr>
        </thead>
       <tbody id="customerTableBody"></tbody>
    </table>
<div id="paginationControls"></div>
</div>

<!-- Modal -->
<div class="modal-overlay" id="editModal">
    <div class="modal-box">
        
        <div class="modal-header">
            <h2>Edit Customer</h2>
            <span class="close-x" onclick="closeEditModal()">×</span>
        </div>

        <div class="modal-body">
            <input type="hidden" id="editId">

            <label>Name:</label>
            <input type="text" id="editName">

            <label>Email:</label>
            <input type="email" id="editEmail">

            <label>Phone:</label>
            <input type="text" id="editPhone">
        </div>

        <div class="modal-footer">
            <button class="btn btn-primary" onclick="updateCustomer()">Update</button>
            <button class="btn btn-secondary" onclick="closeEditModal()">Cancel</button>
            
        </div> 

    </div>
<div id="pagination"></div>

<script src="Js/pagination.js"></script>



</div>

<a href="home.cfm" class="home-btn">&#8592; Back to Home</a>
<script src="Js/pagination.js"></script>
