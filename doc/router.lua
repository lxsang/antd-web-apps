
-- the rewrite rule for the framework
-- should be something like this
-- ^\/apps\/+(.*)$ = /apps/router.lua?r=<1>&<query>
-- some global variables
package.path = _SERVER["LIB_DIR"].."/lua/?.lua"
require("silk.api")
-- crypto lib
enc = require("enc")
WWW_ROOT = __ROOT__.."/doc"
DIR_SEP = "/"
if HEADER.Host then
    HTTP_ROOT= "https://"..HEADER.Host
else
    HTTP_ROOT = "https://doc.iohub.dev"
end


-- class path: path.to.class
CONTROLLER_ROOT = "doc.controllers"
MODEL_ROOT = "doc.models"
-- file path: path/to/file
VIEW_ROOT = WWW_ROOT..DIR_SEP.."views"

DOC_DIR = "/opt/www/doc"
DOC_COVER = DOC_DIR.."/library.md"

package.path = package.path..";"..__ROOT__.."/os/libs/?.lua"

POLICY.mimes["model/gltf-binary"] = true

if REQUEST.r then
    REQUEST.r = REQUEST.r:gsub("%:", "/")
end

-- registry object store global variables
local REGISTRY = {}
-- set logging level
REGISTRY.logger = Logger:new{ level = Logger.INFO}
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

