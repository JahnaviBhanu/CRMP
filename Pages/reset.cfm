<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="../css/forgotp.css">
</head>
<body>
    <div class="container">
        <h2>Reset Your Password</h2>

        <cfparam name="url.token" default="">
        <cfif len(trim(url.token)) EQ 0>
            <div class="error">Invalid or missing reset token.</div>
            <cfabort>
        </cfif>

        <!-- Validate token -->
        <cfquery name="checkToken" datasource="crmp_db">
            SELECT username, reset_expiry
            FROM users
            WHERE reset_token = <cfqueryparam value="#url.token#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif checkToken.recordCount EQ 0>
            <div class="error">Invalid or expired reset link.</div>
        <cfelseif Now() GT checkToken.reset_expiry>
            <div class="error">⏰ This reset link has expired.</div>
        <cfelseif structKeyExists(FORM, "resetPass")>
            <cfif form.newPass NEQ form.confirmPass>
                <div class="error">❌ Passwords do not match.</div>
            <cfelse>
                <!-- Update password and clear token -->
                <cfquery datasource="crmp_db">
                    UPDATE users
                    SET password = <cfqueryparam value="#form.newPass#" cfsqltype="cf_sql_varchar">,
                        reset_token = NULL,
                        reset_expiry = NULL
                    WHERE reset_token = <cfqueryparam value="#url.token#" cfsqltype="cf_sql_varchar">
                </cfquery>
                <div class="success">✅ Password reset successfully!</div>
                <a href="login.cfm">Go to Login</a>
            </cfif>
        <cfelse>
            <form method="post">
                <label>New Password:</label>
                <input type="password" name="newPass" required>
                <label>Confirm Password:</label>
                <input type="password" name="confirmPass" required>
                <button type="submit" name="resetPass">Reset Password</button>
            </form>
        </cfif>
    </div>
</body>
</html>
