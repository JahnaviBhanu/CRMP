<!DOCTYPE html>
<html>
<head>
    <title>Registered Users</title>

    <!-- Fix body height & layout -->
    <link rel="stylesheet" href="css/regUsers.css">
    <link rel="stylesheet" href="css/pagination.css">
</head>

<body>

<!-- HEADER + SESSION -->


<cfset getUsers=rc.data>
<!-- PAGE CONTENT -->
<div class="content-wrapper">

    <h3>Registered Users</h3>

    <table>
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Role</th>
        </tr>

        <cfoutput query="getUsers">
            <tr>
                <td>#ID#</td>
                <td>#Username#</td>
                <td>#Email#</td>
                <td>#Role#</td>
            </tr>
        </cfoutput>
    </table>
<div class="back-home-wrapper">
    <a href="index.cfm?fuse=home" class="back-home-btn">
        ⬅ Back To Home
    </a>
</div>

    <!-- Pagination -->
    <div id="paginationControls"></div>
    <script src="Js/pagination.js"></script>

</div>


<!-- FOOTER -->


</body>
</html>
