<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>
    <link rel="stylesheet" href="../css/forgot.css">
</head>
<body>

<div class="forgot-container">
    <h2>Forgot Password</h2>

    <!-- Initialize messages -->
    <cfset errorMsg = "">
    <cfset successMsg = "">

    <!-- Handle form -->
    <cfif structKeyExists(FORM, "submitUsername")>
        <cfset username = trim(FORM.username)>

        <cfif username EQ "">
            <cfset errorMsg = "⚠️ Please enter your username.">
        <cfelse>
            <!-- Fetch user from DB -->
            <cfquery name="getUser" datasource="crmp_db">
                SELECT email, password
                FROM users
                WHERE username = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
            </cfquery>

            <cfif getUser.recordCount EQ 0>
                <cfset errorMsg = "❌ Username not found. Please try again.">
            <cfelse>
                <cfset userEmail = getUser.email>
                <cfset userPassword = getUser.password>

                <!-- Send password email -->
                <cftry>
                    <cfmail to="#userEmail#" from="mjahnavi875@gmail.com"
                        subject="Your Password Retrieval Request" type="html">
                        <p>Hello <b>#encodeForHTML(username)#</b>,</p>
                        <p>You requested to retrieve your password.</p>
                        <p>Your current password is: <b>#encodeForHTML(userPassword)#</b></p>
                        <br>
                        <p>Thank you,<br>CRMP Support Team</p>
                    </cfmail>

                    <cfset successMsg = "✅ Password has been sent to your registered email address!">

                    <cfcatch type="any">
                        <cfset errorMsg = "⚠️ Failed to send email. Please check mail server settings.<br>Error: #cfcatch.message#">
                    </cfcatch>
                </cftry>
            </cfif>
        </cfif>
    </cfif>

    <!-- Display messages -->
    <cfif successMsg NEQ "">
        <div class="success"><cfoutput>#successMsg#</cfoutput></div>
        <p><a href="login.cfm">Back to Login</a></p>
    <cfelseif errorMsg NEQ "">
        <div class="error"><cfoutput>#errorMsg#</cfoutput></div>
    </cfif>

    <!-- Show form again if no success -->
    <cfif NOT structKeyExists(FORM, "submitUsername") OR errorMsg NEQ "">
        <form method="post" action="forgot.cfm">
            <label>Enter your Username:</label>
            <input type="text" name="username" placeholder="Enter Username" required>
            <input type="submit" name="submitUsername" value="Send Password to Email" class="btn">
        </form>
    </cfif>

</div>
</body>
</html>
