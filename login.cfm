<cfparam name="form.username" default="">
<cfparam name="form.password" default="">

<cfset loginError = "">

<!--- Process login only when form is submitted --->
<cfif len(trim(form.username)) AND len(trim(form.password))>

   
   <cfquery name="qUser" datasource="#application.datasource#">
   SELECT id, username, email, profile_pic, role
    FROM users
    WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
      AND password = <cfqueryparam value="#form.password#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif qUser.recordCount >
     <cfset sessionRotate()>
    <!--- Session values --->
    <cfset session.isLoggedIn = true>
    <cfset session.userid    = qUser.id>
    <cfset session.username  = qUser.username>
    <cfset session.email     = qUser.email>
    <cfset session.role      = qUser.role>

    <!--- Profile picture --->
    <cfif len(qUser.profile_pic)>
        <cfset session.profilePic = "/CRMP/upload/#qUser.profile_pic#">
    </cfif>

        <!--- Redirect to home --->
    <cflocation url="/CRMP/index.cfm?fuse=home" addtoken="false">


    <cfelse>
        <cfset loginError = "Invalid Username or Password">
    </cfif>
</cfif>

<!DOCTYPE html>
<html>
<head>
    <title>CRM Login</title>

    <!-- Main styles -->
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" type="text/css" href="css/login.css">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>

<body>

<div class="login-container">
    <h2>CRM Login</h2>

    <!-- Session expired message -->
    <cfif structKeyExists(url, "msg") AND url.msg EQ "sessionExpired">
        <div class="error-box">
            🔒 Your session has expired. Please login again.
        </div>
    </cfif>

    <!-- Login error message -->
    <cfif len(loginError)>
        <cfoutput>
        <div class="error-box" style="color:red;">
            #loginError#
        </div>
        </cfoutput>
    </cfif>

    <form method="post">

        <label>Username:</label>
        <input type="text" name="username"  required>

        <label>Password:</label>
        <div class="password-wrapper">
            <input type="password" name="password" id="password" required>
            <i class="bi bi-eye-slash toggle-password" id="togglePassword"></i>
        </div>

        <button type="submit" class="btn">Login</button>
    </form>

    <!-- Registration -->
    <form action="/CRMP/views/register.cfm" method="get">
        <button type="submit" class="btn-secondary">
            New User? Create Account
        </button>
    </form>

    <!-- Forgot Password -->
    <a href="/CRMP/views/forgotPassword.cfm" class="forgot-link">
        Forgot Password?
    </a>
</div>

<!-- JS -->
<script src="Js/login.js"></script>

</body>
</html>
