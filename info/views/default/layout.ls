<?lua
    local args = {...}
    local views = args[1]
?>

<html>
    <head>
        <script type="text/javascript" src="<?=HTTP_ROOT?>/asset/get/rst/gscripts/showdown.min.js"></script>
        <link rel="stylesheet" type="text/css" href="<?=HTTP_ROOT?>/asset/get/style.css" />
        <link rel="stylesheet" type="text/css" href="<?=HTTP_ROOT?>/asset/get/rst/font-awesome.css" />
        <title>Porfolio</title>
    </head>
    <body>
    <div class="layout">
        <div class = "cv-content">
            <?lua
            if views.user then
                views.user:render()
            end
            if views.__main__ then
                views.__main__:render()
            end
            ?>
            <div class = "container">
                <h1 style="margin:0;"></h1>
                <p style="text-align:right; padding:0; margin:0;color:#878887;">Powered by antd server, (C) 2017-2018 Xuan Sang LE</p>
            </div>
        </div>
        <?lua
            if views.toc then
                views.toc:set("data", views.__main__:get("toc"))
                views.toc:render()
            end
        ?>
    </div>

     <script>
        window.onload = function()
        {
            var els = document.getElementsByClassName("entry-description");
            var converter = new showdown.Converter();
            for(var i in els)
            {
                var text  = els[i].innerHTML;
                var html  = converter.makeHtml(text);
                els[i].innerHTML = html;
            }
        }
    </script>
    </body>
</html>