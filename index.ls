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
    </head>
    <body>
        <div id = "layout">
            <div id = "top">
                <ul>
                    <li ><i class = "fa fa-address-card"></i><a href="https://info.lxsang.me" target="_blank">Porfolio</a></li>
                    <li><i class = "fa fa-newspaper-o"></i><a href="https://blog.lxsang.me" target="_blank">Blog</a></li>
                    <li><i class = "fa fa-paper-plane"></i>Contact</li>
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
                Powered by antd, (c) 2017 - 2018 Xuan Sang LE
            </div>
        </div>
    </body>
</html>