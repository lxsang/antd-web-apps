<?lua
    std.html()
    local die = function(m)
        echo(m)
        debug.traceback=nil
        error("Permission denied")
    end
    local mobilecls = ""
    if HEADER.mobile then mobilecls = "mobile" end
    local db = DBModel:new{db="/home/dany/databases/mrsang.db"}
    if db == nil then die("cannot get db data") end
    db:open()
    local data, a = db:getAll("user")
    db:close()
    if data == nil or data[1] == nil then die("Cannot fetch user info") end
    data = data[1]
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Hi, I'm <?=data.fullname?></title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Ubuntu:regular,bold&subset=Latin">
        <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" />
        <link rel="stylesheet" type="text/css" href="grs/mainsite.css" />
    </head>
    <body>
        <div id = "desktop">
            <div id = "top">
                <ul>
                    <li ><i class = "fa fa-address-card"></i><a href="https://info.lxsang.me" >Porfolio</a></li>
                    <li><i class = "fa fa-newspaper-o"></i><a href="https://blog.lxsang.me" >Blog</a></li>
                    <li > <i class = "fa fa-globe"></i><a href = "https://os.iohub.dev" target="_blank">Web OS</a></li>
                </ul>
            </div>
            <div id = "center">
                <div id = "container" class="<?=mobilecls?>" >
                    <img src = "grs/images/mrsang.png" ></img>
                    <div id = "vcard">
                        <p class = "greeting">Hi, I'm <b><?=data.fullname?></b></p>
                        <p class = "dedicate">
                            <span class="fa fa-quote-left"></span>
                            <span>
                                    <?=data.shortbiblio?>
                            </span>
                            <span class="fa fa-quote-right"></span>
                        </p>
                        <a href="https://blog.iohub.dev" class ="about">Read my blog</a>
                        <a href="https://info.iohub.dev" class ="about">More about me</a>
                    </div>
                </div>
            </div>
            <div id = "bottom">
                Powered by antd server, (c) 2017 - 2022 Dany LE
            </div>
        </div>
    </body>
</html>