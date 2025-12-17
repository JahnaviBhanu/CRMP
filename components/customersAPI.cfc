<cfcomponent displayname="Customer API" output="false">

<cffunction name="getCustomers" access="remote" returnformat="json" output="false">
    <cfargument name="searchText" type="string" default="">

    <cfquery name="q" datasource="#application.datasource#">
        SELECT *
        FROM customers
        <cfif len(trim(arguments.searchText))>
            WHERE name LIKE <cfqueryparam value="%#arguments.searchText#%" cfsqltype="cf_sql_varchar">
               OR email LIKE <cfqueryparam value="%#arguments.searchText#%" cfsqltype="cf_sql_varchar">
               OR phone LIKE <cfqueryparam value="%#arguments.searchText#%" cfsqltype="cf_sql_varchar">
        </cfif>
        ORDER BY id DESC
    </cfquery>

    <cfset var resultArray = []>
    <cfloop query="q">
        <cfset arrayAppend(resultArray, {
            "ID" = q.id,
            "NAME" = q.name,
            "EMAIL" = q.email,
            "PHONE" = q.phone
        })>
    </cfloop>

    <cfreturn { "data" = resultArray }>
</cffunction>


    <!-- ADD CUSTOMER -->
<!-- ADD CUSTOMER -->
<cffunction name="addCustomer" access="remote" returntype="any" returnformat="json" output="false">
    <cfargument name="name" type="string" required="yes">
    <cfargument name="email" type="string" required="yes">
    <cfargument name="phone" type="string" required="yes">

    <!--- VALIDATE: must be 10 digits --->
    <cfif NOT REFind("^[0-9]{10}$", arguments.phone)>
        <cfreturn { "success" = false, "message" = "Phone must be exactly 10 digits" }>
    </cfif>

    <!--- CHECK DUPLICATE PHONE --->    
    <cfquery name="checkPhone" datasource="#application.datasource#">
        SELECT id 
        FROM customers 
        WHERE phone = <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif checkPhone.recordCount GT 0>
        <cfreturn { "success" = false, "message" = "Phone already exists" }>
    </cfif>


    <!--- INSERT CUSTOMER WITH UNIQUE NAME HANDLING --->
    <cftry>

        <cfquery datasource="#application.datasource#">
            INSERT INTO customers (name, email, phone)
            VALUES (
                <cfqueryparam value="#arguments.name#"  cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>

        <cfreturn { "success" = true }>

        <cfcatch type="database">
            <!-- UNIQUE NAME ERROR -->
            <cfif findNoCase("Duplicate entry", cfcatch.message)>
                <cfreturn { "success" = false, "message" = "Name already exists" }>
            </cfif>

            <!-- OTHER SQL ERRORS -->
            <cfreturn { "success" = false, "message" = cfcatch.message }>
        </cfcatch>

    </cftry>

</cffunction>


    <!-- UPDATE CUSTOMER -->
    <cffunction name="updateCustomer" access="remote" returnformat="plain" output="false">
        <cfargument name="id"    type="numeric">
        <cfargument name="name"  type="string">
        <cfargument name="email" type="string">
        <cfargument name="phone" type="string">

        <cfquery datasource="#application.datasource#">
            UPDATE customers
            SET name = <cfqueryparam value="#arguments.name#"  cfsqltype="cf_sql_varchar">,
                email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
                phone = <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">
            WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn "updated">
    </cffunction>



    <!-- DELETE CUSTOMER -->
    <cffunction name="deleteCustomer" access="remote" returnformat="plain" output="false">
        <cfargument name="id" type="numeric">

        <cfquery datasource="#application.datasource#">
            DELETE FROM customers
            WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn "deleted">
    </cffunction>



    <!-- SEARCH CUSTOMERS -->
    <cffunction name="searchCustomers" access="remote" returnformat="json" output="false">
        <cfargument name="searchText" type="string">

        <cfquery datasource="#application.datasource#" name="q">
            SELECT id, name, email, phone
            FROM customers
            WHERE name  LIKE <cfqueryparam value="%#arguments.searchText#%" cfsqltype="cf_sql_varchar">
               OR email LIKE <cfqueryparam value="%#arguments.searchText#%" cfsqltype="cf_sql_varchar">
            ORDER BY id DESC
        </cfquery>

        <cfset result = []>
        <cfloop query="q">
            <cfset arrayAppend(result, {
                id = q.id,
                name = q.name,
                email = q.email,
                phone = q.phone
            })>
        </cfloop>

        <cfreturn result>
    </cffunction>



</cfcomponent>
