<cfparam name="form.department" default="">
<cfparam name="form.title" default="">
<cfparam name="form.desc" default="">

<cfquery datasource="crmp_db">
    INSERT INTO requests (department, request_title, request_desc)
    VALUES (
        <cfqueryparam value="#form.department#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.title#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.desc#" cfsqltype="cf_sql_varchar">
    )
</cfquery>


<!--- FILE LOG --->
<cfset logText =
    'Request deleted by user=' & session.username &
    '  | Title=' & form.title
>

<cflog
    file="crmActivity"
    type="information"
    text="#logText#">



<!-- Get the last inserted request -->
<cfquery name="getLastID" datasource="crmp_db">
    SELECT MAX(req_id) AS last_id FROM requests
</cfquery>

<!-- Log the creation -->
<cfquery datasource="crmp_db">
    INSERT INTO user_logs (username, action, request_id, details)
    VALUES (
        <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
        'CREATE',
        <cfqueryparam value="#getLastID.last_id#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="User #session.username# created new request ID #getLastID.last_id#" cfsqltype="cf_sql_varchar">
    )
</cfquery>
<!--- AFTER INSERT QUERY --->



<cflocation url="/CRMP/index.cfm?fuse=viewRequests" addtoken="no">
