<cfcomponent displayname="Customer API" output="false">

    <!-- GET ALL CUSTOMERS -->
    <cffunction name="getCustomers" access="remote" returnformat="json" output="false">
        <cfquery datasource="crmp_db" name="q">
            SELECT * FROM customers ORDER BY id DESC
        </cfquery>

        <!-- Convert query to array of structs -->
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

    <!-- ADD CUSTOMER -->
    <cffunction name="addCustomer" access="remote" returnformat="json" output="false">
        <cfargument name="name" required="true">
        <cfargument name="email" required="true">
        <cfargument name="phone" required="true">

        <cfquery datasource="crmp_db">
            INSERT INTO customers(name,email,phone)
            VALUES(
                <cfqueryparam value="#arguments.name#">,
                <cfqueryparam value="#arguments.email#">,
                <cfqueryparam value="#arguments.phone#">
            )
        </cfquery>

        <cfreturn {success:true, message:"Customer added!"}>
    </cffunction>

    <!-- UPDATE -->
    <cffunction name="updateCustomer" access="remote" returnformat="json" output="false">
        <cfargument name="id" required="true">
        <cfargument name="name" required="true">
        <cfargument name="email" required="true">
        <cfargument name="phone" required="true">

        <cfquery datasource="crmp_db">
            UPDATE customers
            SET
                name = <cfqueryparam value="#arguments.name#">,
                email = <cfqueryparam value="#arguments.email#">,
                phone = <cfqueryparam value="#arguments.phone#">
            WHERE id = <cfqueryparam value="#arguments.id#">
        </cfquery>

        <cfreturn {success:true, message:"Customer updated!"}>
    </cffunction>

    <!-- DELETE -->
    <cffunction name="deleteCustomer" access="remote" returnformat="json" output="false">
        <cfargument name="id" required="true">

        <cfquery datasource="crmp_db">
            DELETE FROM customers WHERE id=<cfqueryparam value="#arguments.id#">
        </cfquery>

        <cfreturn {success:true, message:"Customer deleted!"}>
    </cffunction>

</cfcomponent>
