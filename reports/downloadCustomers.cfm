<cfquery name="qCustomers" datasource="crmp_db">
    SELECT id, name, email, phone
    FROM customers
    ORDER BY id ASC
</cfquery>

<!--- Log the PDF download --->
<cfquery datasource="#application.datasource#">
    INSERT INTO download_logs (downloaded_at)
    VALUES (NOW())
</cfquery>


<!-- Create PDF in memory -->
<cfdocument format="PDF" filename="Customer_List.pdf" overwrite="yes" name="pdfContent" pagetype="A4">
    <html>
    <head>
        <style>
            body { font-family: Arial, sans-serif; }
            h2 { text-align: center; }
            table { width:100%; border-collapse: collapse; margin-top: 15px; }
            th, td { border:1px solid #444; padding:8px; font-size:14px; }
            th { background:#007BFF; color:white; }
            tr:nth-child(even) { background:#f2f2f2; }
        </style>
    </head>

    <body>
        <h2>Customer List</h2>
        <table>
            <tr>
                <th>ID</th><th>Name</th><th>Email</th><th>Phone</th>
            </tr>

            <cfoutput query="qCustomers">
                <tr>
                    <td>#id#</td>
                    <td>#name#</td>
                    <td>#email#</td>
                    <td>#phone#</td>
                </tr>
            </cfoutput>
        </table>
    </body>
    </html>
</cfdocument>

<!-- Return PDF inline so it opens in new tab -->
<cfheader name="Content-Type" value="application/pdf">
<cfheader name="Content-Disposition" value="inline; filename=Customer_List.pdf">
<cfcontent type="application/pdf" variable="#pdfContent#">
