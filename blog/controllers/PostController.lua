BaseController:subclass(
    "PostController",
    {
        registry = {},
        models = {"blog", "analytical"}
    }
)

local tools = {}
tools.sum = function(v)
    local sum  = 0.0
    for i=1,#v do sum = sum + v[i] end
    return sum
end

tools.mean = function(v)
    return tools.sum(v)/#v
    
end

tools.argmax = function(v)
    local maxv = 0.0
    local maxi = 0.0
    for i = 1,#v do
        if v[i] >= maxv then
            maxi = i
            maxv = v[i]
        end
    end
    return maxi,maxv
end

tools.cmp = function(a,b)
    return a[2] > b[2]
end

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
    local data, order = self.blog:fetch({["id$gt"] = tonumber(id)}, limit, { "ctime$asc"})
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

function PostController:search(...)
    local index_file = DB_FILE..".index.json"
    local st = require("stmr")
    local indexes, err_code = JSON.decodeFile(index_file)
    local terms = REQUEST.q
    if not err_code then
        -- prepare the vectors
        local docs = {}
        local tid = 1
        local tokens = {}
        local search_vector = {}
        for word in string.gmatch(terms,'%w+') do
            local token = st.stmr(word:lower())
            local index = indexes[token]
            if index then
                for id,v in pairs(index) do
                    if not docs[id] then
                        docs[id] = {}
                    end
                    docs[id][token] = v
                end
                tokens[tid] = token
                tid = tid + 1
            end
        end
        --echo(JSON.encode(docs))
        --echo(JSON.encode(tokens))
        
        -- now create one vector for each documents
        local mean_tfidf = {}
        for id,doc in pairs(docs) do
            local vector = {}
            for i,token in ipairs(tokens) do
                if doc[token] then
                    vector[i] = doc[token]
                else
                    vector[i] = 0
                end
            end
            local data, order = self.blog:find({
                where = {id = tonumber(id)},
                fields = {"id", "title", "utime", "ctime", "content"}
            })
            if data and data[1] then
                data[1].content = data[1].content:sub(1,255)
                table.insert(mean_tfidf, {id, tools.mean(vector), data[1]})
            end
        end
        table.sort(mean_tfidf, tools.cmp)
        self.template:setView("search")
        self.template:set("result", mean_tfidf)
        self.template:set("title", "Search result")
        return true
    else
        LOG_ERROR("Unable to parse file %s", index_file)
        return self:notfound("Internal search error")
    end
end

function PostController:beforeof(id, limit)
    limit = limit or POST_LIMIT
    local data, order = self.blog:fetch({["id$lt"] = tonumber(id)}, limit)
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
    local tag = tostring(enc.b64decode(b64tag .. "=="))
    local cond = {["tags$like"] = "%%"..tag.."%%"}
    local order = nil
    limit = limit or POST_LIMIT
    if action == "before" then
        cond["id$lt"] = tonumber(id)
    elseif action == "after" then
        cond["id$gt"] = tonumber(id)
        order = {"ctime$asc"}
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

function PostController:json(id)
    local obj = {
        error = false,
        result = false
    }
    local data, order = self.blog:fetch({id = tonumber(id)})
    if not data or #order == 0 then
        obj.error = "No data found"
    else
        data = data[1]
        obj.result = {
            id = data.id,
            title = data.title,
            description = nil,
            tags = data.tags,
            ctime = data.ctimestr,
            utime = data.utimestr
        }

        local c, d = data.content:find("%-%-%-%-%-")
        if c then
            obj.description = data.content:sub(0, c - 1)
        else
            obj.description = data.content
        end
        -- convert description to html
        local content = ""
        local md = require("md")
        local callback = function(s) content = content .. s end
        md.to_html(obj.description, callback)
        obj.result.description = content
    end
    std.json()
    std.t(JSON.encode(obj));
    return false;
end

function PostController:id(pid)
    local data, order = self.blog:fetch({id = tonumber(pid)})
    if not data or #order == 0 then
        return self:notfound("No post found")
    end
    data = data[1]
    data.rendered = data.rendered:gsub("%%", "%%%%")
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
    self.template:set("url", string.format(HTTP_ROOT .. "/post/id/%d",pid))
    -- self.template:set("url", string.format("https://blog.lxsang.me/post/id/%d",pid))
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

function PostController:graph_json(...)
    local nodes = self.blog:find({ where = {publish = 1}, fields = {"id", "title"}})
    local output = { error = false, result = false }
    local lut = {}
    std.json()
    if not nodes then
        output.error = "No nodes found"
    else
        output.result = {
            nodes = {},
            links = {}
        }
        for k,v in ipairs(nodes) do
            local title = v.title
            output.result.nodes[k] = { id = tonumber(v.id), title = title }
        end
        -- get statistic links
        local links = self.analytical:find({fields = {"pid", "sid", "score"}})
        if links then
            local i = 1
            for k,v in ipairs(links) do
                local link = { source = tonumber(v.pid), target = tonumber(v.sid), score = tonumber(v.score)}
                local key = ""
                if link.source < link.target then
                    key = v.pid..v.sid
                else
                    key = v.sid..v.pid
                end
                key = enc.sha1(key)
                if not lut[key] then
                    output.result.links[i] = link
                    i = i + 1
                    lut[key] = true
                end
            end
        end
    end
    std.t(JSON.encode(output))
    return false
end
function PostController:graph(...)
    self.template:set("title", "Posts connection graph")
    self.template:set("d3", true)
    return true
end
