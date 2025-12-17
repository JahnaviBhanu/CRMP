<cfparam name="url.token" default="">
<cfparam name="form.action" default="">
<cfset showResetForm = false>

<!DOCTYPE html>
<html>
<head>
    <title>Forgot / Reset Password</title>
    <meta charset="UTF-8">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/forgotPassword.css">
</head>

<body>
<div class="box">
<cfoutput>

<!-- ===================== -->
<!-- 1. TOKEN VALIDATION -->
<!-- ===================== -->
<cfif len(url.token) AND form.action EQ "">
    <cfquery name="qToken" datasource="crmp_db">
        SELECT id, username
        FROM users
        WHERE reset_token = <cfqueryparam value="#url.token#" cfsqltype="cf_sql_varchar">
        AND reset_expiry > NOW()
        LIMIT 1
    </cfquery>

    <cfif qToken.recordCount EQ 0>
        <div class="error">Invalid or expired reset link!</div>
    <cfelse>
        <cfset showResetForm = true>
    </cfif>
</cfif>


<!-- =========================== -->
<!-- 2. RESET PASSWORD SUBMIT -->
<!-- =========================== -->
<cfif form.action EQ "resetPassword">

    <cfquery name="qUser" datasource="crmp_db">
        SELECT id
        FROM users
        WHERE reset_token = <cfqueryparam value="#form.token#" cfsqltype="cf_sql_varchar">
        AND reset_expiry > NOW()
        LIMIT 1
    </cfquery>

    <cfif qUser.recordCount EQ 0>
        <div class="error">Invalid or expired token!</div>
        <cfset showResetForm = false>

    <cfelseif form.newPassword NEQ form.confirmPassword>
        <div class="error">Passwords do not match!</div>
        <cfset showResetForm = true>

    <cfelseif NOT REFind("^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$", form.newPassword)>
        <div class="error">Password must include A-Z, a-z, number & special character (min 8 chars)</div>
        <cfset showResetForm = true>

    <cfelse>

        <!-- Update password -->
        <cfquery datasource="crmp_db">
            UPDATE users
            SET password = <cfqueryparam value="#form.newPassword#" cfsqltype="cf_sql_varchar">,
                reset_token = NULL,
                reset_expiry = NULL
            WHERE id = <cfqueryparam value="#qUser.id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <div class="success">
            Password updated successfully! <br><br>
            <a href="../views/login.cfm">Click to Login</a>
        </div>

        <cfabort>
    </cfif>
</cfif>


<!-- ================================== -->
<!-- 3. SHOW RESET FORM (IF TOKEN OK) -->
<!-- ================================== -->
<cfif showResetForm EQ true>

    <h2>Reset Password</h2>

    <form method="post">
        <input type="hidden" name="action" value="resetPassword">
        <input type="hidden" name="token" value="#url.token#">

        <div class="mb-3">
    <label class="form-label">New Password*</label>
    <div class="password-wrapper">
        <input type="password"
               id="newPassword"
               name="newPassword"
               class="form-control"
               required>
        <i class="bi bi-eye-slash toggle-password"
           data-target="newPassword"></i>
    </div>
</div>

<div class="mb-3">
    <label class="form-label">Confirm Password*</label>
    <div class="password-wrapper">
        <input type="password"
               id="confirmPassword"
               name="confirmPassword"
               class="form-control"
               required>
        <i class="bi bi-eye-slash toggle-password"
           data-target="confirmPassword"></i>
    </div>
</div>

        <button class="btn" type="submit">Reset Password</button>
    </form>

<script>
document.querySelectorAll(".toggle-password").forEach(icon=>{
    icon.addEventListener("click",function(){
        let input=document.getElementById(this.dataset.target);
        if(input.type==="password"){
            input.type="text";
            this.classList.replace("bi-eye-slash","bi-eye");
        } else {
            input.type="password";
            this.classList.replace("bi-eye","bi-eye-slash");
        }
    });
});
</script>

<cfabort>
</cfif>


<!-- ========================= -->
<!-- 4. FORGOT PASSWORD FORM -->
<!-- ========================= -->
<h2>Forgot Password</h2>

<form method="post">
    <input type="hidden" name="action" value="sendLink">

    <label>Username*</label>
    <input type="text" name="username" required>

    <label>Email*</label>
    <input type="email" name="email" required>

    <button class="btn" type="submit">Send Reset Link</button><br></br>
     <a href="/CRMP/login.cfm">Click to Login</a>
</form>

<!-- ========================= -->
<!-- 5. SEND RESET EMAIL -->
<!-- ========================= -->
<cfif form.action EQ "sendLink">

    <cfquery name="qCheck" datasource="crmp_db">
        SELECT id
        FROM users
        WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
          AND email = <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">
        LIMIT 1
    </cfquery>

    <cfif qCheck.recordCount EQ 0>
        <div class="error">Invalid Username or Email!</div>
    <cfelse>
        <cfset token = CreateUUID()>

        <cfquery datasource="crmp_db">
            UPDATE users
            SET reset_token = <cfqueryparam value="#token#" cfsqltype="cf_sql_varchar">,
                reset_expiry = DATE_ADD(NOW(), INTERVAL 15 MINUTE)
            WHERE id = <cfqueryparam value="#qCheck.id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfset resetURL = "http://localhost:8500/CRMP/Pages/forgotPassword.cfm?token=#URLEncodedFormat(token)#">

        <!--- Enable CFMAIL debugging --->
        <cfsetting showdebugoutput="Yes">

        <cfmail
    to="#form.email#"
    from="mjahnavi875@gmail.com"
    subject="Password Reset Link"
    server="smtp.gmail.com"
    username="mjahnavi875@gmail.com"
    password="onnnmvyrpyyhchwx"
    port="587"
    usetls="yes"
    useSSL="no"
    type="html"
>
    <p>Hello #form.username#,</p>
    <p>You requested a password reset. Click the link below to reset your password:</p>
    <p><a href="#resetURL#">Reset Your Password</a></p>
    <p>This link is valid for <b>15 minutes</b>.</p>
    <p>If you did not request this, ignore this email.</p>
</cfmail>


        <div class="success">Reset link sent to your email!</div>
    </cfif>
</cfif>


</cfoutput>
</div>
</body>
</html>
