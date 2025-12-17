<cfif NOT structKeyExists(session,"username")>
    <cflocation url="login.cfm">
</cfif>

<!DOCTYPE html>
<html>
<head>
    <title>View Requests</title>

    <link rel="stylesheet" href="css/view.css">
    <link rel="stylesheet" href="css/pagination.css">

    <script>
    function removeEmptySearch() {
        let searchInput = document.getElementById("searchText");
        if (searchInput && searchInput.value.trim() === "") {
            searchInput.name = ""; 
        }
    }
    </script>

  
</head>

<body>


<div class="container">

    <!-- Default URL values -->
    <cfparam name="url.department" default="">
    <cfparam name="url.searchText" default="">
    <cfparam name="url.page" default="1">

    <!-- Filter Form -->
    <form method="get" action="index.cfm">
        <input type="hidden" name="fuse" value="viewRequests">

        <label for="department"><strong>Department:</strong></label>
        <select name="department" id="department">
            <option value="">--All Departments--</option>
            <option value="HR"      <cfif url.department EQ "HR">selected</cfif>>HR</option>
            <option value="Finance" <cfif url.department EQ "Finance">selected</cfif>>Finance</option>
            <option value="IT"      <cfif url.department EQ "IT">selected</cfif>>IT</option>
            <option value="Sales"   <cfif url.department EQ "Sales">selected</cfif>>Sales</option>
            <option value="Admin"   <cfif url.department EQ "Admin">selected</cfif>>Admin</option>
        </select>

        <label for="searchText"><strong>Search:</strong></label>
        <cfoutput>
        <input type="text" class="search-btn" name="searchText" id="searchText"   value="#url.searchText#" placeholder="Search title or description" >
        </cfoutput>

        <input type="submit" value="Search">
        <a href="index.cfm?fuse=viewRequests" class="clear-btn">Clear</a>

        

        <cfoutput>
            <a href="reports/view_downloadRequests.cfm?department=#url.department#" 
               target="_blank" class="btn-pdf">Download PDF</a>
        </cfoutput>
    </form>

    <!-- FIX: Correct variable from router -->
    <cfset getAllRequests = rc.data>



    <!-- Display Table -->
    <table border="1" cellpadding="8" width="100%">
        <tr>
            <th>Department</th>
            <th>Title</th>
            <th>Description</th>
            <th>Actions</th>
        </tr>

        <cfif getAllRequests.recordCount EQ 0>
            <tr>
                <td colspan="4" align="center"><em>No records found</em></td>
            </tr>
        <cfelse>
            <cfoutput query="getAllRequests">
            
                <tr>
                    <td>#department#</td>
                    <td>#request_title#</td>
                    <td>#request_desc#</td>
                    
                    <td>

                    <a href="views/edit.cfm?req_id=#req_id#" class="btn btn-edit">Edit</a>
                    <a href="views/delete.cfm?req_id=#req_id#"  class="btn btn-delete"
                        onclick="return confirm('Are you sure you want to delete this request?');">
                         Delete
                    </a>

                    </td>
                </tr>
            </cfoutput>
        </cfif>
    </table>
  <div class="back-home-wrapper">
    <a href="index.cfm?fuse=home" class="back-home-btn">
        ⬅ Back To Home
    </a>
</div>



    <div id="paginationControls"></div>
    

</div>


<script src="Js/pagination.js"></script>



</body>
</html>
