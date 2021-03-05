<?lua
local shareid = __main__:get("shareid")
local ext = __main__:get("ext")
local doctype = __main__:get("doctype")
local name = __main__:get("name")
local key = __main__:get("key")
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <link
            rel="stylesheet"
            type="text/css"
            href="<?=HTTP_ROOT?>/assets/office.css" />
        <!--meta name="viewport" content="width=device-width, initial-scale=1"-->
        <script src="https://office.iohub.dev/web-apps/apps/api/documents/api.js"> </script>
        <title>
            <?lua
                echo(name)
            ?>
        </title>
        <script type="text/javascript">
            <?lua
                if shareid and ext and doctype ~= "none" then
            ?>
            window.onload = () => {
                const editor = new DocsAPI.DocEditor("container", {
                    events: {
                        onAppReady: (e) => () => {},
                        //onRequestCreateNew: () => @newDocument(),
                        //onRequestSaveAs: (e) => @saveAs(e)
                    },
                    document: {
                        fileType: '<?=ext?>',
                        key: '<?=key?>',
                        title: '<?=name?>',
                        url: "https://doc.iohub.dev/office/shared/<?=shareid?>"
                    },
                    documentType: '<?=doctype?>',
                    editorConfig: {
                        //user: {
                        //    id: @systemsetting.user.id.toString(),
                        //    name: @systemsetting.user.username
                        //},
                        customization: {
                            compactHeader: false,
                        },
                        callbackUrl:"https://doc.iohub.dev/office/save/<?=shareid?>"
                    }
                });
            };
            <?lua
                end
            ?>
        </script>
    </head>
    <body>
        <div id = "container">
            <?lua
                if not shareid or not ext or doctype == "none" then
                    echo("<h1> Invalid document </h1>")
                end
            ?>
        </div>
    </body>
</html>