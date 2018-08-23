-- create class
Template = BaseObject:extends{class="Template",registry = {}}

function Template:initialize()
    self.vars = {}
end

function Template:set(k, v, ow)
    if not self.vars[k] or (self.vars[k] and ow) then
        self.vars[k] = v
    end
end

function Template:get(k)
    return self.vars[k]
end

function Template:remove(k)
    self.vars[k] = nil
end

-- infer view path
function Template:setView(name, controller)
    self.name = name
    if controller then
        self.controller = controller
    end
end
function Template:path()
    local path = VIEW_ROOT..DIR_SEP..self.registry.layout..DIR_SEP..self.controller..DIR_SEP..self.name..".ls"
    if ulib.exists(path) then
        return path
    else
        self:error("View not found: "..path)
    end
end
-- render the page
function Template:render()
    local fn, e = loadscript(self:path())
    if fn then
        local r,o = pcall(fn, self.vars)
        if not r then
            self:error(o)
        end
    else
        self:error(e)
    end
end