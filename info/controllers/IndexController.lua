BaseController:subclass(
    "IndexController",
    {
        registry = {},
        models = {"sections", "category"}
    }
)

local sectionsByCid = function(db, id)
    local data, a = db:find({
        where = {
            cid = id,
            publish = 1
        },
        order = {"start$desc"}
    })
    return data, a
end

function IndexController:index(...)
    local args = {...}
    -- now read all the data
    -- get all root sections as the toc
    local data, a = self.category:find({
        where = {
            pid = 0
        },
        order = {"name$asc"}
    })
    local toc = {}
    if not data then
        return self:error("Cannot query the ToC")
    end
    -- find all children category of the toc
    for key, cat in pairs(data) do
        cat.name = cat.name:gsub("^%d+%.", "")
        table.insert(toc, {cat.name, cat.id})
        local children, b = self.category:find({
            where = {
                pid = cat.id
            },
            order = {"name$asc"}
        })
        if children and #children > 0 then
            for k, v in pairs(children) do
                v.sections = sectionsByCid(self.sections, v.id)
            end
            cat.children = children
        else
            cat.sections = sectionsByCid(self.sections, cat.id)
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

function IndexController:actionnotfound(...)
    return self:notoc(table.unpack({...}))
end

function IndexController:pdf(...)
    local tmp_file = WWW_ROOT.."/cv_exported.pdf"
    local cmd = "wkhtmltopdf "..HTTP_ROOT.."/"..self.registry.user.."/index/notoc "..tmp_file
    print(cmd)
    local r = os.execute(cmd)
    if r then
        std.sendFile(tmp_file)
        return false
    else
        return self:error("Sorry.Problem generate PDF file")
    end
end