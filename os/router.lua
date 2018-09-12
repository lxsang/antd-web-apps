
-- the rewrite rule for the framework
-- should be something like this
-- ^\/apps\/+(.*)$ = /apps/router.lua?r=<1>&<query>
-- some global variables
DIR_SEP = "/"
WWW_ROOT = "/opt/www/htdocs/os"
HTTP_ROOT = "https://wos.localhost:9195"
-- class path: path.to.class
BASE_FRW = ""
-- class path: path.to.class
CONTROLLER_ROOT = BASE_FRW.."os.controllers"
MODEL_ROOT = BASE_FRW.."os.models"
-- file path: path/to/file
VIEW_ROOT = WWW_ROOT..DIR_SEP.."views"
LOG_ROOT = WWW_ROOT..DIR_SEP.."logs"

VFS_HOME = "/home/%s"

package.path = package.path..";"..WWW_ROOT .. '/libs/?.lua'
-- require needed library
require(BASE_FRW.."silk.api")
require("common")


-- registry object store global variables
local REGISTRY = {}
-- set logging level
REGISTRY.logger = Logger:new{ levels = {INFO = true, ERROR = true, DEBUG = true}}
REGISTRY.db = DBHelper:new{db="sysdb"}
REGISTRY.layout = 'default'
REGISTRY.fileaccess = true

REGISTRY.db:open()
local router = Router:new{registry = REGISTRY}
REGISTRY.router = router
router:setPath(CONTROLLER_ROOT)

router:delegate()
if REGISTRY.db then REGISTRY.db:close() end

