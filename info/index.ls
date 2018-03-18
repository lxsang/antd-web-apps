<?lua
    std.html()
    local user = "mrsang"
    local die = function(m)
        echo(m)
        debug.traceback=nil
        error("Permission denied")
    end
    local sectionByCID = function(id)
        local db = require("db.model").get(user,"cv_sections",nil)
        if db == nil then die("Cannot get the cv_sections table") end
        local cond = { exp = { ["="] = { cid = id } } , order = { start = "DESC" } }
        local data, a = db:find(cond)
        db:close()
        return data, a
    end
    local db = require("db.model").get(user,"user",nil)
    if db == nil then die("cannot get db data") end
    local data, a = db:getAll()
    db:close()
    if data == nil or data[1] == nil then die("Cannot fetch user info") end
    data = data[1]
?>
<html>
    <head>
        <!--script type="text/javascript" src="../os/scripts/jquery-3.2.1.min.js"></script-->
        <script type="text/javascript" src="rst/gscripts/showdown.min.js"></script>
        <!--link rel="stylesheet" type="text/css" href="grs/ubuntu-regular.css" /-->
        <link rel="stylesheet" type="text/css" href="style.css" />
        <link rel="stylesheet" type="text/css" href="rst/font-awesome.css" />
        <title>Porfolio</title>
    </head>
    <body>
    <div class="layout">
        
        <div class = "cv-content">
            <h1>
                <span class="name"><?=data.fullname?></span>
                <span class="cv">Curriculum Vitae</span>
            </h1>
            <p class="coordination">
                <span class="fa fa-home"></span><?=data.address?></p>
            <p class="coordination">
                <span class="fa fa-phone"></span>
                <span class="text"><?=data.Phone?></span>
                <span class="fa fa-envelope-o"></span>
                <span class="text"><?=data.email?></span>
                <span class="fa fa-globe"></span>
                <span class="text"><a href ="<?=data.url?>"><?=data.url?></a></span>
            </p>
            <p class="shortbio">
                <span class="fa fa-quote-left"></span>
                <span><?=data.shortbiblio?></span>
                <span class="fa fa-quote-right"></span>
            </p>
<?lua
    -- query the the sections list
    db = require("db.model").get(user,"cv_cat",nil)
    if db == nil then die("Cannot get the cv_cat table") end
    local cond = { exp = { ["="] = { pid = 0 } }, order = { name = "ASC" } }
    data, a = db:find(cond)
    if data then
        for k, idx in pairs(a) do
            local cat = data[idx]
            cond = { exp = { ["="] = { pid = cat.id } }, order = { name = "ASC" } }
            local children, b = db:find(cond)
            if children and #children > 0 then -- we have the sub childrent  
?>
            <div class="container" id =<?='"toc'..idx..'"'?>>
                <h1><?=cat.name:gsub("^%d+%.","")?></h1>
            <?lua
                for l, j in pairs(b) do
                    local child = children[j]
            ?>
                <div class="sub-container">
                    <h2><?=child.name:gsub("^%d+%.","")?></h2>
                    <?lua
                        local entries, c = sectionByCID(child.id)
                        if entries then
                            for m, k in pairs(c) do
                                local entry = entries[k]
                    ?>
                    <div class= "entry">
                        <p>
                            <?lua if entry.title ~= "" then ?>
                                <span class= "fa  fa-bookmark"></span>
                                <span class= "title"><?=entry.title?></span>
                            <?lua end ?>
                            <span class= "title-optional"></span>
                            <span class="location"><?=entry.location?></span>
                        </p>
                        <div class="entry-short-des">
                            <span><?=entry.subtitle?></span>
                            <span class="date">
                            <?lua
                                if entry["start"]:match("^20%d.*") and entry['end']:match("^20%d.*")  then
                                    echo(entry.start.."-"..entry['end'])
                                end
                            ?>
                            </span>
                        </div>
                        <div class="entry-description">
                                <?=entry.content?>
                        </div>
                    </div>
                    <?lua
                            end
                        end
                    ?>
                </div>
            <?lua
                end
            ?>
            </div>
        <?lua
            else
        ?>
            <div class="container" id =<?='"toc'..idx..'"'?>>
                <h1><?=cat.name:gsub("^%d+%.","")?></h1>
        <?lua
                local entries, c = sectionByCID(cat.id)
                if entries then
                    for m, k in pairs(c) do
                        local entry = entries[k]
        ?>
                    <div class= "entry">
                        <p>
                            <?lua if entry.title ~= "" then ?>
                                <span class= "fa  fa-bookmark"></span>
                                <span class= "title"><?=entry.title?></span>
                            <?lua end ?>
                            <span class= "title-optional"></span>
                            <span class="location"><?=entry.location?></span>
                        </p>
                        <div class="entry-short-des">
                            <span><?=entry.subtitle?></span>
                            <span class="date">
                            <?lua
                                if entry["start"]:match("^20%d.*") and entry['end']:match("^20%d.*") then
                                    echo(entry.start.."-"..entry['end'])
                                end
                            ?>
                            </span>
                        </div>
                        <div class="entry-description">
                                <?=entry.content?>
                        </div>
                    </div>
            <?lua
                    end
                end
            echo ("</div>")
            end
        end
        db:close()
    end
        ?>
            <div class = "container">
                <h1 style="margin:0;"></h1>
                <p style="text-align:right; padding:0; margin:0;color:#878887;">Powered by antd server, (C) 2017-2018 Xuan Sang LE</p>
            </div>
        </div>
        <?lua
        if not HEADER.mobile then
        ?>
        <div class = "cv-toc">
            <ul>
            <?lua
                if data then
                    for k, idx in pairs(a) do
                        local cat = data[idx]
            ?>
                <li><a href=<?='"#toc'..idx..'"'?>><?=cat.name:gsub("^%d+%.","")?></a></li>
            <?lua
                    end
                end
            ?>
            </ul>
        </div>
        <?lua end ?>
    </div>
    <script>
        window.onload = function()
        {
            var els = document.getElementsByClassName("entry-description");
            var converter = new showdown.Converter();
            for(var i in els)
            {
                var text  = els[i].innerHTML;
                var html      = converter.makeHtml(text);
                els[i].innerHTML = html;
            }
        }
    </script>
    </body>
</html>