<cfsetting showdebugoutput="false">

<cfschedule
    action="update"
    task="DailyDownloadMail"
    operation="HTTPRequest"
    url="http://127.0.0.1:8500/CRMP/scheduleEmail.cfm"
    startDate="#dateFormat(now(), 'mm/dd/yyyy')#"
    startTime="16:10"
    interval="daily"
    repeat="1"
    requestTimeout="300"
/>

<cfoutput>
    Scheduler task created / updated successfully.
</cfoutput>
