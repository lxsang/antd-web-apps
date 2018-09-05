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
                tag = std.trim(tag, " ")
                if tag ~= "" then
                    local b64tag = std.b64encode(tag)
                    atags[i] = '<a href = "'..HTTP_ROOT..'/post/bytag/'..b64tag:gsub("=","")..'/'..POST_LIMIT..'">'..tag.."</a>"
                    i = i+ 1
                end
            end
            echo(table.concat(atags, ", "))
        ?>
        </span>
        <div class="fb-like" data-href="<?=url?>" data-layout="button_count" data-action="like" data-size="small" data-show-faces="true" data-share="true"></div>
        <!--div class="g-plusone" data-action="share" data-size="medium" data-href="<?=url?>"></div-->
        <a class="twitter-share-button" href='https://twitter.com/intent/tweet?url=<?=url?>&text=<?=data.title?>'></a>
    </div>
    <div class = "blogentry">
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
                echo("<li><a href='./r:id:"..v.st.sid.."'>"..v.post.title.."</a> (<b>Score</b>: "..string.format("%2.2f",v.st.score)..")</li>")
            end
            echo("</ul>")
        end?>
        <h1 class = "commentsec"></h1>
        <div id="disqus_thread"></div>
        <script>

            /**
            *  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
            *  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables*/
            
            var disqus_config = function () {
                this.page.url = "<?=url?>";  // Replace PAGE_URL with your page's canonical URL variable
                this.page.identifier = "<?=std.md5(url)?>"; // Replace PAGE_IDENTIFIER with your 
            };
        
            (function() { // DON'T EDIT BELOW THIS LINE
            var d = document, s = d.createElement('script');
            s.src = 'https://https-blog-lxsang-me.disqus.com/embed.js';
            s.setAttribute('data-timestamp', +new Date());
            (d.head || d.body).appendChild(s);
            })();
        </script>
        <noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>

        <!--div class = "commentform">
            <div  class = "inputbox">
                <div class = "label">Name:</div>
                <input data-class = "data" type = "text" name = "name" />
            </div>
            
            <div  class = "inputbox">
                <div  class = "label">Email:</div>
                <input data-class = "data" type = "text" name = "email" />
            </div>
            
            <textarea data-class = "data"  name = "content"></textarea>
            <div class = "inputboxbt">
                <div data-id="status"></div>
                <button data-id = "send" >Comment</button>
            </div>
        </div-->
    </div>
</div>
