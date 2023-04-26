<?lua
    local data = post
    local class = "card"
    if HEADER.mobile then
        class = "card mobile"
    end
    local content = data.rendered
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
            local old_url = HTTP_ROOT.."/r:id:"..data.id
        ?>
        </span>
        <!--div class="fb-like" data-href="<?=old_url?>" data-layout="button_count" data-action="like" data-size="small" data-show-faces="true" data-share="true"></div-->
        <!--div class="g-plusone" data-action="share" data-size="medium" data-href="<?=url?>"></div-->
        <a class="twitter-share-button" href='https://twitter.com/intent/tweet?url=<?=url?>&text=<?=data.title?>'></a>
    </div>
    <div class = "blogentry markdown-body">
        <div class = "shortcontent">
            <?lua
                local r, s = content:find("<hr/?>")
                if r then
                    echo(content:sub(0,r-1))
                    echo(content:sub(s+1))
                else
                    echo(content)
                end
            ?>
        </div>
        <?lua
        if similar_posts then
        ?>
        <h1 class = "commentsec">Related posts</h1>
        <?lua
            echo("<ul>")
            for k,v in pairs(similar_posts) do
                echo("<li><a href='./"..v.st.sid.."'>"..v.post.title.."</a> (<b>Score</b>: "..string.format("%2.2f",v.st.score)..")</li>")
            end
            echo("</ul>")
        end?>
        <h1 class = "commentsec">Comments</h1>
        <div>
        The comment editor supports <b>Markdown</b> syntax. Your email is necessary to notify you of further updates on the discussion. It will be hidden from the public.
        </div>
        <div id="quick_talk_comment_thread"></div>
    </div>
</div>
