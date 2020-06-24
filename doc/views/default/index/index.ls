
<?lua
    local get_next
    get_next = function(toc, cpath)
        if toc.path == cpath then
            if toc.entries and #toc.entries > 0 then return toc.entries[1] end
            if toc.parent and toc.parent.entries and #toc.parent.entries > 0 then
                local entries = toc.parent.entries
                if toc.id == #entries then
                    local p = toc.parent
                    while p and p.parent and p.parent.entries and #p.parent.entries > 0 do
                        entries = p.parent.entries
                        if p.id ~= #entries then
                            return entries[p.id + 1]
                        end
                        p = p.parent
                    end
                    return nil
                else
                    return entries[toc.id + 1]
                end
            else
                return nil
            end
        else
            if toc.entries then
                for i,v in pairs(toc.entries) do
                    local ret = get_next(v, cpath)
                    if ret then return ret end
                end
                return nil
            else
                return nil
            end
        end
    end

    local get_prev
    get_prev = function(toc, cpath)
        if toc.path == cpath then
            if toc.id == 1 then
                return toc.parent
            end
            if toc.parent and toc.parent.entries and #toc.parent.entries > 0 then
                local entries = toc.parent.entries
                local c = entries[toc.id - 1]
                while c and c.entries and #c.entries > 0 do
                    if c.entries then
                        c = c.entries[#c.entries]
                    end
                end
                return c
            else
                return nil
            end
        else
            if toc.entries then
                for i,v in pairs(toc.entries) do
                    local ret = get_prev(v, cpath)
                    if ret then return ret end
                end
                return nil
            else
                return nil
            end
        end
    end
    local prev_entry = nil
    local next_entry = nil
    if toc then
        prev_entry = get_prev(toc.data, toc.cpath)
        next_entry = get_next(toc.data, toc.cpath)
    end
?>
<div class = "pagenav">
    <?lua
        
        if prev_entry then
            echo("<a class = 'go_prev' href="..HTTP_ROOT..'/'..toc.controller..'/'..std.b64encode(prev_entry.path):gsub("=","")..'/'..prev_entry.name:gsub(" ", "_")..".md".." >")
            echo(prev_entry.name)
            echo("</a>")
        end
        if next_entry then
            echo("<a class = 'go_next' href="..HTTP_ROOT..'/'..toc.controller..'/'..std.b64encode(next_entry.path):gsub("=","")..'/'..next_entry.name:gsub(" ", "_")..".md".." >")
            echo(next_entry.name)
            echo("</a>")
        end
    ?>
</div>
<div class = "md-content" id = "renderer">
    
</div>
<div class = "pagenav">
    <?lua
        if prev_entry then
            echo("<a class = 'go_prev' href="..HTTP_ROOT..'/'..toc.controller..'/'..std.b64encode(prev_entry.path):gsub("=","")..'/'..prev_entry.name:gsub(" ", "_")..".md".." >")
            echo(prev_entry.name)
            echo("</a>")
        end
        if next_entry then
            echo("<a class = 'go_next' href="..HTTP_ROOT..'/'..toc.controller..'/'..std.b64encode(next_entry.path):gsub("=","")..'/'..next_entry.name:gsub(" ", "_")..".md".." >")
            echo(next_entry.name)
            echo("</a>")
        end
    ?>
</div>
<script>
    window.addEventListener('load', (event) => {
        var markdown = `<?=std.b64encode(data)?>`;
        var converter = new showdown.Converter();
        var html = converter.makeHtml(atob(markdown));
        document.getElementById("renderer").innerHTML = html;
        // highlight and math display
        renderMathInElement(document.getElementById("renderer"));
        document.querySelectorAll("pre code").forEach(element => {
            hljs.highlightBlock(element);
            hljs.lineNumbersBlock(element);
        });
    });
</script>