
 <?lua
 if REQUEST.method == "POST" then
    return echo(JSON.encode(REQUEST))
end
 ?>
<form action="https://apps.localhost:9195/index/upload" method="post" enctype="multipart/form-data">
    Select image to upload:
    <input type="file" name="fileToUpload" id="fileToUpload">
       <input type="file" name="fileToUpload1" id="fileToUpload1">
    <input type="submit" value="Upload Image" name="submit">
</form>