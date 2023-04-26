-- the rewrite rule for the framework
-- should be something like this
-- ^\/apps\/+(.*)$ = /apps/router.lua?r=<1>&<query>
-- some global variables
package.path = _SERVER["LIB_DIR"].."/lua/?.lua"
require("silk.api")
-- crypto lib
enc = require("enc")
WWW_ROOT = __ROOT__.."/talk"
-- TODO change me
DB_FILE = "/home/dany/databases/quicktalk.db"
function fail(msg)
    std.json()
    std.t(JSON.encode({error = msg}))
end

function result(obj)
    std.json()
    std.t(JSON.encode({result = obj, error = false}))
end
DIR_SEP = "/"
if HEADER.Host then
    HTTP_ROOT = "https://" .. HEADER.Host
else
    HTTP_ROOT = "https://talk.iohub.dev"
end

-- TODO remove me
HTTP_ROOT = HTTP_ROOT.."/next/talk"

-- class path: path.to.class
CONTROLLER_ROOT = "talk.controllers"
MODEL_ROOT = "talk.models"
-- file path: path/to/file
VIEW_ROOT = WWW_ROOT..DIR_SEP.."views"


-- registry object store global variables
local REGISTRY = {}
-- set logging level
REGISTRY.logger = Logger:new{ level = Logger.INFO}

REGISTRY.layout = 'default'
REGISTRY.fileaccess = true
REGISTRY.db = DBModel:new{db = DB_FILE}
REGISTRY.db:open()

local router = Router:new{registry = REGISTRY}
REGISTRY.router = router
router:setPath(CONTROLLER_ROOT)
-- router:route('edit', 'post/edit', "ALL" )

std.header("Access-Control-Allow-Origin", "*")
std.header("Access-Control-Allow-Methods", "POST")
std.header("Access-Control-Allow-Headers", "content-type")

-- router:route('default', nil)
router:delegate()
if REGISTRY.db then REGISTRY.db:close() end
