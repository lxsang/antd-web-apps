<?lua
    local arg = {...}
    local data = arg[1]
    local order = arg[2]
    local content = nil;
    local topview = loadscript(BLOG_ROOT.."/view/top.ls")
    local class = "card"
    if HEADER.mobile then
        class = "card mobile"
    end
    local title = "Welcome to my blog"
    if not #data or #order == 0 then
        topview(title, false)
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
    else
        data = data[1]
        content = bytes.__tostring(std.b64decode(data.rendered)):gsub("%%","%%%%")
        local a,b = content:find("<[Hh]1[^>]*>")
        if a then
            local c,d = content:find("</[Hh]1>")
            if c then
                title = content:sub(b+1, c-1)
            end
        end
        topview(title, true)
    end
    local url = "https://blog.lxsang.me/r:id:"..data.id
    -- fetch the similar posts from database
    local db = require("db.model").get(BLOG_ADMIN,"st_similarity", nil)
    local similar_posts = nil
    if db then
        local records = db:find({ exp = {["="] = {pid = data.id}}, order = {score = "DESC"}})
        --echo("records size is #"..#records)
        local pdb = require("db.model").get(BLOG_ADMIN,"blogs", nil)
        if(pdb) then
            similar_posts = {}
            for k,v in pairs(records) do
                similar_posts[k] = { st = v, post = pdb:get(v.sid) }
            end
            pdb:close()
        end
        db:close()
    end
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
