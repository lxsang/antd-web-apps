-- the rewrite rule for the framework
-- should be something like this
-- ^\/apps\/+(.*)$ = /apps/router.lua?r=<1>&<query>
-- some global variables
package.path = _SERVER["LIB_DIR"].."/lua/?.lua"
require("silk.api")
-- crypto lib
enc = require("enc")
WWW_ROOT = __ROOT__.."/blog"
DB_LOC="/opt/www/databases"
DB_FILE = DB_LOC.."/mrsang.db"
-- add aditional paths
package.path = package.path..";"..WWW_ROOT .. '/?.lua'

DIR_SEP = "/"
if HEADER.Host then
    HTTP_ROOT= "https://"..HEADER.Host
else
    HTTP_ROOT = "https://blog.iohub.dev"
end

CONTROLLER_ROOT = "blog.controllers"
MODEL_ROOT = "blog.models"
-- file path: path/to/file
VIEW_ROOT = WWW_ROOT..DIR_SEP.."views"
POST_LIMIT = 3

if REQUEST.r then
    REQUEST.r = REQUEST.r:gsub("%:", "/")
end

-- registry object store global variables
local REGISTRY = {}
-- set logging level
REGISTRY.logger = Logger:new{ level = Logger.INFO}
REGISTRY.db = DBModel:new{db=DB_FILE}
REGISTRY.layout = 'default'
REGISTRY.fileaccess = true

REGISTRY.db:open()
local router = Router:new{registry = REGISTRY}
REGISTRY.router = router
router:setPath(CONTROLLER_ROOT)
--router:route('edit', 'post/edit', "ALL" )

-- example of depedencies to the current main route
-- each layout may have different dependencies
--[[ local default_routes_dependencies = {
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
router:route('default', default_routes_dependencies )]]
router:remap("index", "post")
router:remap("r", "post")
router:delegate()
if REGISTRY.db then REGISTRY.db:close() end

