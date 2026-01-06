<cfset successMsg = "">
<cfset errorMsg = "">
<cfparam name="step" default="register">

<!-- ================= STEP 1: SEND OTP ================= -->
<cfif structKeyExists(form, "sendOTP")>

    <cfset username = trim(form.username)>
    <cfset password = trim(form.password)>
    <cfset confirmPassword = trim(form.confirmPassword)>
    <cfset email = trim(form.email)>

    <!-- Password match -->
    <cfif password NEQ confirmPassword>
        <cfset errorMsg = "❌ Passwords do not match!">
        <cfset step = "register">

    <cfelse>
        <!-- Password strength -->
        <cfset validPassword = (
            reFind("[A-Z]", password)
            AND reFind("[a-z]", password)
            AND reFind("[0-9]", password)
            AND reFind("[@##$%&*!?]", password)
            AND len(password) GTE 8
        )>

        <cfif NOT validPassword>
            <cfset errorMsg = "⚠ Password must contain A-Z, a-z, number, special char & min 8 chars">
            <cfset step = "register">

        <cfelse>
            <!-- Username exists check -->
            <cfquery name="checkUser" datasource="crmp_db">
                SELECT username FROM users
                WHERE username = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
            </cfquery>

            <cfif checkUser.recordCount GT 0>
                <cfset errorMsg = "Username already exists!">
                <cfset step = "register">

            <cfelse>
                <!-- Generate OTP -->
                <cfset session.otp = RandRange(100000, 999999)>
                <cfset session.otpTime = Now()>
                <cfset session.tempUser = username>
                <cfset session.tempPass = password>
                <cfset session.tempEmail = email>

                <!-- Send OTP -->
                <cftry>
                    <cfmail
                        to="#email#"
                        from="mjahnavi875@gmail.com"
                        subject="Your OTP Verification Code"
                        server="smtp.gmail.com"
                        username="mjahnavi875@gmail.com"
                        password="onnnmvyrpyyhchwx"
                        port="587"
                        usetls="yes"
                        type="html">

                        <p>Hello <b>#EncodeForHTML(username)#</b>,</p>
                        <p>Your OTP is: <b>#session.otp#</b></p>
                        <p>Valid for 2 minutes.</p>

                    </cfmail>

                    <cfset step = "verify">

                <cfcatch>
                    <cfset errorMsg = "❌ OTP send failed. Mail configuration issue.">
                    <cfset step = "register">
                </cfcatch>
                </cftry>
            </cfif>
        </cfif>
    </cfif>
</cfif>

<!-- ================= RESEND OTP ================= -->
<cfif structKeyExists(form,"resendOTP")
    AND structKeyExists(session,"tempEmail")
    AND NOT structKeyExists(form,"sendOTP")
    AND NOT structKeyExists(form,"verifyOTP")>

    <cfset session.otp = RandRange(100000, 999999)>
    <cfset session.otpTime = Now()>

    <cfmail
        to="#session.tempEmail#"
        from="mjahnavi875@gmail.com"
        subject="Resent OTP"
        server="smtp.gmail.com"
        username="mjahnavi875@gmail.com"
        password="onnnmvyrpyyhchwx"
        port="587"
        usetls="yes"
        type="html">

        <p>Your new OTP is: <b>#session.otp#</b></p>

    </cfmail>

    <cfset successMsg = "✅ New OTP sent successfully">
    <cfset step = "verify">
</cfif>

<!-- ================= VERIFY OTP ================= -->
<cfif structKeyExists(form,"verifyOTP")>

    <cfset userOTP = trim(form.otp)>
    <cfset secondsPassed = dateDiff("s", session.otpTime, now())>

    <cfif secondsPassed GT 120>
        <cfset errorMsg = "❌ OTP expired. Please click Resend OTP.">
        <cfset step = "verify">
        <cfabort>
    </cfif>

    <cfif userOTP EQ session.otp>
        <cfquery datasource="crmp_db">
            INSERT INTO users (username,password,email)
            VALUES (
                <cfqueryparam value="#session.tempUser#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#session.tempPass#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#session.tempEmail#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>

        <cfset structClear(session)>
        <cflocation url="/CRMP/login.cfm" addtoken="false">

    <cfelse>
        <cfset errorMsg = "❌ Invalid OTP">
        <cfset step = "verify">
    </cfif>
</cfif>

<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <link rel="stylesheet" href="../css/register.css">
</head>
<body>

<div class="container">
    <h2>User Registration</h2>

    <cfif successMsg NEQ "">
        <div class="success-box"><cfoutput>#successMsg#</cfoutput></div>
    <cfelseif errorMsg NEQ "">
        <div class="error-box"><cfoutput>#errorMsg#</cfoutput></div>
    </cfif>

    <!-- REGISTER -->
    <cfif step EQ "register">
        <form method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="email" name="email" placeholder="Email" required>

            <input type="password" name="password" id="password" placeholder="Password" required>
            <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm Password" required>

            <div>
                <input type="checkbox" id="showPassword">
                <label for="showPassword">Show Password</label>
            </div>

            <button type="submit" name="sendOTP">Send OTP</button>
        </form>
    </cfif>

    <!-- VERIFY -->
    <cfif step EQ "verify">
        <form method="post">
            <input type="text" name="otp" placeholder="Enter OTP">

            <div id="timer" style="color:red;font-weight:bold;">02:00</div>

            <button type="submit" name="verifyOTP">Verify OTP</button>
            <button type="submit" name="resendOTP" id="resendBtn" disabled>Resend OTP</button>
        </form>
    </cfif>

</div>
<script src="/CRMP/Js/registration.js"></script>

</body>
</html>
