local view = {}

view.html = function(name)
    local path = BLOG_ROOT.."/view/"..name..".html"
    local f = io.open(path, "rb")
    if f then
        echo(f:read("*all"))
        f:close()
    else
        echo("Cannot find "..path)
    end
end

view.render = function(action, data, sort)
    view.html("top")
    local path = BLOG_ROOT.."/view"
    local fn = nil
    local e
    if action == "id" then
        fn, e = loadscript(path.."/detail.ls")
    else
        fn, e = loadscript(path.."/entries.ls")
    end
    if fn then
        fn(data, sort)
    else
        echo(e)
    end
    view.html("bot")
end
return view