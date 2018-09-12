
-- the rewrite rule for the framework
-- should be something like this
-- ^\/apps\/+(.*)$ = /apps/router.lua?r=<1>&<query>
-- some global variables
DIR_SEP = "/"
WWW_ROOT = "/opt/www/htdocs/info"
HTTP_ROOT = "https://info.localhost:9195/"
-- class path: path.to.class
BASE_FRW = ""
-- class path: path.to.class
CONTROLLER_ROOT = BASE_FRW.."info.controllers"
MODEL_ROOT = BASE_FRW.."info.models"
-- file path: path/to/file
VIEW_ROOT = WWW_ROOT..DIR_SEP.."views"
LOG_ROOT = WWW_ROOT..DIR_SEP.."logs"

-- require needed library
require(BASE_FRW.."silk.api")

-- registry object store global variables
local REGISTRY = {}
-- set logging level
REGISTRY.logger = Logger:new{ levels = {INFO = true, ERROR = true, DEBUG = true}}
REGISTRY.db = DBHelper:new{db="mrsang"}
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
router:delegate()
if REGISTRY.db then REGISTRY.db:close() end

