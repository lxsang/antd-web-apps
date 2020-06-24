<?lua
local gentree
gentree = function(data, controller, cpath)
    if not data then
        return ""
    end
    local caret = ''
    if data.entries then
        caret = '<span class = "caret"></span>'
    end
    local active = ""
    local selected = ""
    local highlight = ""
    if data.tpath and cpath then
        if cpath:match("^"..data.tpath) then
            active = "active"
            highlight = "class = 'highlight'"
        end
        if data.path == cpath then
            selected = "class = 'selected'"
        end
    end
    local markup = '<li '..selected..'>'..caret..'<a '..highlight..' href="'..HTTP_ROOT..'/'..controller..'/'..std.b64encode(data.path):gsub("=","")..'/'..data.name:gsub(" ", "_")..'.md">'..data.name.."</a>"
    if data.entries then
        markup = markup.."<ul class='nested "..active.."'>"
        for k,v in pairs(data.entries) do
            markup = markup..gentree(v, controller, cpath)
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
        return echo("<li>Unable to read TOC</li>")
    end
    for k,v in pairs(data.data.entries) do
        echo(gentree(v, data.controller, data.cpath))
    end
?>
</ul>