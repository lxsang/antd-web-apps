
-- the rewrite rule for the framework
-- should be something like this
-- ^\/apps\/+(.*)$ = /apps/router.lua?r=<1>&<query>
-- some global variables
DIR_SEP = "/"
WWW_ROOT = __ROOT__.."/doc"
if HEADER.Host then
    HTTP_ROOT= "https://"..HEADER.Host
else
    HTTP_ROOT = "https://doc.iohub.dev"
end
-- class path: path.to.class
BASE_FRW = ""
-- class path: path.to.class
CONTROLLER_ROOT = BASE_FRW.."doc.controllers"
MODEL_ROOT = BASE_FRW.."doc.models"
-- file path: path/to/file
VIEW_ROOT = WWW_ROOT..DIR_SEP.."views"
LOG_ROOT = WWW_ROOT..DIR_SEP.."logs"
POST_LIMIT = 10
-- require needed library
require(BASE_FRW.."silk.api")

if REQUEST.r then
    REQUEST.r = REQUEST.r:gsub("%:", "/")
end

-- registry object store global variables
local REGISTRY = {}
-- set logging level
REGISTRY.logger = Logger:new{ levels = {INFO = false, ERROR = true, DEBUG = false}}
REGISTRY.layout = 'default'
REGISTRY.fileaccess = true

local router = Router:new{registry = REGISTRY}
REGISTRY.router = router
router:setPath(CONTROLLER_ROOT)
--router:route('edit', 'post/edit', "ALL" )

-- example of depedencies to the current main route
-- each layout may have different dependencies
local default_routes_dependencies = {
    toc = {
        url = "toc/index",
        visibility = "ALL"
    }
} 
router:route('default', default_routes_dependencies )
--router:remap("r", "post")
router:delegate()

