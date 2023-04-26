<?lua if not HEADER.mobile then ?>
<iframe width="980" height="410" src="https://mars.nasa.gov/layout/embed/send-your-name/future/certificate/?cn=792789419260" frameborder="0"></iframe>
<?lua end ?>
<?lua
    local datas = posts
    local class = "card"
    local first_id = nil
    local last_id = nil
    if HEADER.mobile then
        class = "card mobile"
    end
    
    for idx,v in pairs(order) do
        local data = datas[v]
        if not last_id then last_id = data.id end
        first_id = data.id
?>
<div class = "<?=class?>">
    <div class = "side">
        <span class = "date"><?=data.ctimestr:gsub("%s+.*$","")?></span>
        <span class = "tags">
        <?lua
            local atags = {}
            local i = 1
            for tag in data.tags:gmatch(",*([^,]+)") do
                tag = ulib.trim(tag, " ")
                if tag ~= "" then
                    local b64tag = enc.b64encode(tag)
                    atags[i] = '<a href = "'..HTTP_ROOT..'/post/bytag/'..b64tag:gsub("=","")..'/'..POST_LIMIT..'">'..tag.."</a>"
                    i = i+ 1
                end
            end
            echo(table.concat(atags, ", "))
            local url = HTTP_ROOT.."/post/id/"..string.format("%d",data.id)
            local old_url = HTTP_ROOT.."/r:id:"..string.format("%d",data.id)
        ?>
        </span>
        <!--div class="fb-like" data-href="<?=old_url?>" data-layout="button_count" data-action="like" data-size="small" data-show-faces="true" data-share="true"></div-->
        <!--div class="g-plusone" data-action="share" data-size="medium" data-href="<?=url?>"></div-->
        <a class="twitter-share-button" href='https://twitter.com/intent/tweet?url=<?=url?>&text=<?=data.title?>'></a>
    </div>
    <div class = "blogentry markdown-body">
        <div class = "shortcontent">
            <?lua
                local content = data.rendered:gsub("%%","%%%%")
                local r, s = content:find("(<hr/?>)")
                local title = nil
                if r then 
                    content = content:sub(0,r-1)
                end
                local a,b = content:find("<[Hh]1[^>]*>")
                local c,d 
                if a then
                    c,d = content:find("</[Hh]1>")
                    if c then
                        title = content:sub(b+1, c-1)
                    end
                end
                if title then
                    echo(content:sub(0, b))
                    echo("<a class = 'title_link' href='"..url.."'>"..title.."</a>")
                    echo(content:sub(c))
                else
                    echo(content)
                end
            ?>
        </div>
        <div class = "detail">
                <span></span>
                <?='<a href="'..url..'" ></a>'?>
                <span></span>
        </div>
    </div>
</div>
<?lua
    end
    local beforelk = HTTP_ROOT.."/post/beforeof/"..string.format("%d",first_id).."/"..POST_LIMIT
    local afterlk = HTTP_ROOT.."/post/afterof/"..string.format("%d",last_id).."/"..POST_LIMIT
    if action == "bytag" or action == "search" then
        beforelk = HTTP_ROOT.."/post/"..action.."/"..query.."/"..POST_LIMIT.."/before/"..string.format("%d",first_id)
        afterlk = HTTP_ROOT.."/post/"..action.."/"..query.."/"..POST_LIMIT.."/after/"..string.format("%d",last_id)
    end
?>
<div class = "time-travel">
<?lua
    if first_id ~= minid then
?>
<a href = "<?=beforelk?>" class = "past"><< Older posts</a>
<?lua
    end
    if last_id ~= maxid then
?>
<a href = "<?=afterlk?>" class = "future">Newer posts >></a>
<?lua end ?>
</div>