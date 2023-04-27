BaseController:subclass("IndexController")

function IndexController:index(...)
    -- TODO: add description to router
    local file = io.open(DOC_COVER, "r")
    if file then
        local content = ""
        local md = require("md")
        local callback = function(s) content = content .. s end
        md.to_html(file:read("*a"), callback)
        file:close()
        self.template:set("data", content)
    end
    return true
end

function IndexController:actionnotfound(...)
    self.template:setView("book")
    return self:book(table.unpack({...}))
end

function IndexController:book(...)
    return true
end