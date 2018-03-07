local get = {}
get.fetch = function(user, cnd, limit, order)
    local db = require("db.model").get(user,"blogs",nil)
    if not db then return nil end
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

get.minid = function(user)
    local db = require("db.model").get(user,"blogs",nil)
    local cond = { fields = { "MIN(id)" } }
    local data = db:find(cond)
    db:close()
    return data[1]["MIN(id)"]
end

get.maxid = function(user)
    local db = require("db.model").get(user,"blogs",nil)
    local cond = { fields = { "MAX(id)" }}
    local data = db:find(cond)
    db:close()
    return data[1]["MAX(id)"]
end

get.afterof = function(user, id, limit)
    local data, sort =  get.fetch(user, { [">"] = { id = id } }, limit, { ctime = "ASC" })
    table.sort(sort, function(a, b) return a > b end)
    return data, sort
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

get.bytag = function(user, b64tag, limit, action, id)
    LAST_QUERY = b64tag
    local tag = bytes.__tostring(std.b64decode(b64tag.."=="))
    local cond = { ["LIKE"] = { tags = "%%"..tag.."%%" } }
    local order = nil
    if action == "before" then
        cond = { ["and"] = { cond, { ["<"] = {id = id} } } }
    elseif action == "after" then
        cond = { ["and"] = { cond, { [">"] = {id = id} } } }
        order = { ctime = "ASC" }
    end
    local data, sort =  get.fetch(user, cond, limit, order)
    if(action == "after") then
        table.sort(sort, function(a, b) return a > b end)
    end
    return data, sort
end

return get

