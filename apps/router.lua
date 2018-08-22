
-- the rewrite rule for the framework
-- should be something like this
-- ^\/apps\/+(.*)$ = /apps/router.lua?r=<1>&<query>
-- some global variables
DIR_SEP = "/"
WWW_ROOT = "/opt/www/htdocs/apps"
HTTP_ROOT = "https://apps.localhost:9195/"
BASE_FRW = "apps."
LOG_ROOT = WWW_ROOT..DIR_SEP.."logs"
CONTROLLER_ROOT = BASE_FRW.."controllers"
MODEL_ROOT = BASE_FRW.."models"
VIEW_ROOT = WWW_ROOT..DIR_SEP.."views"


-- require needed library
require(BASE_FRW.."silk.api")
-- need to define this
-- basically it initialize an session object
-- session_start()

-- registry object store global variables
local REGISTRY = {}
-- set logging level
REGISTRY.logger = Logger:new{ levels = {INFO = true, ERROR = true, DEBUG = true}}
REGISTRY.db = DBHelper:new{db="iosapps"}
REGISTRY.layout = 'default'

-- mime type allows
-- this will bypass the default server security
-- the default list is from the server setting
REGISTRY.mimes = {
    ["application/javascript"]            = true,
    ["image/bmp"]                         = true,
    ["image/jpeg"]                        = true,
    ["text/css"]                          = true,
    ["text/markdown"]                     = true,
    ["text/csv"]                          = true,
    ["application/pdf"]                   = true,
    ["image/gif"]                         = true,
    ["text/html"]                         = true,
    ["application/json"]                  = true,
    ["application/javascript"]            = true,
    ["image/x-portable-pixmap"]           = true,
    ["application/x-rar-compressed"]      = true,
    ["image/tiff"]                        = true,
    ["application/x-tar"]                 = true,
    ["text/plain"]                        = true,
    ["application/x-font-ttf"]            = true,
    ["application/xhtml+xml"]             = true,
    ["application/xml"]                   = true,
    ["application/zip"]                   = true,
    ["image/svg+xml"]                     = true,
    ["application/vnd.ms-fontobject"]     = true,
    ["application/x-font-woff"]           = true,
    ["application/x-font-otf"]            = true,
    ["audio/mpeg"]                        = true,

}

REGISTRY.db:open()
local router = Router:new{registry = REGISTRY}
REGISTRY.router = router
router:setPath(CONTROLLER_ROOT)
--router:route('edit', 'post/edit', "ALL" )
router:route('edit', 'post/edit', {
    shown = true,
    routes = {
        ["post/index"] = true
    }
} )
router:delegate()
if REGISTRY.db then REGISTRY.db:close() end

