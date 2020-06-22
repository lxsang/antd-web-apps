<?lua
gentree = function(data, controller)
    if not data then
        return ""
    end
    local caret = ''
    if data.entries then
        caret = '<span class = "caret"></span>'
    end
    local markup = '<li>'..caret..'<a href="'..HTTP_ROOT..'/'..controller..'/'..std.b64encode(data.path):gsub("=","")..'/'..data.name:gsub(" ", "_")..'.md">'..data.name.."</a>"
    if data.entries then
        markup = markup.."<ul class='nested'>"
        for k,v in pairs(data.entries) do
            markup = markup..gentree(v, controller)
        end
        markup = markup.."</ul>"
    end
    markup = markup.."</li>"
    return markup
end
?>
<ul id = "toc">
<?lua
    if data.error then
        return echo("Unable to read toc")
    end
    for k,v in pairs(data.data.entries) do
        echo(gentree(v, data.controller))
    end
?>
</ul>