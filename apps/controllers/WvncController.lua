BaseController:subclass("WvncController", {
    registry = {}
})

function WvncController:index( ... )
    self.template:set("args", "['WVNC', 'wss://localhost:9192/wvnc']")
    return true
end

function WvncController:actionnotfound(...)
    self.template:setView("index")
    return self:index(table.unpack({...}))
end