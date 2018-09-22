<?lua
echo(JSON.encode(REQUEST))
?>
<form action="https://apps.localhost:9192/index/testrq" enctype="multipart/form-data" method="post">
  <input type="file" name="fileToUpload" id="fileToUpload"><br>
  First name:<br>
  <input type="text" name="firstname" value="Mickey"><br>
  Last name:<br>
  <input type="text" name="lastname" value="Mouse"><br><br>
  <input type="submit" value="Submit">
</form>