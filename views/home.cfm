
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CRM Dashboard</title>
    <link rel="stylesheet" href="css/home.css">
</head>

<body>

<!-- ✅ Top Navigation -->



<!-- ✅ Welcome Section -->
<div class="welcome">
    <cfoutput>
        <h2>Welcome, #session.username#! 👋</h2>
    </cfoutput>
</div>

<!-- ✅ Dashboard Cards -->
<div class="card-container">
    <a href="index.cfm?fuse=submitRequest" target="_blank" class="card">
        <h3>➕ Submit New Request</h3>
        <p>Create and submit a new department request.</p>
    </a>

    <a href="index.cfm?fuse=viewRequests" class="card">
        <h3>📄 View Requests</h3>
        <p>View, edit, or delete existing requests.</p>
    </a>

    <!-- ✅ Only for admin -->
    <cfif structKeyExists(session,"role") AND session.role EQ "admin">
        <a href="index.cfm?fuse=logs" class="card admin-card">
            <h3>📜 View Logs</h3>
            <p>Track user activity and system changes.</p>
        </a>

    </cfif>
</div>

</body>

</html>
