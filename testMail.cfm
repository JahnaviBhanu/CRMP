<cftry>
    <cfmail
        to="jahnavibhanu124@gmail.com"
        from="mjahnavi875@gmail.com"
        subject="ColdFusion Gmail Final Test"
        type="html">
        <p>SMTP is working 🎉</p>
    </cfmail>

    <h3>Mail sent successfully</h3>

    <cfcatch>
        <cfdump var="#cfcatch#">
    </cfcatch>
</cftry>
