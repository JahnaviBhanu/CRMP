<cfsetting showdebugoutput="false">

<!--- Identify scheduler execution --->
<cfset request.isScheduler = true>

<cftry>

    <!--- =========================
         CONFIG
    ========================== --->
    <cfset adminEmail = "jahnavibhanu124@gmail.com">
    <cfset todayStart = createDateTime(year(now()), month(now()), day(now()), 0, 0, 0)>
    <cfset tomorrowStart = dateAdd("d", 1, todayStart)>

    <!--- =========================
         FETCH TODAY'S DOWNLOADS
    ========================== --->
    <cfquery name="getDownloads" datasource="crmp_db">
        SELECT downloaded_at
        FROM download_logs
        WHERE downloaded_at >= <cfqueryparam value="#todayStart#" cfsqltype="cf_sql_timestamp">
          AND downloaded_at <  <cfqueryparam value="#tomorrowStart#" cfsqltype="cf_sql_timestamp">
        ORDER BY downloaded_at ASC
    </cfquery>

    <!--- =========================
         BUILD DOWNLOAD LIST
    ========================== --->
    <cfset timeList = "">

    <cfif getDownloads.recordCount GT 0>
        <cfoutput query="getDownloads">
            <cfset timeList &= 
                dateFormat(downloaded_at, "dd-mmm-yyyy") & " " &
                timeFormat(downloaded_at, "hh:mm:ss tt") & "<br>"
            >
        </cfoutput>
    <cfelse>
        <cfset timeList = "<em>No downloads today</em>">
    </cfif>

    <!--- =========================
         EMAIL BODY
    ========================== --->
    <cfset bodyText = "
        Hello Admin,<br><br>

        <b>Customers PDF Download Report for Today</b><br><br>

        <strong>Total Downloads Today:</strong> #getDownloads.recordCount#<br><br>

        <strong>Download Times:</strong><br>
        #timeList#<br><br>

        Regards,<br>
        CRM System
    ">

    <!--- =========================
         SEND EMAIL
    ========================== --->
    <cfmail
        to="#adminEmail#"
        from="mjahnavi875@gmail.com"
        subject="Daily PDF Download Report"
        type="html">
        #bodyText#
    </cfmail>

    <!--- =========================
         SUCCESS LOG
    ========================== --->
    <cflog file="dailyMail"
           text="Daily download report sent successfully. Count: #getDownloads.recordCount#">

<cfcatch type="any">

    <!--- =========================
         ERROR LOG
    ========================== --->
    <cflog file="dailyMailError"
           text="Scheduler Mail Failed | #cfcatch.message# | #cfcatch.detail#">

</cfcatch>

</cftry>

