<?lua
    std.html()
    local user = "mrsang"
    local die = function(m)
        echo(m)
        debug.traceback=nil
        error("Permission denied")
    end
    local mobilecls = ""
    if HEADER.mobile then mobilecls = "mobile" end
    local db = require("db.model").get(user,"user",nil)
    if db == nil then die("cannot get db data") end
    local data, a = db:getAll()
    db:close()
    if data == nil or data[1] == nil then die("Cannot fetch user info") end
    data = data[1]
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Hi, I'm Xuan Sang LE</title>
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
                    var obs = riot.observable()
                    $(scheme).css("visibility","hidden")
                    $("#desktop").append(scheme)
                    obs.on("exit", function(){
                        $(scheme).remove()
                        scheme = undefined
                    })
                    obs.on("rendered", function(d){
                        $("[data-id='send']", scheme).click(function(){
                            var status = $("[data-id='status']", scheme)
                            status.html("");
                            var els = $("[data-class='data']", scheme)
                            var data = {}
                            
                            for(var i = 0; i < els.length; i++)
                                data[els[i].name] = $(els[i]).val()
                            if(data.email == "" || data.subject == "" || data.content == "" || data.name == "")
                                return status.html("Please enter all the fields");
                            var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                            if(!re.test(String(data.email).toLowerCase()))
                                return status.html("Email is not correct");
                            
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
                                    obs.trigger("exit")
                                    alert("Email sent. Thank")
                                }
                            }).fail(function(){
                                alert("Service unavailable at the moment")
                            })
                        })
                        $(scheme).css("visibility","visible")
                    })
                    riot.mount(scheme, {observable:obs})
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
                    <li ><i class = "fa fa-address-card"></i><a href="https://info.lxsang.me" >Porfolio</a></li>
                    <li><i class = "fa fa-newspaper-o"></i><a href="https://blog.lxsang.me" >Blog</a></li>
                    <li><i class = "fa fa-paper-plane"></i><a href="#" onclick="mailtoMe()" >Contact</a></li>
                    <li > <i class = "fa fa-globe"></i><a href = "https://os.lxsang.me" target="_blank">Web OS</a></li>
                </ul>
            </div>
            <div id = "center">
                <div id = "container" class="<?=mobilecls?>" >
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
                        <a href="https://info.lxsang.me" class ="about">Find out more about me</a>
                    </div>
                </div>
            </div>
            <div id = "bottom">
                Powered by antd server, (c) 2017 - 2018 Xuan Sang LE
            </div>
        </div>
    </body>
</html>