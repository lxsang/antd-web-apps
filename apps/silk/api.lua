require("OOP")
require("sqlite")
require("silk.Router")
require("silk.BaseController")
require("silk.BaseModel")
require("silk.Logger")
require("silk.Template")

function Object:extends(o)
	return self:inherit(o)
end