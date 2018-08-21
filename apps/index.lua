
-- some global variables
DIR_SEP = ""
WWW_ROOT = ""
HTTP_ROOT = ""
MODEL_ROOT = ""
CONTROLLER_ROOT = ""
VIEW_ROOT = ""
BASE_FRW = "apps."

-- require needed library
require("silk.api")
-- need to define this
-- basically it initialize an session object
session_start()

-- registry object store global variables
local REGISTRY = {}
-- set logging level
REGISTRY.logger = Logger{ levels = {INFO = true, ERROR = true, DEBUG = true}}
REGISTRY.db = nil
REGISTRY.layout = 'default'

local router = Router{registry = REGISTRY}
REGISTRY.router = router
router.setPath(CONTROLLER_ROOT)
router.delegate()
if REGISTRY.db then REGISTRY.db:close() end

