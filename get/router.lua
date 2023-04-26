
-- the rewrite rule for the framework
-- should be something like this
-- ^\/apps\/+(.*)$ = /apps/router.lua?r=<1>&<query>
-- some global variables
package.path = _SERVER["LIB_DIR"].."/lua/?.lua"
require("silk.api")
WWW_ROOT = __ROOT__.."/get"
if HEADER.Host then
    HTTP_ROOT= "https://"..HEADER.Host
else
    HTTP_ROOT = "https://get.iohub.dev"
end
-- class path: path.to.class
CONTROLLER_ROOT = "get.controllers"
MODEL_ROOT = "get.models"
-- file path: path/to/file
VIEW_ROOT = WWW_ROOT..DIR_SEP.."views"


function NotfoundController:index(...)
    local args = {...}
    local name = args[1] or nil
    if not name then
        return self:error("Unknown script")
    end
    name = name:gsub("Controller",""):lower()
    local path = WWW_ROOT..DIR_SEP.."shs"..DIR_SEP..name..".sh"

    if ulib.exists(path) then
        std.sendFile(path)
    else
        self:error("No script found: "..path)
    end
    return false
end


-- registry object store global variables
local REGISTRY = {}
-- set logging level
REGISTRY.logger = Logger:new{ level = Logger.INFO}
REGISTRY.layout = 'default'
REGISTRY.fileaccess = false

local router = Router:new{registry = REGISTRY}
REGISTRY.router = router
router:setPath(CONTROLLER_ROOT)
--router:route('edit', 'post/edit', "ALL" )

router:route('default', default_routes_dependencies )
router:delegate()

