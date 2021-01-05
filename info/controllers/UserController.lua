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


function UserController:photo(...)
    local data = self.user:findAll()
    if not data or not data[1] then
        self:error("Cannot fetch user info")
    end
    if(not data[1] or data[1].photo == "") then
        self:error("User photo is not available")
    end
    local prefix = data[1].photo:match("%a+://")
    local suffix = data[1].photo:gsub(prefix,"")
    local path = string.format("/home/%s/", self.registry.user)..suffix
    print(path)
    if ulib.exists(path) then
        local mime = std.mimeOf(path)
        std.sendFile(path)
    else
        self:error("Asset file not found or access forbidden: "..path)
    end
    return false
end