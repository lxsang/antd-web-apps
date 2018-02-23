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
    if action == "id" then
        _G.dbmodel = data[0]
        doscript(path.."/detail.ls")
    else
        _G.dbmodel = { data = data, order = sort }
        doscript(path.."/entries.ls")
    end
    _G.dbmodel = nil
    view.html("bot")
end
return view