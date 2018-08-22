PostController = BaseController:extends{
    class = "PostController",
    registry = {},
    models = { "post" }
}

function PostController:index(...)
    local args = {...}
    self.template:set("index", args[1])
    self.template:set("dummy", "This is a dummy string")
    self:setSession("postsession", "Huehuehue")
    return true
end

function PostController:edit(...)
    if self:getSession("postsession") then
        self.template:set("auth", true)
    else
        self.template:set("auth", false)
    end
    --self:redirect("/category/put/1")
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