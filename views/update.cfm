<cfparam name="form.req_id" default="">

<cfif NOT isNumeric(form.req_id)>
    <cfoutput>Invalid Request ID!</cfoutput>
    <cfabort>
</cfif>

<cfquery datasource="#application.datasource#">
    UPDATE requests
    SET 
        department = <cfqueryparam value="#form.department#" cfsqltype="cf_sql_varchar">,
        request_title = <cfqueryparam value="#form.title#" cfsqltype="cf_sql_varchar">,
        request_desc = <cfqueryparam value="#form.desc#" cfsqltype="cf_sql_varchar">
    WHERE req_id = <cfqueryparam value="#form.req_id#" cfsqltype="cf_sql_integer">
</cfquery>

<!-- Log the update -->
<cfquery datasource="#application.datasource#">
    INSERT INTO user_logs (username, action, request_id, details)
    VALUES (
        <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
        'UPDATE',
        <cfqueryparam value="#form.req_id#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="User #session.username# updated request ID #form.req_id#" cfsqltype="cf_sql_varchar">
    )
</cfquery>

<cflocation url="/CRMP/index.cfm?fuse=viewRequests" addtoken="no">


