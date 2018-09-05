BaseModel:subclass("BlogModel",{
    registry = {},
    name = "blogs",
    fields = {
        tags =	"TEXT",
        content =	"TEXT",
        utime =	"NUMERIC",
        rendered =	"TEXT",
        title =	"TEXT",
        utimestr =	"TEXT",
        ctime =	"NUMERIC",
        ctimestr =	"TEXT",
        publish =	"INTEGER DEFAULT 0"
    }
})

function BlogModel:fetch(cnd, limit, order)
    local exp = {}
    exp[1] = {["="] = { publish = 1 }}
    if cnd then   
        exp[2] = cnd
    else

    end

    local cond = { 
        exp = {["and"] = exp }, 
        order = { ctime = "DESC" },
        fields = {
            "id", "title", "utime", "ctime", "utimestr", "ctimestr", "rendered", "tags"
        }    
    }
    if limit then
        cond.limit = limit
    end
    if order then
        cond.order = order
    end
    return self:find(cond)
end

function BlogModel:minid()
    local cond = { fields = { "MIN(id)" } }
    local data = self:find(cond)
    return data[1]["MIN(id)"]
end

function BlogModel:maxid()
    local cond = { fields = { "MAX(id)" } }
    local data = self:find(cond)
    return data[1]["MAX(id)"]
end