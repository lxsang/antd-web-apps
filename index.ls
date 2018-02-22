<?lua
    std.html()
    local user = "mrsang"
    local die = function(m)
        echo(m)
        debug.traceback=nil
        error("Permission denied")
    end
    local db = require("db.model").get(user,"user",nil)
    if db == nil then die("cannot get db data") end
    local data, a = db:getAll()
    db:close()
    if data == nil or data[0] == nil then die("Cannot fetch user info") end
    data = data[0]
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Xuan Sang LE, personal site</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" type="text/css" href="grs/ubuntu-regular.css" />
        <link rel="stylesheet" type="text/css" href="grs/font-awesome.css" />
        <link rel="stylesheet" type="text/css" href="grs/mainsite.css" />
        <script src="grs/gscripts/jquery-3.2.1.min.js"> </script>
        <script src="grs/resources/antos_tags.js" type="riot/tag"></script>
        <script src="grs/gscripts/riot.compiler.min.js"> </script>
        <script>
            var scheme = undefined;
            function mailtoMe()
            {
                if(scheme) return;
                // get scheme
                $.get( "grs/sendto.html")
                .done(function(d) {
                    scheme = $.parseHTML(d)
                    var observable = riot.observable()
                    $("#desktop").append(scheme)
                    riot.mount($(scheme), {observable:observable})
                    observable.on("exit", function(){
                        $(scheme).remove()
                        scheme = undefined
                    })
                    observable.on("rendered", function(){
                        $("#send").click(function(){
                            $("#status").html("");
                            var els = $("[data-class='data']")
                            var data = {}
                            
                            for(var i = 0; i < els.length; i++)
                                data[els[i].name] = $(els[i]).val()
                            if(data.email == "" || data.subject == "" || data.content == "" || data.name == "")
                                return $("#status").html("Please enter all the fields");
                            var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                            if(!re.test(String(data.email).toLowerCase()))
                                return $("#status").html("Email is not correct");
                            
                            $.ajax({
                                type: 'POST',
                                url: "info/sendmail.lua",
                                contentType: 'application/json',
                                data: JSON.stringify(data),
                                dataType: 'json',
                                success: null
                            }).done(function(r){
                                if(r.error)
                                    alert(r.error)
                                else
                                {
                                    observable.trigger("exit")
                                    alert("Thank")
                                }
                            }).fail(function(){
                                alert("Service unavailable at the moment")
                            })
                        })
                    })
                })
                .fail(function() {
                    alert( "Cannot get the form" );
                })
            }
        </script>
    </head>
    <body>
        <div id = "desktop">
            <div id = "top">
                <ul>
                    <li ><i class = "fa fa-address-card"></i><a href="https://info.lxsang.me" target="_blank">Porfolio</a></li>
                    <li><i class = "fa fa-newspaper-o"></i><a href="https://blog.lxsang.me" target="_blank">Blog</a></li>
                    <li><i class = "fa fa-paper-plane"></i><a href="#" onclick="mailtoMe()" >Contact</a></li>
                    <li > <i class = "fa fa-globe"></i><a href = "https://os.lxsang.me" target="_blank">Web OS</a></li>
                </ul>
            </div>
            <div id = "center">
                <div id = "container">
                    <img src = "grs/images/mrsang.png" ></img>
                    <div id = "vcard">
                        <p class = "greeting">Hi, I'm <b>Xuan Sang LE</b></p>
                        <p class = "dedicate">
                            <span class="fa fa-quote-left"></span>
                            <span>
                                    <?=data.shortbiblio?>
                            </span>
                            <span class="fa fa-quote-right"></span>
                        </p>
                    </div>
                </div>
            </div>
            <div id = "bottom">
                Powered by antd server, (c) 2017 - 2018 Xuan Sang LE
            </div>
        </div>
    </body>
</html>