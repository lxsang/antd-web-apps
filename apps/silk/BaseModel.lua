-- This is the base model class
require("OOP")
require("sqlite")
-- create class
BaseModel = Object:extends{registry = {}, name = ""}

function BaseModel:initialize()
end

function BaseModel:create()
end

function BaseModel:update()
end

function BaseModel:delete()
end


function BaseModel:findAll(cond)
end