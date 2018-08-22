require("OOP")
ulib = require("ulib")
require(BASE_FRW.."silk.BaseObject")
require(BASE_FRW.."silk.DBHelper")
require(BASE_FRW.."silk.Router")
require(BASE_FRW.."silk.BaseController")
require(BASE_FRW.."silk.BaseModel")
require(BASE_FRW.."silk.Logger")
require(BASE_FRW.."silk.Template")

HEADER_FLAG = false

function html()
	if not HEADER_FLAG then
		std.chtml(SESSION)
		HEADER_FLAG = true
	end
end