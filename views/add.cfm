<cfif NOT structKeyExists(session,"username")>
    <cflocation url="login.cfm">
</cfif>


<!DOCTYPE html>
<html>
<head>
<title>Submit Request</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>

<cfset action = "Logged In">
<cflog file="userActivity" type="information" text="User #session.username# performed #action# at #now()#">


<div class="container">
<h2>Submit Request</h2>

<form action="views/insert.cfm" method="post">
    <label>Department:</label>
    <select name="department" required>
        <option value="">--Select Department--</option>
        <option value="HR">HR</option>
        <option value="Finance">Finance</option>
        <option value="IT">IT</option>
        <option value="Sales">Sales</option>
        <option value="Admin">Admin</option>
    </select><br><br>

    <label>Title:</label>
    <input type="text" name="title" required><br><br>

    <label>Description:</label><br>
    <textarea name="desc" rows="4" cols="40"></textarea><br><br>

    <input type="submit" value="Submit Request">
</form>

 <div class="back-home-wrapper">
    <a href="index.cfm?fuse=home" class="back-home-btn">
        ⬅ Back To Home
    </a>
</div>

</div>


</body>
</html>
