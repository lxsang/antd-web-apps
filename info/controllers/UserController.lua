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
    self.template:set("data", data[1])
    return true
end
