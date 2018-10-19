
-- the rewrite rule for the framework
-- should be something like this
-- ^\/apps\/+(.*)$ = /apps/router.lua?r=<1>&<query>
-- some global variables
DIR_SEP = "/"
WWW_ROOT = __ROOT__.."/get"
if HEADER.Host then
    HTTP_ROOT= "https://"..HEADER.Host
else
    HTTP_ROOT = "https://get.makeand.run"
end
-- class path: path.to.class
BASE_FRW = ""
-- class path: path.to.class
CONTROLLER_ROOT = BASE_FRW.."apps.controllers"
MODEL_ROOT = BASE_FRW.."apps.models"
-- file path: path/to/file
VIEW_ROOT = WWW_ROOT..DIR_SEP.."views"
LOG_ROOT = WWW_ROOT..DIR_SEP.."logs"

-- require needed library
require(BASE_FRW.."silk.api")

function NotfoundController:index(...)
    local args = {...}
    local name = args[1] or nil
    if not name then
        return self:error("Unknown script")
    end
    name = name:gsub("Controller",""):lower()
    local path = WWW_ROOT..DIR_SEP.."shs"..DIR_SEP..name..".sh"

    if ulib.exists(path) then
        std.header("text/plain")
        std.f(path)
    else
        self:error("No script found: "..path)
    end
    return false
end


-- registry object store global variables
local REGISTRY = {}
-- set logging level
REGISTRY.logger = Logger:new{ levels = {INFO = false, ERROR = false, DEBUG = false}}

REGISTRY.layout = 'default'
REGISTRY.fileaccess = false

local router = Router:new{registry = REGISTRY}
REGISTRY.router = router
router:setPath(CONTROLLER_ROOT)
--router:route('edit', 'post/edit', "ALL" )

router:route('default', default_routes_dependencies )
router:delegate()

