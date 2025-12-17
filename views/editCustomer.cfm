<cfif NOT structKeyExists(session, "role") OR session.role NEQ "admin">
    <cflocation url="index.cfm" addtoken="false">
    <cfabort>
</cfif>

<link rel="stylesheet" href="../css/header.css">
<link rel="stylesheet" href="../css/footer.css">
<link rel="stylesheet" href="../css/editcus.css">

<cfparam name="url.id" default="">
<cfif NOT isNumeric(url.id)>
    <h3 style="color:red;">Invalid Customer ID</h3>
    <cfabort>
</cfif>

<cfquery name="getCustomer" datasource="#application.datasource#">
    SELECT id, name, email, phone
    FROM customers
    WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
</cfquery>



<h2>Edit Customer</h2>

<cfoutput>
<form method="post" action="/CRMP/index.cfm?fuse=editcus">
    <input type="hidden" name="id" value="#getCustomer.id#">

    <label>Name:</label>
    <input type="text" name="name" value="#getCustomer.name#" required><br><br>

    <label>Email:</label>
    <input type="email" name="email" value="#getCustomer.email#" required><br><br>

    <label>Phone:</label>
    <input type="text" name="phone" value="#getCustomer.phone#" required><br><br>

    <input type="submit" value="Update Customer">
</form>
</cfoutput>
<div class="back-home-wrapper">
    <a href="/CRMP/index.cfm?fuse=home" class="back-home-btn">
        ⬅ Back To Home
    </a>
</div>


