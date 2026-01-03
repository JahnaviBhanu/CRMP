<!--- Make sure application.controller exists --->
<cfif NOT structKeyExists(application, "controller")>
    <cfabort showerror="Controller not found! Check Application.cfc">
</cfif>

<!--- Ensure url.fuse exists and normalize it --->
<cfparam name="url.fuse" default="home">
<cfset fuse = lcase(trim(url.fuse))>

<!--- Default url params --->
<cfparam name="url.department" default="">
<cfparam name="url.searchText" default="">
<cfparam name="url.page" default="1">
<cfparam name="url.id" default="">

<!-- ensure rc exists and rc.data is a query/empty query -->
<cfset rc = {} />
<cfset rc.data = queryNew("") />

<!-- BACKWARDS COMPATIBILITY: set aliases used by older views -->
<cfset request.data = rc.data>
<cfset data = rc.data>

<!--- ROUTES --->

<cfif fuse eq "home">
    <cftry>
        <cfset rc.data = application.controller.home() />
    <cfcatch>
        <cflog file="appDebug" text="router.home error: #cfcatch.message#">
    </cfcatch>
    </cftry>

    <cfinclude template="views/home.cfm">

<cfelseif fuse eq "profile">

    <cfinclude template="views/myprofile.cfm">

<cfelseif fuse eq "viewrequests">
    <!-- store current filters for PDF -->
<cfset session.requestFilters = {
    department = url.department,
    searchText = url.searchText
}>


    <cftry>
        <cfset rc.data = application.controller.fetchRequests(
            department = url.department,
            searchText = url.searchText
        ) />
    <cfcatch>
        <cflog file="appDebug" text="router.viewRequests error: #cfcatch.message#">
    </cfcatch>
    </cftry>

    <cfinclude template="views/view.cfm">

<cfelseif fuse eq "submitrequest">

    <cfinclude template="views/add.cfm">

<cfelseif fuse eq "addreq">

    <cftry>
        <cfset formRes = application.controller.createRequest(info=form) />
    <cfcatch>
        <cflog file="appDebug" text="router.addreq error: #cfcatch.message#">
        <cfset formRes = "Error occurred.">
    </cfcatch>
    </cftry>

    <cfif len(formRes) lt 11>
        <cflocation url="index.cfm?fuse=viewRequests" addtoken="no">
    <cfelse>
        <cfset rc.formErrors = formRes>
        <cfinclude template="formValidationFailed.cfm">
    </cfif>

<cfelseif fuse eq "edit">

    <cfinclude template="views/edit.cfm">

    
<cfelseif fuse eq "delete">

<cfinclude template="views/delete.cfm">

<cfelseif fuse eq "logs">

    <cftry>
        <cfset rc.data = application.controller.fetchLogs() />
    <cfcatch>
        <cflog file="appDebug" text="router.logs error: #cfcatch.message#">
    </cfcatch>
    </cftry>

    <cfinclude template="views/logs.cfm">

<cfelseif fuse eq "users">

    <cftry>
        <cfset rc.data = application.controller.fetchUsers() />
    <cfcatch>
        <cflog file="appDebug" text="router.users error: #cfcatch.message#">
    </cfcatch>
    </cftry>

    <cfinclude template="views/registredUsers.cfm">
<cfelseif fuse eq "downloadcus">
    <cfinclude template="/CRMP/views/downloadCustomers.cfm">

<cfelseif fuse eq "downloadreq">
    <cfinclude template="/CRMP/views/view_downloadRequests.cfm">


<cfelseif fuse eq "customers">
    <cfinclude template="views/customer.cfm">


<cfelseif fuse eq "api_getcustomers">

    <cfparam name="url.searchText" default="">

    <cftry>
        <cfset data = application.customerService.getCustomers(
            searchText = url.searchText
        )>

        <cfcontent type="application/json">
        <cfoutput>#serializeJSON({
            success = true,
            DATA = data
        })#</cfoutput>

    <cfcatch>
        <cfcontent type="application/json">
        <cfoutput>#serializeJSON({
            success = false,
            message = cfcatch.message
        })#</cfoutput>
    </cfcatch>
    </cftry>

    <cfabort>

<cfelseif fuse eq "api_addcustomer">

    <cfcontent type="application/json">

    <cftry>
        <cfset application.controller.createCustomer(info=form) />

        <cfoutput>#serializeJSON({
            success = true,
            message = "Customer added successfully"
        })#</cfoutput>

    <cfcatch>
        <cfoutput>#serializeJSON({
            success = false,
            message = cfcatch.message
        })#</cfoutput>
    </cfcatch>
    </cftry>

    <cfabort>



<cfelseif fuse eq "api_editcustomer">
    <cftry>
        <cfset application.controller.editCustomer(info=form) />
        <cfoutput>#serializeJSON({success=true})#</cfoutput>
    <cfcatch>
        <cfoutput>#serializeJSON({success=false,message=cfcatch.message})#</cfoutput>
    </cfcatch>
    </cftry>
    <cfabort>

<cfelseif fuse eq "api_deletecustomer">
    <cftry>
        <cfset application.controller.deleteCustomer(id=form.id) />
        <cfoutput>#serializeJSON({success=true})#</cfoutput>
    <cfcatch>
        <cfoutput>#serializeJSON({success=false,message=cfcatch.message})#</cfoutput>
    </cfcatch>
    </cftry>
    <cfabort>

</cfif>

