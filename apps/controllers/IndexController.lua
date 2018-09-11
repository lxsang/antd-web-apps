BaseController:subclass("IndexController", {
    registry = {}
})

function IndexController:index( ... )
    return true
end

function IndexController:actionnotfound(...)
    self.template:setView("index")
    return self:index(table.unpack({...}))
end

function IndexController:json(...)
    std.json()
    echo( JSON.encode(REQUEST))
    return false
end

function IndexController:get(...)
    return true
end

function IndexController:form(...)
    return true
end

function IndexController:upload(...)
    return true
end