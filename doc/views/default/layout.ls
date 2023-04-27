<?lua
local tocdata = __main__:get("toc")
local elinks = __main__:get("elinks")
local has_3d = __main__:get("has_3d")
local url = __main__:get("url")
local show_toc_css = ''
if REQUEST.show_toc and REQUEST.show_toc == "false" then
    show_toc_css = 'style="display:none;"'
end
local book_width_css='style="max-width:80%;"'
if HEADER.mobile then
    book_width_css='style="max-width:95%;"'
end
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link
            rel="stylesheet"
            type="text/css"
            href="<?=HTTP_ROOT?>/rst/hljs/github.css" />
        <link
            rel="stylesheet"
            type="text/css"
            href="<?=HTTP_ROOT?>/rst/katex/katex.min.css" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"> </script>
        <?lua
            if has_3d then
        ?>
        <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
        <script nomodule src="https://unpkg.com/@google/model-viewer/dist/model-viewer-legacy.js"></script>
        <?lua
            end
        ?>
        <script
            src="<?=HTTP_ROOT?>/rst/hljs/highlight.pack.js"
        ></script>
        <script
            src="<?=HTTP_ROOT?>/rst/hljs/highlightjs-line-numbers.min.js"
        ></script>

        <?lua
            if url then
        ?>
        <link rel="stylesheet" type="text/css" href="https://chat.iohub.dev/assets/quicktalk.css" />
        <script src="https://chat.iohub.dev/assets/quicktalk.js"> </script>
        <?lua
            else
        ?>
        <script>hljs.initHighlightingOnLoad();</script>
        <?lua
            end
        ?>
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
            href="<?=HTTP_ROOT?>/assets/github-markdown.css" />
        <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" />
        <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Ubuntu:regular,bold&subset=Latin" />
        <title>
            <?lua
                if tocdata then
                    echo(tocdata.data.name)
                else
                    echo("Documentation Hub")
                end
            ?>
        </title>
    </head>
    <body>
        <div id = "top">
            <div id = "navbar" <?=book_width_css?>>
                <?lua
                    if tocdata then
                ?>
                <div class = "doc-toc-menu">
                    <?lua if tocdata then ?>
                        <a href ="#" id="btn_toc">
                            <?=tocdata.data.name?>
                        </a>
                    <?lua end ?>
                </div>
                <form id = "search_form" action="<?=HTTP_ROOT..'/'..tocdata.controller..'/search/'?>" method="get" class="search-form">
                    <input id = "search_box" name="q" type = "text" class = "search-box"></input>
                    <input  name="show_toc" type = "hidden" value="false"></input>
                </form>
                <div class= "search-icon"></div>
                <?lua
                    end
                ?>
            </div>
        </div>
        <div id = "cover">
            <div id = "book" <?=book_width_css?>>
                <?lua if tocdata then ?>
                    <div id="doc_toc" class = "doc-toc" <?=show_toc_css?> >
                        <div class = "doc-name doc-toc-header">
                            <a href ="<?=HTTP_ROOT..'/'..tocdata.controller..'/'?>">
                                <?=tocdata.data.name?>
                            </a>
                        </div>
                        <?lua
                            if elinks then
                                for k,v in ipairs(elinks) do
                        ?>
                                    <div class = "doc-toc-header">
                                        <a class = "x-link" target="_blank" href ="<?=v.url?>">
                                            <?=v.name?>
                                        </a>
                                    </div>
                        <?lua
                                end
                            end
                        ?>
                        <div class = "doc-toc-header doc-toc-legend">Table of content</div>
                        <?lua
                            if toc then
                                toc:set("data", tocdata)
                                toc:render()
                            end
                        ?>
                    </div>
                    <div class="doc-content markdown-body" id="doc_content">
                        <?lua
                            if __main__ then
                                __main__:render()
                            end
                        ?>
                    </div>
                <?lua
                else
                ?>
                <div class="markdown-body">
                <?lua
                    if __main__ then
                        __main__:render()
                    end
                 ?>
                </div>
                <?lua end ?>
            </div>
        </div>
        
        <div id = "bottom">
            Powered by antd server, (c) 2019 - <?=os.date("*t").year?> Xuan Sang LE
        </div>
        <script>
            const toc_class_toggle = () => {
                if(!$("#doc_toc").is(":hidden"))
                {
                    $("#btn_toc").attr("class", "toc-active");
                }
                else
                {
                    $("#btn_toc").removeClass("toc-active");
                }
            };
            window.addEventListener('load', (event) => {
                $("#btn_toc").click(function(){
                    $("#doc_toc").toggle();
                    toc_class_toggle();
                });
                $("#doc_content").click(function(){
                    $("#doc_toc").hide();
                    toc_class_toggle();
                });
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
                if(form)
                {
                    form.onsubmit = function()
                    {
                        var val = input.value.trim();
                        console.log(val);
                        if( val === "" || val == "\n") return false;
                        return true;
                    }
                }
        <?lua
            if url then
        ?>
                var options = {
                    target: "quick_talk_comment_thread",
                    api_uri: "https://chat.iohub.dev/comment",
                    uri: "<?=url?>",
                    page: 'cover',
                    author: {
                        first: "mrsang",
                        last: "iohub.dev"
                    },
                    onload: function(){
                        renderMathInElement($("#book")[0]);
                        $('pre code').each(function(i, block) {
                            hljs.highlightBlock(block);
                            hljs.lineNumbersBlock(block);
                        });
                    }
                };
                new QuickTalk(options);
        <?lua
            end
        ?>
            });
        toc_class_toggle();
        </script>
    </body>
</html>
