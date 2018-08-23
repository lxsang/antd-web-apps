IndexController = BaseController:extends{
    class = "IndexController",
    registry = {},
    models = { "sections", "category" }
}

local sectionsByCid = function(db, id)
    local cond = { exp = { ["="] = { cid = id } } , order = { start = "DESC" } }
    local data, a = db:find(cond)
    return data,a
end

function IndexController:index(...)
    local args = {...}
    -- now read all the data
    -- get all root sections as the toc
    local cond = { exp = { ["="] = { pid = 0 } }, order = { name = "ASC" } }
    local data, a = self.category:find(cond)
    local toc = {}
    if not data then
        return self:error("Cannot query the ToC")
    end
    -- find all children category of the toc
    for key,cat in pairs(data) do
        cat.name = cat.name:gsub("^%d+%.","")
        table.insert( toc, {cat.name, cat.id} )
        cond = { exp = { ["="] = { pid = cat.id } }, order = { name = "ASC" } }
        local children, b = self.category:find(cond)
        if children and #children > 0 then
            for k,v in pairs(children) do
                v.sections = sectionsByCid(self.sections,v.id)
            end
            cat.children = children
        else
            cat.sections = sectionsByCid(self.sections,cat.id)
        end
    end
    self.template:set("data", data)
    self.template:set("toc", toc)
    return true
end

function IndexController:notoc(...)
    self.template:setView("index")
    return self:index(table.unpack({...}))
end

