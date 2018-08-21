-- create class
BaseController = Object:extends{registry = {}, models = {}}
-- set the name here in each subclasses
function BaseController:initialize()
    -- create model object here
    --- infer the class here
end

function BaseController:redirect()
end

function BaseController:checkSession(key)
end
function BaseController:setSession(key)
end
function BaseController:getSession(key)
end
function BaseController:removeSession(key)
end
function BaseController:index()
    error("#index: subclasses responsibility")
end