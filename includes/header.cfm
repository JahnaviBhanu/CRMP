
<link rel="stylesheet" href="css/header.css">
<!-- Navbar Code -->
<div class="nav">
    <div class="menu-container">
        <!-- Hamburger Icon -->
        <div class="menu-icon" onclick="toggleMenu()">☰</div>

        <!-- Dropdown Menu (hidden by default) -->
       <div class="dropdown-menu" id="dropdownMenu">
    <a href="index.cfm?fuse=profile">My Profile</a>
    <a href="index.cfm?fuse=submitRequest" target="_blank">Submit Request</a>
    <a href="index.cfm?fuse=viewRequests">View Requests</a>

    <cfif structKeyExists(session,"role") AND session.role EQ "admin">
        <a href="index.cfm?fuse=logs">View Logs</a>
        <a href="index.cfm?fuse=users">Registered Users</a>
        <a href="index.cfm?fuse=customers">Customers</a>
    </cfif>
</div>

    </div>

    <!-- Logout Button -->
    <div class="logout">
        <a href="/CRMP/logout.cfm">Logout</a>
    </div>
</div>

<!-- Link to the JavaScript file for toggling the dropdown menu -->
<script src="Js/header.js"></script>

