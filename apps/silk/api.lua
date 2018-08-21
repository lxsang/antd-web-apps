require("OOP")
require("sqlite")
require(BASE_FRW.."silk.Router")
require(BASE_FRW.."silk.BaseController")
require(BASE_FRW.."silk.BaseModel")
require(BASE_FRW.."silk.Logger")
require(BASE_FRW.."silk.Template")

function Object:extends(o)
	return self:inherit(o)
end