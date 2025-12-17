<!--- Auth check --->
<cfif NOT structKeyExists(session, "username")>
    <cflocation url="login.cfm">
</cfif>

<!-- Read filters from session -->
<cfparam name="session.requestFilters.department" default="">
<cfparam name="session.requestFilters.searchText" default="">

<cfset department = session.requestFilters.department>
<cfset searchText = session.requestFilters.searchText>




<!--- Query with filters --->
<cfquery name="getRequests" datasource="#application.datasource#">
    SELECT req_id, request_title, request_desc, department
    FROM requests
    WHERE 1=1

    <cfif len(trim(department))>
        AND department = 
        <cfqueryparam value="#department#" cfsqltype="cf_sql_varchar">
    </cfif>

    <cfif len(trim(searchText))>
        AND (
            request_title LIKE 
            <cfqueryparam value="%#searchText#%" cfsqltype="cf_sql_varchar">
            OR request_desc LIKE 
            <cfqueryparam value="%#searchText#%" cfsqltype="cf_sql_varchar">
        )
    </cfif>

    ORDER BY req_id DESC
</cfquery>


<!--- Get the logged-in user's email --->

<!--- Get admin email --->
<cfquery name="getAdmin" datasource="crmp_db">
    SELECT Email 
    FROM users 
    WHERE role = 'admin'
    LIMIT 1

</cfquery>

<!--- Send email notification to admin --->
<cfmail 
    to="#getAdmin.Email#" 
    from="#session.email#" 
    subject="PDF Downloaded - Notification"
    type="html">
    <p>User <strong>#session.username#</strong> downloaded the PDF report.</p>
    <p>User Email: #session.email#</p>
     <b>Date & Time:</b> #dateFormat(now(), "dd-mmm-yyyy")# #timeFormat(now(), "hh:mm:ss tt")#<br>
   
</cfmail>

<!--- PDF Headers --->
<cfheader name="Content-Disposition" value="inline; filename=ViewRequestsReport.pdf">

<cfcontent type="application/pdf">
<!--- Send Notification Email to Admin --->


<cfdocument format="pdf" pagetype="A4" orientation="portrait" margintop="1" marginbottom="1">


<style>
    table {
        width: 100%;
        border-collapse: collapse;
        font-family: Arial;
        font-size: 12px;
    }
    th, td {
        border: 1px solid #166ad7ff;
        padding: 8px;
        text-align: left;
        vertical-align: top;
    }
    th {
        background-color: #eaeaea;
        font-weight: bold;
    }
    tr:nth-child(even) {
        background-color: #f9f9f9;
    }
    h2 {
        text-align: center;
    }
</style>

<h2>View Requests Report</h2>

<table>
    <tr>
        <th>Department</th>
        <th>Title</th>
        <th>Description</th>
    </tr>

    <cfoutput query="getRequests">
        <tr>
            <td>#department#</td>
            <td>#request_title#</td>
            <td>#request_desc#</td>
        </tr>
    </cfoutput>
</table>

</cfdocument>
