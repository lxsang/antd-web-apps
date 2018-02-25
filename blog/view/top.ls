<?lua
    local arg = {...}
    local title = arg[1]
    local cls = ""
    if HEADER.mobile then
        cls = "navmobile"
    end
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title><?=title?></title>
        <meta property="og:url"           content="https://blog.lxsang.me" />
        <meta property="og:type"          content="website" />
        <meta property="og:title"         content="Xuan Sang LE's blog" />
        <meta property="og:description"   content="My personal space" />
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" type="text/css" href="rst/ubuntu-regular.css" />
        <link rel="stylesheet" type="text/css" href="rst/font-awesome.css" />
        <link rel="stylesheet" type="text/css" href="rst/hljs/github.css" />
        <link rel="stylesheet" type="text/css" href="assets/style.css" />
        <script src="rst/gscripts/jquery-3.2.1.min.js"> </script>
        <script src="rst/hljs/highlight.pack.js"> </script>
        <script src="rst/hljs/highlightjs-line-numbers.min.js"> </script>
        <script>
            $(document).ready(function() {
                $('pre code').each(function(i, block) {
                  hljs.highlightBlock(block);
                  hljs.lineNumbersBlock(block);
                });
              });
            window.twttr = (function(d, s, id) {
                var js, fjs = d.getElementsByTagName(s)[0],
                    t = window.twttr || {};
                if (d.getElementById(id)) return t;
                js = d.createElement(s);
                js.id = id;
                js.src = "https://platform.twitter.com/widgets.js";
                fjs.parentNode.insertBefore(js, fjs);

                t._e = [];
                t.ready = function(f) {
                    t._e.push(f);
                };

                return t;
            }(document, "script", "twitter-wjs"));

            // facebook
            (function(d, s, id) {
                var js, fjs = d.getElementsByTagName(s)[0];
                if (d.getElementById(id)) return;
                js = d.createElement(s); js.id = id;
                js.src = 'https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.12';
                fjs.parentNode.insertBefore(js, fjs);
            }(document, 'script', 'facebook-jssdk'));

            (function() {
            var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
            po.src = 'https://apis.google.com/js/plusone.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
            })();
        </script>
    </head>
    <body>
        <div id="fb-root"></div>

        <div id = "top">
            <div id = "navbar" class = "<?=cls?>">
                <div class = "logo"><a href = "https://lxsang.me"></a></div>
                <ul>
                        <li><i class = "fa fa-home"></i><a href="./">Home</a></li>
                        <li ><i class = "fa fa-address-card"></i><a href="https://info.lxsang.me" >Porfolio</a></li>
                        <li><i class = "fa fa-paper-plane"></i><a href="#" onclick="" >Contact</a></li>
                        <?lua
                        if not HEADER.mobile then
                        ?>
                        <li > <i class = "fa fa-globe"></i><a href = "https://os.lxsang.me" target="_blank">AntOS</a></li>
                        <?lua end ?>
                </ul>
                <?lua
                if not HEADER.mobile then
                ?>
                <input type = "text" class = "search-box"></input>
                <div class= "search-icon"></div>
                <?lua
                end
                ?>
            </div>
        </div>
        <div id = "center">
            <div id = "container">
             