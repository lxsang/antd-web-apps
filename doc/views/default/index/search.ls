<div class = "md-content">
<?lua
    if data then
        for file,arr in pairs(data) do
            local f = io.open(file, "r")
            io.input(f)
            local title = io.read()
            io.close()
            file = file:gsub(map.local_path, map.vfs_path)
            title = ulib.trim(ulib.trim(title, "#"), " ")
            echo("<div>")
            echo("<p class= 'result-header'><a href='"..HTTP_ROOT..'/'..controller..'/'..enc.b64encode(file):gsub("=","")..'/'..title:gsub(" ", "_")..".md'>")
            echo(title)
            echo("</a></p>")
            for i,content in ipairs(arr) do
                echo("<p class= 'result-content'>")
                echo("..."..content.."...")
                echo("</p>")
            end
            echo("</div>")
        end
    else
        echo("<p>No search result found</p>")
    end
?>
</div>