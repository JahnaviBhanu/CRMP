<cfcomponent output="false">

    <!-- GET CUSTOMERS -->
    <cffunction name="getCustomers" returntype="array">
        <cfargument name="searchText" default="">

        <cfquery name="q" datasource="#application.datasource#">
            SELECT id, name, email, phone
            FROM customers
            <cfif len(trim(arguments.searchText))>
                WHERE name LIKE <cfqueryparam value="%#arguments.searchText#%">
                   OR email LIKE <cfqueryparam value="%#arguments.searchText#%">
                   OR phone LIKE <cfqueryparam value="%#arguments.searchText#%">
            </cfif>
            ORDER BY id DESC
        </cfquery>

        <cfset var arr = []>
        <cfloop query="q">
            <cfset arrayAppend(arr, {
                id = q.id,
                name = q.name,
                email = q.email,
                phone = q.phone
            })>
        </cfloop>

        <cfreturn arr>
    </cffunction>

    <!-- ADD -->
    <cffunction name="addCustomer">
        <cfargument name="data" type="struct">

        <cfquery datasource="crmp_db">
            INSERT INTO customers (name, email, phone)
            VALUES (
                <cfqueryparam value="#data.name#">,
                <cfqueryparam value="#data.email#">,
                <cfqueryparam value="#data.phone#">
            )
        </cfquery>
    </cffunction>

    <!-- UPDATE -->
    <cffunction name="updateCustomer">
        <cfargument name="data" type="struct">

        <cfquery datasource="#application.datasource#">
            UPDATE customers
            SET name  = <cfqueryparam value="#data.name#">,
                email = <cfqueryparam value="#data.email#">,
                phone = <cfqueryparam value="#data.phone#">
            WHERE id = <cfqueryparam value="#data.id#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cffunction>

    <!-- DELETE -->
    <cffunction name="deleteCustomer">
        <cfargument name="id">

        <cfquery datasource="#application.datasource#">
            DELETE FROM customers
            WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cffunction>

</cfcomponent>
