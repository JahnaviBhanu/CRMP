<!--- SESSION CHECK --->
<cfif NOT structKeyExists(session, "isLoggedIn")>
  <cflocation url="login.cfm" addtoken="false">
</cfif>


<!--- LOAD PROFILE PIC FROM DB ON PAGE LOAD --->
<cfif NOT structKeyExists(session, "profilePic")>
  <cfquery name="getPic" datasource="#application.datasource#">
    SELECT profile_pic
    FROM users
    WHERE id = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cfif getPic.recordCount AND len(trim(getPic.profile_pic))>
    <cfset session.profilePic = "/CRMP/upload/#getPic.profile_pic#">
  </cfif>
</cfif>

<!--- UPLOAD PROFILE PICTURE --->
<cfif structKeyExists(form, "submit")>
  <cfif structKeyExists(form, "fileUpload") AND len(form.fileUpload) GT 0>

    <cffile 
      action="upload"
      fileField="fileUpload"
      destination="#expandPath('/CRMP/upload')#"
      accept="image/jpeg,image/png,image/gif"
      nameConflict="makeunique"
      result="uploadResult">

    <cfset session.profilePic = "/CRMP/upload/#uploadResult.serverFile#">

    <cfquery datasource="#application.datasource#">
      UPDATE users
      SET profile_pic = <cfqueryparam value="#uploadResult.serverFile#" cfsqltype="cf_sql_varchar">
      WHERE id = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cflocation url="index.cfm?fuse=profile" addtoken="false">
  </cfif>
</cfif>

<!--- DELETE PROFILE PICTURE --->
<cfif structKeyExists(form, "delete")>

  <cfif structKeyExists(session, "profilePic") AND fileExists(expandPath(session.profilePic))>
    <cffile action="delete" file="#expandPath(session.profilePic)#">
  </cfif>

  <cfset structDelete(session, "profilePic")>

  <cfquery datasource="#application.datasource#">
    UPDATE users
    SET profile_pic = NULL
    WHERE id = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cflocation url="index.cfm?fuse=profile" addtoken="false">
</cfif>



<!--- ALERTS --->
<cfif structKeyExists(url, "upload")>
  <script>
    alert("<cfoutput>#url.upload EQ 'success' ? 'Successfully Uploaded!' : 'Successfully Deleted!'#</cfoutput>");
    window.location.href = "index.cfm?fuse=profile";
  </script>
</cfif>

<div class="container">
  <cfoutput>
    <h2>Welcome, #session.username#</h2>
  </cfoutput>

  <cfif structKeyExists(session, "profilePic")>
    <cfoutput>
      <img src="#session.profilePic#" class="profile-pic">
    </cfoutput>
  <cfelse>
    <p>No profile picture uploaded.</p>
  </cfif>

  <!-- Upload -->
  <form method="post" enctype="multipart/form-data">
    <input type="file" name="fileUpload" required>
    <input type="submit" name="submit" value="Upload" class="upload-btn">
  </form>

  <!-- Delete -->
  <form method="post">
    <input type="submit" name="delete" value="Delete Profile Picture" class="delete-btn">
  </form>

  <a href="index.cfm?fuse=home">Back to Home</a>
</div>
<link rel="stylesheet" href="/CRMP/css/myprofile.css">