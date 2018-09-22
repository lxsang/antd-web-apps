BaseController:subclass("WebVNCController", {
    registry = {}
})

function WebVNCController:index( ... )
    self.template:set("args", "['WebVNC']")
    return true
end

function WebVNCController:actionnotfound(...)
    self.template:setView("index")
    return self:index(table.unpack({...}))
end