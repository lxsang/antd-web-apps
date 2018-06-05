local view = {}

view.html = function(name)
    local path = BLOG_ROOT.."/view/"..name..".html"
    if unix.exists(path) then
        std.f(path)
    else
        echo("Cannot find "..path)
    end
end

view.render = function(action, data, sort, min, max)
    local path = BLOG_ROOT.."/view"
    local fn = nil
    local e
    if action == "id" then
        --echo(bytes.__tostring(std.b64decode(data[0].rendered)):gsub("%%","%%%%"))
        --return true
        fn, e = loadscript(path.."/detail.ls")
        --echo(data[0].rendered)
        --fn = require("blog.view.compiledd")
    elseif action == "analyse" then
        fn, e = loadscript(path.."/analyse.ls")
    else
        --fn = require("blog.view.compiledd")

        fn, e = loadscript(path.."/entries.ls")
    end
    if fn then
        local r,o = pcall(fn, data, sort, min, max, action)
        if not r then
            echo(o)
        end
    else
        loadscript(path.."/top.ls")("Welcome to my blog")
        echo(e)
    end
    view.html("bot")
end
return view