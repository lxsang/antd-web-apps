<?lua
local args = {...}
local jsclass = __main__:get("jsclass")
if jsclass == nil then jsclass = "" end
?>
<html>
    <head>
        <title>Application pages</title>
        <link rel="stylesheet" type="text/css" href="<?=HTTP_ROOT?>/rst/ubuntu-regular.css" />
        <link rel="stylesheet" type="text/css" href="<?=HTTP_ROOT?>/assets/css/style.css" />
        <link rel="stylesheet" type="text/css" href="<?=HTTP_ROOT?>/rst/font-awesome.css" />
        <!--script type="text/javascript" src="<?=HTTP_ROOT?>/rst/gscripts/riot.min.js"> </script>
        <script type="text/javascript" src="<?=HTTP_ROOT?>/rst/resources/antos_tags.js"></script-->
        <script type="text/javascript" src="<?=HTTP_ROOT?>/rst/gscripts/jquery-3.2.1.min.js"> </script>
        <script type="text/javascript" src="<?=HTTP_ROOT?>/assets/scripts/main.js"></script>
        <!--script type="text/javascript" src="<?=HTTP_ROOT?>/rst/gscripts/showdown.min.js"></script-->
        <script>
            $(window).on('load', function(){
                window.myuri = '<?=HTTP_ROOT?>';
                var manager = new window.classes.APIManager();
                manager.init('<?=jsclass?>');
            });
        </script>
    </head>
    <body>
        <div id="desktop">
            <?lua
                
                __main__:render()
            ?>
        </div>
    </body>
</html>