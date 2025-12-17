<cfschedule 
    action="update"
    task="DailyDownloadReport"
    url="http://localhost:8500/CRMP/Pages/scheduleEmail.cfm"
    startDate="11/23/2025"
    endDate="12/23/2025"
    startTime="20:00"
    interval="daily"
    publish="false"
    requesttimeout="300">
</cfschedule>
<p>Task scheduled: Daily at 20:00 from 11/23/2025 to 12/23/2025</p>
