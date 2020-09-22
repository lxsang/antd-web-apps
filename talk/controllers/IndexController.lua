BaseController:subclass("IndexController", {registry = {}})

function IndexController:index(...)
    result("Quicktalk API")
    return false
end
