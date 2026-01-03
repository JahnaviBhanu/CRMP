<cfcomponent displayname="CRMP Controller" hint="Controller providing data functions for CRMP app">

    <!--- Change this to your ColdFusion datasource name if it's different --->
    <cfset this.datasource = "crmp_db">

   
    <!--- Return home data (reuse fetchRequests) --->
    <cffunction name="home" access="public" returntype="query" output="false">
        <cfset var q = "">
        <cftry>
            <cfset q = variables.fetchRequests("", "", 1)>
        <cfcatch type="any">
            <cflog file="appDebug" text="controller.home error: #cfcatch.message#">
            <cfset q = queryNew("req_id,request_title,request_desc,department")>
        </cfcatch>
        </cftry>
        <cfreturn q>
    </cffunction>

    <!--- Fetch requests with optional department and searchText --->
<cffunction name="fetchRequests" access="public" returntype="query" output="false">
    <cfargument name="department" required="false" default="">
    <cfargument name="searchText" required="false" default="">
    <cfset var q = "">

    <cfquery name="q" datasource="#this.datasource#">
        SELECT req_id, request_title, request_desc, department
        FROM requests
        WHERE 1 = 1

        <cfif len(trim(arguments.department))>
            AND department =
            <cfqueryparam value="#arguments.department#" cfsqltype="cf_sql_varchar">
        </cfif>

        <cfif len(trim(arguments.searchText))>
            AND (
                request_title LIKE
                <cfqueryparam value="%#arguments.searchText#%" cfsqltype="cf_sql_varchar">
                OR
                request_desc LIKE
                <cfqueryparam value="%#arguments.searchText#%" cfsqltype="cf_sql_varchar">
            )
        </cfif>

        ORDER BY req_id DESC
    </cfquery>

    <cfreturn q>
</cffunction>

  <!--- Create a request and return new id (0 on error) --->
    <cffunction name="createRequest" access="public" returntype="numeric" output="false">
        <cfargument name="info" type="struct" required="true">
        <cfset var newId = 0>
        <cftry>
            <cfquery datasource="#this.datasource#" name="qInsert">
                INSERT INTO requests (request_title, request_desc, department)
                VALUES (
                    <cfqueryparam value="#arguments.info.request_title#" cfsqltype="cf_sql_varchar" maxlength="200">,
                    <cfqueryparam value="#arguments.info.request_desc#" cfsqltype="cf_sql_varchar" maxlength="500">,
                    <cfqueryparam value="#arguments.info.department#" cfsqltype="cf_sql_varchar" maxlength="50">
                )
            </cfquery>
            <cfquery name="qGetId" datasource="#this.datasource#">
                SELECT LAST_INSERT_ID() AS id
            </cfquery>
            <cfset newId = qGetId.id>
        <cfcatch type="any">
            <cflog file="appDebug" text="controller.createRequest error: #cfcatch.message#">
            <cfset newId = 0>
        </cfcatch>
        </cftry>
        <cfreturn newId>
    </cffunction>


    <!--- Fetch registered users --->
    <cffunction name="fetchUsers" access="public" returntype="query" output="false">
        <cfset var q = "">
        <cftry>
            <cfquery name="q" datasource="#this.datasource#">
                SELECT Id AS id, Username AS username, Email AS email, role
                FROM users
                ORDER BY Id DESC
            </cfquery>
        <cfcatch type="any">
            <cflog file="appDebug" text="controller.fetchUsers error: #cfcatch.message#">
            <cfset q = queryNew("id,username,email,role")>
        </cfcatch>
        </cftry>
        <cfreturn q>
    </cffunction>

    <!--- Fetch logs --->
    <cffunction name="fetchLogs" access="public" returntype="query" output="false">
        <cfset var q = "">
        <cftry>
            <cfquery name="q" datasource="#this.datasource#">
                SELECT log_id, username, action, request_id, details, timestamp
                FROM user_logs
                ORDER BY timestamp DESC
            </cfquery>
        <cfcatch type="any">
            <cflog file="appDebug" text="controller.fetchLogs error: #cfcatch.message#">
            <cfset q = queryNew("log_id,username,action,request_id,details,timestamp")>
        </cfcatch>
        </cftry>
        <cfreturn q>
    </cffunction>


    <!-- GET -->
    <cffunction name="getCustomers" returntype="struct">
    <cfargument name="params" type="struct">

    <cfset var data = application.customerService.getCustomers(
        searchText = params.searchText ?: ""
    )>

    <cfreturn {
    SUCCESS = true,
    DATA = data
        }>

</cffunction>


<cffunction name="ping" access="public" returntype="string">
    <cfreturn "CONTROLLER WORKING">
</cffunction>



    <!-- ADD -->
    <cffunction name="createCustomer" access="public" returntype="struct">
    <cfargument name="info" type="struct">

    <cfif not len(info.name)>
        <cfreturn { success=false, message="Name required" }>
    </cfif>

    <cfif not len(info.email)>
        <cfreturn { success=false, message="Email required" }>
    </cfif>

    <cfset application.customerService.addCustomer(info)>

    <cfreturn {
    success = true,
    message = "Customer added successfully"
}>


</cffunction>


    <!-- EDIT -->
    <cffunction name="editCustomer" access="public" returntype="struct">
        <cfargument name="info" type="struct">

        <cfset application.customerService.updateCustomer(info)>
        <cfreturn { success=true }>
    </cffunction>

    <!-- DELETE -->
    <cffunction name="deleteCustomer" access="public" returntype="struct">
        <cfargument name="id">

        <cfset application.customerService.deleteCustomer(id)>
        <cfreturn { success=true }>
    </cffunction>

</cfcomponent>
