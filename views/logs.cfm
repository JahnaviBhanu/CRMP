<cfif NOT structKeyExists(session, "role") OR session.role NEQ "admin">
    <h2 style="color:red;">❌ Unauthorized Access</h2>
    <cflocation url="home.cfm" addtoken="false">
    <cfabort>
</cfif>


<cfif NOT structKeyExists(session, "role") OR session.role NEQ "admin">
    <cfoutput>
        <h2 style="color:red;">Access Denied!</h2>
        <p>You don’t have permission to view this page.</p>
    </cfoutput>
    <cfabort>
</cfif>

<!DOCTYPE html>
<html>
<head>
    <title>User Activity Logs</title>
    <link rel="stylesheet" href="css/logs.css">
    <link rel="stylesheet" href="css/pagination.css">
</head>
<body>


<cfset getLogs=rc.data>

<div class="container">
<h2>User Activity Logs</h2>


<table border="1" cellspacing="0" cellpadding="8">
    <tr>
        <th>ID</th>
        <th>Username</th>
        <th>Action</th>
        <th>Details</th>
        <th>Timestamp</th>
    </tr>

<cfoutput query="getLogs">
    <tr>
        <td>#log_id#</td>
        <td>#username#</td>
        <td>#action#</td>   
        <td>#details#</td>
        <td>#timestamp#</td>
    </tr>
</cfoutput>
</table>

<!-- Pagination will appear below table -->
<div id="pagination"></div>

<script src="Js/pagination.js"></script>



</div>
<div class="back-home-wrapper">
    <a href="index.cfm?fuse=home" class="back-home-btn">
        ⬅ Back To Home
    </a>
</div>
</body>
</html>
