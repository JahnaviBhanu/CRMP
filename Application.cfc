<cfcomponent output="false">

  <!--- App settings --->
  <cfset this.name = "CRMP_App">
  <cfset this.datasource = "crmp_db">
  <cfset this.sessionManagement = true>
  <cfset this.applicationTimeout = createTimeSpan(1,0,0,0)>
  <cfset this.sessionTimeout = createTimeSpan(0,1,0,0)>

  <cfsetting enablecfoutputonly="No">

  <!--- Application start --->
  <cffunction name="onApplicationStart" returnType="boolean" output="false">
    <cftry>
      <cfset application.controller = createObject("component", "CRMP.controller")>
      <cfset application.customers  = createObject("component", "components.customersAPI")>
      <cfset application.datasource = this.datasource>
      <cfset application.startTime = now()>
      <cfreturn true>
    <cfcatch>
      <cflog file="appDebug" text="onApplicationStart error: #cfcatch.message#">
      <cfreturn false>
    </cfcatch>
    </cftry>
  </cffunction>

  <!--- Session start --->
 <cffunction name="onSessionStart" returnType="void" output="false">
    <cfset session.isLoggedIn = false>
</cffunction>


  

<cffunction name="onRequestStart" returnType="boolean" output="true">
    <cfargument name="targetPage" required="true">

    <!--- Allow scheduler --->
    <cfif structKeyExists(request, "isScheduler") AND request.isScheduler>
        <cfreturn true>
    </cfif>

    <cfset var pageName = lcase(getFileFromPath(arguments.targetPage))>

    <cfset var noLayoutPages = "login.cfm,register.cfm,forgotpassword.cfm,resetpassword.cfm,footer.cfm">

    <cfif NOT listFindNoCase(noLayoutPages, pageName)>
        <cfif NOT structKeyExists(session, "isLoggedIn") OR session.isLoggedIn NEQ true>
            <cflocation url="/CRMP/index.cfm?fuse=login" addtoken="false">
            <cfreturn false>
        </cfif>
    </cfif>

    <cfif NOT listFindNoCase(noLayoutPages, pageName)>
        <cfinclude template="/CRMP/includes/header.cfm">
    </cfif>

    <cfreturn true>
</cffunction>

  <!--- Request end (FOOTER INCLUDED HERE) --->
  <cffunction name="onRequestEnd" returnType="void" output="true">
    <cfargument name="targetPage" required="true">

    <cfset var pageName = lcase(getFileFromPath(arguments.targetPage))>
    <cfset var noLayoutPages = "login.cfm,register.cfm,forgotpassword.cfm,reset.cfm">

    <!--- Skip footer for excluded pages --->
    <cfif NOT listFindNoCase(noLayoutPages, pageName)>
      <cfinclude template="/CRMP/includes/footer.cfm">
    </cfif>

  </cffunction>
 


</cfcomponent>
