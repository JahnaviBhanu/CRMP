<cfset structClear(session)>
<cfset sessionInvalidate()>

<cflocation 
    url="/CRMP/index.cfm?fuse=login&msg=logout"
    addtoken="false">
