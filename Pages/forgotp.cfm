<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot / Reset Password</title>
    <link rel="stylesheet" href="../css/forgotp.css">
</head>
<body>

<div class="forgot-container">

    <h2>Forgot / Reset Password</h2>

    <cfparam name="form.username" default="">
    <cfparam name="form.otp" default="">
    <cfparam name="form.newPassword" default="">
    <cfparam name="form.confirmPassword" default="">

    <!-- STEP 1: Enter Username -->
    <cfif NOT structKeyExists(form, "step")>
        <form method="post">
            <input type="hidden" name="step" value="sendOtp">
            <label>Enter Username*</label>
            <input type="text" name="username" required>
            <button type="submit">Send OTP</button>
        </form>

    <!-- STEP 2: Send OTP -->
    <cfelseif form.step EQ "sendOtp">
        <cfquery name="getUser" datasource="#application.datasource#">
            SELECT username, email FROM users
            WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif getUser.recordCount EQ 0>
            <p class="error-msg">⚠ Username not found!</p>
            <a href="forgotp.cfm" class="back-btn">Try Again</a>
            <cfabort>
        </cfif>

        <!-- Store session -->
        <cfset session.username = getUser.username>
        <cfset session.email = getUser.email>
        <cfset session.otp = randRange(100000,999999)>
        <cfset session.otpGeneratedTime = now()>

        <!-- Send OTP -->
        <cftry>
    <cfmail 
    to="#session.email#" 
    from="mjahnavi875@gmail.com" 
    subject="Password Reset OTP"
    server="smtp.gmail.com"
    username="mjahnavi875@gmail.com"
    password="onnnmvyrpyyhchwx"
    port="587"
    usetls="yes">
    Your new OTP is:#session.otp#
    Valid for 5 minutes.
</cfmail>

    <cfcatch>
        <cfdump var="#cfcatch#">
        <cfabort>
    </cfcatch>
</cftry>



        <p class="success-msg">✅ OTP sent to registered email</p>

        <!-- OTP Form -->
        <div id="otpContainer">
            <form method="post">
                <input type="hidden" name="step" value="verifyOtp">
                <label>Enter OTP*</label>
                <input type="text" name="otp" id="otp" required>
                <p id="time">OTP expires in 05:00</p>
                <button type="submit">Verify OTP</button>
            </form>
            <!-- Resend OTP form -->
            <form method="post" id="resendOtpForm">
                <input type="hidden" name="step" value="resendOtp">
                <button type="submit" id="resendBtn" style="display:none;">Resend OTP</button>
            </form>
        </div>

    <!-- STEP 3: Verify OTP -->
    <cfelseif form.step EQ "verifyOtp">

        <cfset minDiff = dateDiff("n", session.otpGeneratedTime, now())>

        <cfif minDiff GT 5>
            <p class="error-msg">⏰ OTP expired!</p>
            <form method="post">
                <input type="hidden" name="step" value="resendOtp">
                <button type="submit">Resend OTP</button>
            </form>
            <cfabort>
        </cfif>

        <cfif form.otp NEQ session.otp>
            <p class="error-msg">❌ Incorrect OTP!</p>
            <form method="post">
                <input type="hidden" name="step" value="resendOtp">
                <button type="submit">Resend OTP</button>
            </form>
            <cfabort>
        </cfif>

        <p class="success-msg">✅ OTP verified!</p>

        <!-- Reset Password Form -->
        <div id="resetPasswordContainer">
            <form method="post">
                <input type="hidden" name="step" value="resetPassword">
                <div class="password-wrapper">
                    <label>New Password*</label>
                    <input type="password" name="newPassword" id="newPassword" required>
                </div>

                <div class="password-wrapper">
                    <label>Confirm Password*</label>
                    <input type="password" name="confirmPassword" id="confirmPassword" required>
                </div>
     <div class="show-password-wrapper">
         <input type="checkbox" id="showPassword">
    <label for="showPassword" class="show-password-label">Show password</label>

        </div>


                <button type="submit">Reset Password</button>
            </form>
        </div>

    <!-- STEP 4: Reset Password -->
    <cfelseif form.step EQ "resetPassword">
        <cfset valid = (
            reFind("[A-Z]", form.newPassword)
            AND reFind("[a-z]", form.newPassword)
            AND reFind("[0-9]", form.newPassword)
            AND reFind("[@##$%&*!?]", form.newPassword)
            AND len(trim(form.newPassword)) GTE 8
        )>

        <cfif form.newPassword NEQ form.confirmPassword>
            <p class="error-msg">❌ Passwords do not match!</p>
            
            <cfabort>
        <cfelseif NOT valid>
            <p class="error-msg">⚠ Weak password! Must contain A-Z, a-z, number & special char.</p>
            <cfabort>
        </cfif>

      
        <cfquery datasource="#application.datasource#">
UPDATE users
SET password = <cfqueryparam value="#form.newPassword#" cfsqltype="cf_sql_varchar">
WHERE username = <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
</cfquery>



        <p class="success-msg">✅ Password Reset Successfully!</p>
        <a href="login.cfm" class="back-btn">Go to Login</a>

    <!-- STEP 5: Resend OTP -->
    <cfelseif form.step EQ "resendOtp">
        <!-- Generate new OTP -->
        <cfset session.otp = randRange(100000,999999)>
        <cfset session.otpGeneratedTime = now()>

        <!-- Send OTP -->
        <cfmail 
    to="#session.email#" 
    from="mjahnavi875@gmail.com" 
    subject="Password Reset OTP"
    server="smtp.gmail.com"
    username="mjahnavi875@gmail.com"
    password="onnnmvyrpyyhchwx"
    port="587"
    usetls="yes">
    Your new OTP is: #session.otp#
    Valid for 5 minutes.
</cfmail>


        <p class="success-msg">✅ OTP resent to your registered email</p>

        <!-- OTP Form again -->
        <div id="otpContainer">
            <form method="post">
                <input type="hidden" name="step" value="verifyOtp">
                <label>Enter OTP*</label>
                <input type="text" name="otp" id="otp" required>
                <p id="time">OTP expires in 05:00</p>
                <button type="submit">Verify OTP</button>
            </form>

            <form method="post" id="resendOtpForm">
                <input type="hidden" name="step" value="resendOtp">
                <button type="submit" id="resendBtn" style="display:none;">Resend OTP</button>
            </form>
        </div>
    </cfif>

</div>

<script src="../Js/forgotp.js"></script>
</body>
</html>
