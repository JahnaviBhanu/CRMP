<cfif NOT structKeyExists(session,"username")>
    <cflocation url="login.cfm">
</cfif>

<cfparam name="url.req_id" default="">
<cfif NOT isNumeric(url.req_id)>
    <cfoutput>Invalid Request ID!</cfoutput>
    <cfabort>
</cfif>

<cfquery datasource="#application.datasource#">
    DELETE FROM requests
    WHERE req_id = <cfqueryparam value="#url.req_id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfset logText =
    'Request Deleted by user=' & session.username &
    ' | RequestID=' & url.req_id
>

<cflog
    file="crmActivity"
    type="information"
    text="#logText#">

<cfquery datasource="#application.datasource#">
    INSERT INTO user_logs (username, action, request_id, details)
    VALUES (
        <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
        'UPDATE',
        <cfqueryparam value="#url.req_id#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="User #session.username# updated request ID #url.req_id#" cfsqltype="cf_sql_varchar">
    )
</cfquery>

<cflocation url="/CRMP/index.cfm?fuse=viewRequests" addtoken="no">
