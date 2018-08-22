-- create class
BaseController = BaseObject:extends{class="BaseController", registry = {}, models = {}}
-- set the name here in each subclasses
function BaseController:initialize()
    for k, v in pairs(self.models) do
        --- infer the class here
        local modelname = firstToUpper(v).."Model"
        local path = MODEL_ROOT.."."..modelname
        -- require it
        pcall(require, path)
        --require(controller_path)
        if not _G[modelname] then
            self:modelnotfound(v)
        else
            -- create new model object
            self[v] = _G[modelname]:new{registry = self.registry}
        end
    end
    -- create template
    self.template = Template:new{registry = self.registry}
end

function BaseController:redirect(url)
    std.status(301, "Moved Permanently")
    std.custom_header("Content-Type","text/html")
    std.custom_header("Location", url)
    std.header_flush()
end

function BaseController:setLayout(name)
    self.registry.layout = name
end

function BaseController:setSession(key, value)
    SESSION[key] = value
end
function BaseController:getSession(key)
    return SESSION[key]
end
function BaseController:removeSession(key)
    self:setSession(key, nil)
end
function BaseController:index(...)
    self:error("#index: subclasses responsibility")
end

-- not found action
function BaseController:actionnotfound(...)
    local args = {...}
    self:error("#action "..args[1].." is not found in controller "..self.class)
end
-- not found model
function BaseController:modelnotfound(...)
    local args = {...}
    self:error("Model "..firstToUpper(args[1]).."Model is not found in controller "..self.class)
end
-- The not found controller

NotfoundController = BaseController:extends{ registry = {}, models = {} }

function NotfoundController:index(...)
    local args = {...}
    self:error("404: Controller "..args[1].." not found")
    return false
end

-- The asset controller for the static file
AssetController = BaseController:extends{name= "AssetController",registry={}, models={}}
function AssetController:index(...)
    local args = {...}
    return self:get(table.unpack(args))
end

function AssetController:get(...)
    local path = WWW_ROOT..DIR_SEP..implode({...}, DIR_SEP)
    local mime = std.mimeOf(path)

    if self.registry.mimes[mime] then
        std.header(mime)
        if std.isBinary(path) then
            std.f(path)
        else
            std.fb(path)
        end
    end
    return false
end