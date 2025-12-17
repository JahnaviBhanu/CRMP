
// Convert CF session timeout (1 hour) to milliseconds
var sessionTimeoutMs = 60 * 60 * 1000; // 1 hour

// Auto redirect when session expires
setTimeout(function() {
    window.location.href = "login.cfm?msg=sessionExpired";
}, sessionTimeoutMs);

