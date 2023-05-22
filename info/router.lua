
-- the rewrite rule for the framework
-- should be something like this
-- ^\/apps\/+(.*)$ = /apps/router.lua?r=<1>&<query>
-- some global variables
package.path = _SERVER["LIB_DIR"].."/lua/?.lua"
require("silk.api")
WWW_ROOT = __ROOT__.."/info"
if HEADER.Host then
    HTTP_ROOT= "https://"..HEADER.Host
else
    HTTP_ROOT = "https://info.iohub.dev"
end

DB_LOC="/opt/www/databases"

CONTROLLER_ROOT = "info.controllers"
MODEL_ROOT = "info.models"
-- file path: path/to/file
VIEW_ROOT = WWW_ROOT..DIR_SEP.."views"


-- registry object store global variables
local REGISTRY = {}
-- set logging level
REGISTRY.logger = Logger:new{ level = Logger.INFO}
REGISTRY.users_allowed = { phuong = true, mrsang = true, dany = true }

REGISTRY.user = "mrsang"

REGISTRY.dbfile = DB_LOC.."/"..REGISTRY.user..".db"

REGISTRY.db = DBModel:new{db=REGISTRY.dbfile}
REGISTRY.layout = 'default'
REGISTRY.fileaccess = true

REGISTRY.db:open()
local router = Router:new{registry = REGISTRY}
REGISTRY.router = router
router:setPath(CONTROLLER_ROOT)
--router:route('edit', 'post/edit', "ALL" )

-- example of depedencies to the current main route
-- each layout may have different dependencies
local default_routes_dependencies = {
    user = {
        url = "user/index",
        visibility = "ALL"
    },
    toc = {
        url = "toc/index",
        visibility = {
            shown = true,
            routes = {
                ["index/index"] = true
            }
        }
    }
}
router:route('default', default_routes_dependencies )

BaseController:subclass("NotfoundController",{ registry = {}, models = {} })

function NotfoundController:index(...)
    local args = {...}
    local user = args[1]:gsub("Controller", ""):lower();

    if not REGISTRY.users_allowed[user] then
        self:error("404: Controller "..args[1].." not found : "..args[2])
        return
    end
    LOG_DEBUG("Request: %s", REQUEST.r)
    REQUEST.r = ulib.trim(REQUEST.r:gsub(user, ""), "/")
    if REGISTRY.db then REGISTRY.db:close() end
    REGISTRY.user = user
    REGISTRY.dbfile = DB_LOC.."/"..REGISTRY.user..".db"
    REGISTRY.db = DBModel:new{db=REGISTRY.dbfile}
    REGISTRY.db:open()
    router:delegate()
end
router:delegate()
if REGISTRY.db then REGISTRY.db:close() end

