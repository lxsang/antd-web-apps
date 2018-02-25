<?lua
    local arg = {...}
    local datas = arg[1]
    local order = arg[2]
    local class = "card"
    if HEADER.mobile then
        class = "card mobile"
    end
    loadscript(BLOG_ROOT.."/view/top.ls")("Welcome to my blog")
    if #order == 0 then
?>
    <div class = "notfound">
       <p>No entry found</p>
       <blockquote>
        “In many ways my life has been rather like a record of the lost and found. Perhaps all lives are like that.”
<span>― Lucy Foley, The Book of Lost and Found</span> 
       </blockquote >
    </div>
<?lua
        return
    end

    for idx,v in pairs(order) do
        local data = datas[v]
?>
<div class = "<?=class?>">
    <div class = "side">
        <span class = "date"><?=data.ctimestr:gsub("%s+.*$","")?></span>
        <span class = "tags">
        <?lua
            local atags = {}
            local i = 1
            for tag in data.tags:gmatch(",*([^,]+)") do
                tag = std.trim(tag, " ")
                if tag ~= "" then
                    local b64tag = std.b64encode(tag)
                    atags[i] = '<a href = "./r:bytag:'..b64tag:gsub("=","")..':'..MAX_ENTRY..'">'..tag.."</a>"
                    i = i+ 1
                end
            end
            echo(table.concat(atags, ", "))
        ?>
        </span>
        <div class="fb-like" data-href="https://blog.lxsang.me/r:id:<?=data.id?>" data-layout="button_count" data-action="like" data-size="small" data-show-faces="true" data-share="true"></div>
        <div class="g-plusone" data-size="medium"></div>
        <a class="twitter-share-button" href="https://twitter.com/intent/tweet">
Tweet</a>
    </div>
    <div class = "blogentry">
        <div class = "shortcontent">
            <?lua
                local content = bytes.__tostring(std.b64decode(data.rendered)):gsub("%%","%%%%")
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
                    echo("<a class = 'title_link' href='./r:id:"..data.id.."'>"..title.."</a>")
                    echo(content:sub(c))
                else
                    echo(content)
                end
            ?>
        </div>
        <div class = "detail">
                <span></span>
                <?='<a href="./r:id:'..data.id..'" ></a>'?>
                <span></span>
        </div>
    </div>
</div>
<?lua
    end
?>
