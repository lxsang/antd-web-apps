BaseController:subclass("IndexController")

function IndexController:index(...)
    return true
end

function IndexController:actionnotfound(...)
    self.template:setView("index")
    return self:index(table.unpack({...}))
end