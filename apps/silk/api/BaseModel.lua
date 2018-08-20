-- This is the base model class
require("OOP")
require("sqlite")
-- create class
BaseModel = Object:inherit{db=nil, name=''}

function BaseModel:do()
end