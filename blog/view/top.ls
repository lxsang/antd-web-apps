<?lua
    local arg = {...}
    local title = arg[1]
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title><?=title?></title>
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
        </script>
    </head>
    <body>
        <div id = "top">
            <div id = "navbar">
                <div class = "logo"><a href = "https://lxsang.me"></a></div>
                <ul>
                        <li><i class = "fa fa-home"></i><a href="./">Home</a></li>
                        <li ><i class = "fa fa-address-card"></i><a href="https://info.lxsang.me" >Porfolio</a></li>
                        <li><i class = "fa fa-paper-plane"></i><a href="#" onclick="" >Contact</a></li>
                        <li > <i class = "fa fa-globe"></i><a href = "https://os.lxsang.me" target="_blank">AntOS</a></li>
                </ul>
                <input type = "text" class = "search-box"></input>
                <div class= "search-icon"></div>
            </div>
        </div>
        <div id = "center">
            <div id = "container">
             