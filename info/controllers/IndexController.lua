IndexController = BaseController:extends{
    class = "IndexController",
    registry = {},
    models = { "sections", "user", "category" }
}

function IndexController:index(...)
    local args = {...}
    return true
end
