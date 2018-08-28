BaseController:subclass("MarkOnController", {
    registry = {}
})

function MarkOnController:index( ... )
    self.template:set("jsclass", "MarkOn")
    return true
end

function MarkOnController:actionnotfound(...)
    self.template:setView("index")
    return self:index(table.unpack({...}))
end