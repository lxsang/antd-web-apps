local get = {}
get.fetch = function(user, exp, limit)
    local db = require("db.model").get(user,"blogs",nil)
    if not db then return nil end
    local cond = { exp = exp, order = { ctime = "DESC" }}
    if limit then
        cond.limit = limit
    end
    local data, sort = db:find(cond)
    db:close()
    return data, sort
end
get.top = function(user, limit)
    return get.fetch(user, nil, limit)
end

get.id = function(user, id)
    return get.fetch(user, { ["="] = { id = id } }, nil)
end

get.afterof = function(user, id, limit)
    return get.fetch(user, { [">"] = { id = id } }, limit)
end

get.beforeof = function(user, id, limit)
    return get.fetch(user, { ["<"] = { id = id } }, limit)
end

get.nextof = function(user, id)
    return get.afterof(user, id, 1)
end

get.prevof = function(user, id)
    return get.beforeof(user, id, 1)
end

get.bytag = function(user, b64tag, limit)
    local tag = bytes.__tostring(std.b64decode(b64tag.."=="))
    return get.fetch(user, { ["LIKE"] = { tags = "%%"..tag.."%%" } }, limit)
end

return get

