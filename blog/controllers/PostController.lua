BaseController:subclass(
    "PostController",
    {
        registry = {},
        models = {"blog", "analytical"}
    }
)

function PostController:index(...)
    return self:top(table.unpack({...}))
end

function PostController:top(limit)
    limit = limit or POST_LIMIT
    local data, order = self.blog:fetch(nil, limit)
    if not data or #order == 0 then
        return self:notfound("No entry found")
    end
    self:list(data, order)
    return true
end

function PostController:afterof(id, limit)
    limit = limit or POST_LIMIT
    local data, order = self.blog:fetch({[">"] = {id = id}}, limit, {ctime = "ASC"})
    if not data or #order == 0 then
        return self:notfound("No entry found")
    end
    table.sort(
        order,
        function(a, b)
            return a > b
        end
    )
    self:list(data, order)
    return true
end

function PostController:beforeof(id, limit)
    limit = limit or POST_LIMIT
    local data, order = self.blog:fetch({["<"] = {id = id}}, limit)
    if not data or #order == 0 then
        return self:notfound("No entry found")
    end
    self:list(data, order)
    return true
end

-- this is a private function, should not be called by user
function PostController:list(data, order)
    self.template:setView("posts")
    self.template:set("posts", data)
    self.template:set("order", order)
    self.template:set("title", "Blog Home")
    self.template:set("minid", self.blog:minid())
    self.template:set("maxid", self.blog:maxid())
    return false
end

function PostController:bytag(b64tag, limit, action, id)
    local tag = bytes.__tostring(std.b64decode(b64tag .. "=="))
    local cond = {["LIKE"] = {tags = "%%" .. tag .. "%%"}}
    local order = nil
    limit = limit or POST_LIMIT
    if action == "before" then
        cond = {["and"] = {cond, {["<"] = {id = id}}}}
    elseif action == "after" then
        cond = {["and"] = {cond, {[">"] = {id = id}}}}
        order = {ctime = "ASC"}
    end
    local data, sort = self.blog:fetch(cond, limit, order)
    if not data or #sort == 0 then
        return self:notfound("No entry found")
    end

    if (action == "after") then
        table.sort(
            sort,
            function(a, b)
                return a > b
            end
        )
    end

    self.template:set("query", b64tag)
    self.template:set("action", "bytag")
    self:list(data, sort)
    return true
end

function PostController:id(pid)
    local data, order = self.blog:fetch({["="] = {id = pid}})
    if not data or #order == 0 then
        return self:notfound("No post found")
    end
    data = data[1]
    data.rendered = bytes.__tostring(std.b64decode(data.rendered)):gsub("%%", "%%%%")
    local a, b = data.rendered:find("<[Hh]1[^>]*>")
    if a then
        local c, d = data.rendered:find("</[Hh]1>")
        if c then
            self.template:set("title", data.rendered:sub(b + 1, c - 1))
        end
    end
    -- get similarity post
    local st_records = self.analytical:similarof(data.id)
    local similar_posts = {}
    for k, v in pairs(st_records) do
        similar_posts[k] = {st = v, post = self.blog:get(v.sid)}
    end
    self.template:set("post", data)
    self.template:set("similar_posts", similar_posts)
    self.template:set("render", true)
    self.template:set("tags", data.tags)
    self.template:set("url", HTTP_ROOT .. "/post/id/" .. pid)
    self.template:setView("detail")
    return true
end

function PostController:notfound(...)
    local args = {...}
    self.template:set("title", "404 not found")
    self.template:set("error", args[1])
    self.template:setView("notfound")
    return true
end

function PostController:actionnotfound(...)
    local args = {...}
    return self:notfound("Action [" .. args[1] .. "] not found")
end

function PostController:analyse(n)
    if not n then
        n = 5
    end
    local path = "/home/mrsang/aiws/blog-clustering"
    local gettext = loadfile(path .. "/gettext.lua")()
    local cluster = loadfile(path .. "/cluster.lua")()
    local data = gettext.get({publish = 1})
    local documents = {}
    if data then
        local sw = gettext.stopwords(path .. "/stopwords.txt")
        for k, v in pairs(data) do
            local bag = cluster.bow(data[k].content, sw)
            documents[data[k].id] = bag
        end
        cluster.tfidf(documents)
        --local v = cluster.search("arm", documents)
        --echo(JSON.encode(v))
        local vectors, maxv, size = cluster.get_vectors(documents)
        -- purge the table
        self.analytical:delete({["="] = {["1"] = 1}})
        -- get similarity and put to the table
        for id, v in pairs(vectors) do
            local top = cluster.top_similarity(id, vectors, n)
            for a, b in pairs(top) do
                local record = {pid = id, sid = a, score = b}
                self.analytical:create(record)
            end
        end
        self.template:set("message", "Analyse complete")
    else
        self.template:set("message", "Cannot analyse")
    end
    self.template:set("title", "TFIDF-analyse")
    return true
end
