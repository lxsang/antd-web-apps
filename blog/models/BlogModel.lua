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
    local filter = {
        order = { "ctime$desc" },
        fields = {
            "id", "title", "utime", "ctime", "utimestr", "content", "ctimestr", "rendered", "tags"
        }
    }

    if limit then
        filter.limit = limit
    end
    if order then
        filter.order = order
    end

    filter.where = {}
    if cnd then
        filter.where = cnd
    end
    filter.where.publish = 1

    return self:find(filter)
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