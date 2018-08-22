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

function Template:remove(k)
    self.vars[k] = nil
end

-- infer view path
function Template:setView(name, controller)
    self.path = VIEW_ROOT..DIR_SEP..self.registry.layout..DIR_SEP..controller..DIR_SEP..name..".ls"
    if ulib.exists(self.path) then
    else
        self:error("View not found: "..self.path)
    end
end
-- render the page
function Template:render()
    local fn, e = loadscript(self.path)
    if fn then
        local r,o = pcall(fn, self.vars)
        if not r then
            self:error(o)
        end
    else
        self:error(e)
    end
end