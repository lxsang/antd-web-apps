BaseController:subclass("PostController", {
    registry = {},
    models = { "post" }
})

function PostController:index(...)
    local args = {...}
    self:setSession("postsession", "Huehuehue")
    self.template:set("post", self.post:findAll())
    return true
end

function PostController:edit(...)
    if self:getSession("postsession") then
        self.template:set("auth", true)
    else
        self.template:set("auth", false)
    end
    self:switchLayout("admin")
    return true
end

function PostController:add(...)
    local args = {...}
    local m = {
        cid = tonumber(args[1]),
        content = "This is the content for #cid="..args[1]
    }
    if(self.post:create(m)) then
        self.template:set("status", "Post created")
    else
        self.template:set("status", "Cannot create post")
    end
    return true
end