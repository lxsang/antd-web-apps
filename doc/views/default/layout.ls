<?lua
local tocdata = __main__:get("toc")
?>
<!DOCTYPE html>
<html>
    <head>
        <script
            type="text/javascript"
            src="<?=HTTP_ROOT?>/rst/gscripts/showdown.min.js"
        ></script>
        <link
            rel="stylesheet"
            type="text/css"
            href="<?=HTTP_ROOT?>/assets/style.css" />
        <link
            rel="stylesheet"
            type="text/css"
            href="<?=HTTP_ROOT?>/rst/font-awesome.css" />
        <link
            rel="stylesheet"
            type="text/css"
            href="<?=HTTP_ROOT?>/rst/ubuntu-regular.css" />
        <title>
            <?lua
                if tocdata then
                    echo(tocdata.data.name)
                else
                    echo("Untitled")
                end
            ?>
        </title>
    </head>
    <body>
        <div id = "top">
            <div id = "navbar">
                <div class = "doc-name">
                    <?lua if tocdata then ?>
                        <a href ="<?=HTTP_ROOT..'/'..tocdata.controller..'/'?>">
                            <?=tocdata.data.name?>
                        </a>
                    <?lua end ?>
                </div>
                <input type = "text" class = "search-box"></input>
                <div class= "search-icon"></div>
            </div>
        </div>
        <div id = "cover">
            <div id = "book">
                <div  class = "doc-toc">
                    <?lua
                        if toc then
                            toc:set("data", tocdata)
                            toc:render()
                        end
                    ?>
                </div>
        
                <div class="doc-content">
                    <?lua
                        if __main__ then
                            __main__:render()
                        end
                    ?>
                </div>
            </div>
        </div>
        
        <div id = "bottom">
            Powered by antd server, (c) 2019 - <?=os.date("*t").year?> Xuan Sang LE
        </div>
        <script>
            window.onload = function () {
                var els = document.getElementsByClassName("doc-content");
                var converter = new showdown.Converter();
                for (var i in els) {
                    var text = els[i].innerHTML;
                    var html = converter.makeHtml(text);
                    els[i].innerHTML = html;
                }
                // tree view events
                var toggler = document.getElementsByClassName("caret");
                var i;
                for (i = 0; i < toggler.length; i++) {
                    toggler[i].addEventListener("click", function() {
                        this.parentElement.querySelector(".nested").classList.toggle("active");
                        this.classList.toggle("caret-down");
                    });
                }
                // TODO math display
            };
        </script>
    </body>
</html>
