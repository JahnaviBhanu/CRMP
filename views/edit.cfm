<cfif NOT structKeyExists(session,"username")>
    <cflocation url="login.cfm">
</cfif>

<!DOCTYPE html>
<html>
<head>
<title>Edit Request</title>
<link rel="stylesheet" href="/css/style.css">
<link rel="stylesheet" href="../css/header.css">
<link rel="stylesheet" href="../css/footer.css">
<link rel="stylesheet" href="../css/editreq.css">
</head>
<body>



<cfset logText =
    'Request Edited by user=' & session.username &
    ' | RequestID=' & url.req_id
>

<cflog
    file="crmActivity"
    type="information"
    text="#logText#">



<div class="container">
<cfparam name="url.req_id" default="">
<cfif NOT isNumeric(url.req_id)>
    <h3 style="color:red;">Invalid Request ID</h3>
    <cfabort>
</cfif>

<cfquery name="getRequest" datasource="#application.datasource#">
    SELECT *
    FROM requests
    WHERE req_id = <cfqueryparam value="#url.req_id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput>
<h2>Edit Request</h2>

<form action="update.cfm" method="post">
    <input type="hidden" name="req_id" value="#getRequest.req_id#">
    <label>Department:</label>
    <select name="department" required>
        <option value="">--Select Department--</option>
        <option value="HR" <cfif getRequest.department EQ "HR">selected</cfif>>HR</option>
        <option value="Finance" <cfif getRequest.department EQ "Finance">selected</cfif>>Finance</option>
        <option value="IT" <cfif getRequest.department EQ "IT">selected</cfif>>IT</option>
        <option value="Sales" <cfif getRequest.department EQ "Sales">selected</cfif>>Sales</option>
        <option value="Admin" <cfif getRequest.department EQ "Admin">selected</cfif>>Admin</option>
    </select><br><br>

    <label>Title:</label>
    <input type="text" name="title" value="#getRequest.request_title#" required><br><br>

    <label>Description:</label><br>
    <textarea name="desc" rows="4" cols="40">#getRequest.request_desc#</textarea><br><br>

    <input type="submit" value="Update Request">
</form>
</cfoutput>
</div>
<div class="back-home-wrapper">
    <a href="/CRMP/index.cfm?fuse=home" class="back-home-btn">
        ⬅ Back To Home
    </a>
</div>


</body>
</html>
