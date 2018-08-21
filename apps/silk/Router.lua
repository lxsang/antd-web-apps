
--define the class
Router = Object:extends{registry = {}}
function Router:setPath(path)
    self.path = path
end

function Router:initialize()
    self.args = {}
    self.routes = {}
end

function Router:setArgs(args)
    self.args = args
end

function Router:arg(name)
    return self.args[name]
end

function Router:getController(url)
    -- TODO
end

function Router:delegate()
    -- TODO
end


function Router:setInitRoute(name, url, visibility)
    self.routes[name] = {
        url = url,
        visibility = visibility
    }
end