<?lua
local tocdata = __main__:get("toc")
local elinks = __main__:get("elinks")
?>
<!DOCTYPE html>
<html>
    <head>
        <link
            rel="stylesheet"
            type="text/css"
            href="<?=HTTP_ROOT?>/rst/hljs/github.css" />
        <link
            rel="stylesheet"
            type="text/css"
            href="<?=HTTP_ROOT?>/rst/katex/katex.min.css" />
        <!--script
            type="text/javascript"
            src="<?=HTTP_ROOT?>/rst/gscripts/showdown.min.js"
        ></script-->
        <script
            src="<?=HTTP_ROOT?>/rst/hljs/highlight.pack.js"
        ></script>
        <script
            src="<?=HTTP_ROOT?>/rst/hljs/highlightjs-line-numbers.min.js"
        ></script>
        <script>hljs.initHighlightingOnLoad();</script>
        <script
            src="<?=HTTP_ROOT?>/rst/katex/katex.min.js"
        ></script>
        <script
            src="<?=HTTP_ROOT?>/rst/katex/auto-render.min.js"
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
                <?lua
                    if elinks then
                        for k,v in ipairs(elinks) do
                ?>
                            <a class = "x-link" target="_blank" href ="<?=v.url?>">
                                <?=v.name?>
                            </a>
                <?lua
                        end
                    end 
                ?>
                <form id = "search_form" action="<?=HTTP_ROOT..'/'..tocdata.controller..'/search/'?>" method="get" class="search-form">
                    <input id = "search_box" name="q" type = "text" class = "search-box"></input>
                </form>
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
            window.addEventListener('load', (event) => {
                // tree view events
                var toggler = document.getElementsByClassName("caret");
                var i;
                for (i = 0; i < toggler.length; i++) {
                    toggler[i].addEventListener("click", function() {
                        this.parentElement.querySelector(".nested").classList.toggle("active");
                        this.classList.toggle("caret-down");
                    });
                }
                var input = document.getElementById("search_box");
                var form = document.getElementById("search_form");
                form.onsubmit = function()
                {
                    var val = input.value.trim();
                    console.log(val);
                    if( val === "" || val == "\n") return false;
                    return true;
                }
            });
        </script>
    </body>
</html>
