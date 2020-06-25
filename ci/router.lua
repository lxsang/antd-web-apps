
-- the rewrite rule for the framework
-- should be something like this
-- ^\/apps\/+(.*)$ = /apps/router.lua?r=<1>&<query>
-- some global variables
function fail(msg)
	std.json()
	std.t(JSON.encode({error=msg}))
end

function result(obj)
	std.json()
	std.t(JSON.encode({result=obj, error=false}))
end
DIR_SEP = "/"
WWW_ROOT = __ROOT__.."/ci"
if HEADER.Host then
    HTTP_ROOT= "https://"..HEADER.Host
else
    HTTP_ROOT = "https://ci.iohub.dev"
end
-- class path: path.to.class
BASE_FRW = ""
-- class path: path.to.class
CONTROLLER_ROOT = BASE_FRW.."ci.controllers"
MODEL_ROOT = BASE_FRW.."ci.models"
-- file path: path/to/file
VIEW_ROOT = WWW_ROOT..DIR_SEP.."views"
LOG_ROOT = WWW_ROOT..DIR_SEP.."logs"

-- require needed library
require(BASE_FRW.."silk.api")

function NotfoundController:index(...)
    local args = {...}
    if #args == 0 then
        fail("Unknown action")
        return false
    end
    local action = args[1]
    if action == "BuildController" then
        if REQUEST.json then
            local request = JSON.decodeString(REQUEST.json)
            if request.ref and request.ref == "refs/heads/ci" then
                local branch = "ci"
                local repository = request.repository.name
                local path = WWW_ROOT..DIR_SEP.."scripts"..DIR_SEP..repository..".sh"

                if ulib.exists(path) then
                    local cmd = "/bin/bash "..path.." "..branch
                    print(cmd)
                    local handle = io.popen(cmd)
                    local f = io.open(WWW_ROOT..DIR_SEP.."log"..DIR_SEP..repository.."_"..branch..".txt", "w")
                    for line in handle:lines() do
                        f:write(line)
                    end
                    handle:close()
                    f:close()
                    result("Build done, log file: https://ci.iohub.dev/log/"..repository.."_"..branch..".txt")
                    
                else
                    fail("No build script found")
                end
            else
                result("This action is ignored by the CI")
            end
        else
            fail("Unknow action parameters")
        end
    else
        fail("Action not supported: "..action)
    end
end


-- registry object store global variables
local REGISTRY = {}
-- set logging level
REGISTRY.logger = Logger:new{ levels = {INFO = false, ERROR = false, DEBUG = false}}

REGISTRY.layout = 'default'
REGISTRY.fileaccess = true

local router = Router:new{registry = REGISTRY}
REGISTRY.router = router
router:setPath(CONTROLLER_ROOT)
--router:route('edit', 'post/edit', "ALL" )

router:route('default', default_routes_dependencies )
router:delegate()

