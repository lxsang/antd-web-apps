-- This is the base model class
require("OOP")
-- create class
Template = Object:extends{registry = {}}

function Template:initialize()
    self.vars = {}
end

function Template:set(k, v, ow)
end

function Template:remove(k)
end

-- infer view path
function setView(name, controller)
end
-- render the page
function render()
end