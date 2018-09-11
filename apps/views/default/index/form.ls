 <?lua
 if REQUEST.method == "POST" then
    return echo(JSON.encode(REQUEST))
end
 ?>
 <form action="https://apps.localhost:9195/index/form" method="post">
  <fieldset>
    <legend>Personal information:</legend>
    First name:<br>
    <input type="text" name="firstname" value="Mickey"><br>
    Last name:<br>
    <input type="text" name="lastname" value="Mouse"><br><br>
    <input type="submit" value="Submit">
  </fieldset>
</form> 