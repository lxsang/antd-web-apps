<html>
    <head>
        <title>Application pages</title>
        <!--link rel="stylesheet" type="text/css" href="<?=HTTP_ROOT?>/asset/get/grs/ubuntu-regular.css" />
        <link rel="stylesheet" type="text/css" href="<?=HTTP_ROOT?>/asset/get/style.css" />
        <link rel="stylesheet" type="text/css" href="<?=HTTP_ROOT?>/asset/get/rst/font-awesome.css" />
        <script type="text/javascript" src="<?=HTTP_ROOT?>/asset/get/rst/gscripts/riot.min.js"> </script>
        <script type="text/javascript" src="<?=HTTP_ROOT?>/asset/get/rst/resources/antos_tags.js"></script>
        <script type="text/javascript" src="<?=HTTP_ROOT?>/asset/get/rst/gscripts/jquery-3.2.1.min.js"> </script>
        <script type="text/javascript" src="<?=HTTP_ROOT?>/asset/get/rst/main.js"></script>
        <script type="text/javascript" src="<?=HTTP_ROOT?>/asset/get/rst/gscripts/showdown.min.js"></script-->
    </head>
    <body>
        <div id="desktop">
            <?lua
                local args = {...}
                local views = args[1]
                for k, v in pairs(views) do
                    echo(k.." -> ")
                    v:render()
                    echo("<br/>")
                end
                --views.__main__:render()
            ?>
        </div>
    </body>
</html>