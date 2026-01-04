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
      <cfset application.customerService  = createObject("component", "components.CustomerService")>
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
    <!-- nothing here -->
</cffunction>

<cffunction name="onRequestStart" returnType="boolean" output="true">
    <cfargument name="targetPage" required="true">

    <cfset var fuse = structKeyExists(url,"fuse") ? lcase(url.fuse) : "login">
    <cfset var publicFuses = "login,register,forgotpassword,resetpassword">

    <!-- if user NOT logged in -->
    <cfif NOT structKeyExists(session,"isLoggedIn") OR session.isLoggedIn NEQ true>

        <!-- trying to access protected page -->
        <cfif NOT listFindNoCase(publicFuses, fuse)>
            <cflocation 
                url="/CRMP/index.cfm?fuse=login&msg=sessionExpired"
                addtoken="false">
        </cfif>

    </cfif>

    <!-- include header only for protected pages -->
    <cfif listFindNoCase(publicFuses, fuse) EQ 0>
        <cfinclude template="/CRMP/includes/header.cfm">
    </cfif>

    <!-- prevent browser cache -->
    <cfheader name="Cache-Control" value="no-store, no-cache, must-revalidate, max-age=0">
    <cfheader name="Pragma" value="no-cache">
    <cfheader name="Expires" value="0">

    <cfreturn true>
</cffunction>

  <!--- Request end (FOOTER INCLUDED HERE) --->
  <cffunction name="onRequestEnd" returnType="void" output="true">
    <cfargument name="targetPage" required="true">

    <cfset var pageName = lcase(getFileFromPath(arguments.targetPage))>
    <cfset var noLayoutPages = "login.cfm,register.cfm,forgotpassword.cfm,reset.cfm,help.cfm,privacy.cfm,contact.cfm">

    <!--- Skip footer for excluded pages --->
    <cfif NOT listFindNoCase(noLayoutPages, pageName)>
      <cfinclude template="/CRMP/includes/footer.cfm">
    </cfif>

  </cffunction>
 


</cfcomponent>
