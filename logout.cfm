<cfset structClear(session)>
<cfset sessionInvalidate()>

<cflocation url="login.cfm" addtoken="false">
