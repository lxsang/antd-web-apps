BLOG_ROOT = __ROOT__.."/blog"
MAX_ENTRY = 10
local user = "mrsang"
local handle = function(p)
    std.html()
    local args = {}
    local sort = {}
    local i = 1
    for s in p:gmatch("%:*([^%:]*)") do
        args[i] = s
        table.insert(sort, i)
        i = i+1
    end
    table.sort(sort)
    local api = require("blog.api")
    if #args == 0 or api == nil then
        echo("Unknow request "..p)
    elseif not api[args[1]] then
        echo("Unknow action.."..args[1])
    else
        local action = args[1]
        args[1] = user
        local data, sort = api[action](table.unpack(args))
        if data == nil then
            echo("Cannot query data")
        else
            require("blog.view").render(action, data, sort)
        end
    end
end
return handle