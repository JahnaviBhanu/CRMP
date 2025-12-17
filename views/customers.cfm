<cfif NOT structKeyExists(session, "role") OR session.role NEQ "admin">
    <h2 style="color:red;">❌ Unauthorized Access</h2>
    <cflocation url="home.cfm" addtoken="false">
    <cfabort>
</cfif>


<link rel="stylesheet" href="css/customers.css">
<link rel="stylesheet" href="css/pagination.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">



<div class="container">

    <h2 class="page-title">Customer Management</h2>
    <div class="search-download-wrapper">

    <!-- Search -->
    <form method="get" action="index.cfm" class="search-form">
        <input type="hidden" name="fuse" value="customers">

        <cfparam name="url.searchText" default="">
<cfset url.searchText = trim(url.searchText)>


<cfoutput>
<input type="text"
       name="searchText"
       value="#encodeForHTMLAttribute(url.searchText)#"
       placeholder="Search by Name / Email"
       class="search-input">

</cfoutput>


        <button type="submit" class="search-btn">Search</button>
    </form>

    <!-- Download -->

    <a href="index.cfm?fuse=downloadcus"
   target="_blank"
   class="download-btn"
   title="Download Customers">
    <i class="fa fa-download"></i>
</a>


</div>



    <!-- Add Customer -->
    <form method="post" action="index.cfm?fuse=addcus" class="add-form">
        <input type="text" name="name" placeholder="Name" required>
        <input type="email" name="email" placeholder="Email" required>
        <input type="text" name="phone" placeholder="Phone" required>
        <button type="submit" class="btn btn-primary">Add Customer</button>
         
    </form>

    <!-- Customers Table -->
    <cfset customers = rc.data>

    <table class="customer-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Action</th>
            </tr>
        </thead>

        <tbody>
        <cfif customers.recordCount EQ 0>
            <tr>
                <td colspan="5" align="center"><em>No customers found</em></td>
            </tr>
        <cfelse>
            <cfoutput query="customers">
                <tr>
                    <td>#id#</td>
                    <td>#name#</td>
                    <td>#email#</td>
                    <td>#phone#</td>
                    <td>
                        <a href="views/editCustomer.cfm?id=#id#" class="btn btn-edit">Edit</a>
                        <a href="index.cfm?fuse=deletecus&delete_id=#id#"class="btn btn-delete"
                                onclick="return confirm('Delete this customer?');"> Delete </a>

                    </td>
                </tr>
            </cfoutput>
        </cfif>
        </tbody>
    </table>
    
<div id="pagination"></div>



<script src="Js/pagination.js"></script>



</div>

<div class="back-home-wrapper">
    <a href="index.cfm?fuse=home" class="back-home-btn">
        ⬅ Back To Home
    </a>
</div>


