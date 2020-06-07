BaseController:subclass(
    "UserController",
    {
        models = {"user"}
    }
)

function UserController:index(...)
    local args = {...}
    local data = self.user:findAll()
    if not data or not data[1] then
        self:error("Cannot fetch user info")
    end
    data[1].user = self.registry.user
    self.template:set("data", data[1])
    return true
end
