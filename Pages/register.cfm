<cfset successMsg = "">
<cfset errorMsg = "">
<cfparam name="step" default="register">

<!-- STEP 1: Send OTP -->
<cfif structKeyExists(form, "sendOTP")>
    <cfset username = trim(form.username)>
    <cfset password = trim(form.password)>
    <cfset confirmPassword = trim(form.confirmPassword)>
    <cfset email = trim(form.email)>

    <!-- Check if passwords match -->
    <cfif password NEQ confirmPassword>
        <cfset errorMsg = "❌ Passwords do not match!">
        <cfset step = "register">
    <cfelse>
        <!-- Check password strength -->
        <cfset validPassword = (
            reFind("[A-Z]", password)
            AND reFind("[a-z]", password)
            AND reFind("[0-9]", password)
            AND reFind("[@##$%&*!?]", password)
            AND len(trim(password)) GTE 8
        )>

        <cfif NOT validPassword>
            <cfset errorMsg = "⚠ Weak password! Must contain A-Z, a-z, number & special char, and at least 8 characters.">
            <cfset step = "register">
        <cfelse>

            <!-- CHECK IF USERNAME EXISTS -->
            <cfquery name="checkUser" datasource="crmp_db">
                SELECT username
                FROM users
                WHERE username = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
            </cfquery>

            <cfif checkUser.recordCount GT 0>
                <cfset errorMsg = "Username already exists! Please choose another username.">
                <cfset step = "register">
            <cfelse>
                <!-- Generate OTP -->
                <cfset otp = RandRange(100000, 999999)>
                <cfset session.otp = otp>
                <cfset session.otpTime = Now()>

                <!-- Store temporary user info -->
                <cfset session.tempUser = username>
                <cfset session.tempPass = password>
                <cfset session.tempEmail = email>

                <!-- Send OTP email -->
                <cftry>
                    <cfmail to="#email#" from="mjahnavi875@gmail.com"
                        subject="Your OTP Verification Code" type="html">
                        <p>Hello <b>#Replace(username, "<", "&lt;", "all")#</b>,</p>
                        <p>Your OTP for registration is: <b>#otp#</b></p>
                        <p>This code will expire in 5 minutes.</p>
                        <p>Thank you,<br>CRMP Support Team</p>
                    </cfmail>

                    <cfset step = "verify">

                    <cfcatch type="any">
                        <cfset errorMsg = "⚠️ Failed to send OTP. Please check mail settings.<br>Error: #cfcatch.message#">
                    </cfcatch>
                </cftry>

            </cfif>
        </cfif>
    </cfif>
</cfif>

<!-- STEP 2: Verify OTP -->
<cfif structKeyExists(form, "verifyOTP")>
    <cfset userOTP = trim(form.otp)>
    <cfset correctOTP = session.otp>
    <cfset otpTime = session.otpTime>
    <cfset minutesPassed = dateDiff("n", otpTime, now())>

    <cfif minutesPassed GT 5>
        <cfset errorMsg = "❌ OTP expired. Please register again.">
        <cfset structClear(session)>
        <cfset step = "register">
    <cfelseif userOTP EQ correctOTP>
        <!-- Insert into database -->
        <cfquery datasource="crmp_db">
            INSERT INTO users (username, password, email)
            VALUES (
                <cfqueryparam value="#session.tempUser#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#session.tempPass#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#session.tempEmail#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>

        <cfset successMsg = "✅ User registered successfully! You can now login.">
        <cfset structClear(session)>
    <cfelse>
        <cfset errorMsg = "❌ Invalid OTP. Please try again.">
        <cfset step = "verify">
    </cfif>
</cfif>

<!DOCTYPE html>
<html>
<head>
    <title>User Registration (with OTP)</title>
    <link rel="stylesheet" href="../css/register.css">
</head>
<body>
    <div class="container">
        <h2>User Registration with OTP Verification</h2>

        <!-- ✅ SUCCESS -->
        <cfif successMsg NEQ "">
            <div class="success-box"><cfoutput>#successMsg#</cfoutput></div>

        <!-- ⚠️ ERROR -->
        <cfelseif errorMsg NEQ "">
            <div class="error-box"><cfoutput>#errorMsg#</cfoutput></div>
        </cfif>

        <!-- STEP 1 FORM -->
       <!-- STEP 1 FORM -->
<cfif step EQ "register" AND successMsg EQ "">
    <form method="post" action="register.cfm">
        <input type="text" name="username" placeholder="Username" required>
         <input type="email" name="email" placeholder="Email Address" required>

        <div class="password-wrapper">
            <input type="password" name="password" id="password" placeholder="Password" required>
        </div>

        <div class="password-wrapper">
            <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm Password" required>
        </div>

        <div class="show-password-wrapper">
            <input type="checkbox" id="showPassword">
            <label for="showPassword" class="show-password-label">Show password</label>
        </div>

       
        <button type="submit" name="sendOTP">Send OTP</button>
    </form>
</cfif>


        <!-- STEP 2 FORM -->
        <cfif step EQ "verify" AND successMsg EQ "">
            <form method="post" action="register.cfm">
                <input type="text" name="otp" placeholder="Enter OTP" required>
                <button type="submit" name="verifyOTP">Verify OTP</button>
            </form>
        </cfif>

        <div class="link">
            Already have an account? <a href="/CRMP/login.cfm">Login Here</a>
        </div>
    </div>
    <script src="../Js/registration.js"></script>
</body>
</html>
