package.path = _SERVER["LIB_DIR"].."/lua/?.lua"
require("silk.api")

local args = {}
local argv = {}
local fn, e = loadscript(__ROOT__.."/layout.ls", args)
if fn then
    local r,o = pcall(fn, table.unpack(argv))
    if not r then
        std.error(500, o)
    end
else
    std.error(500, e)
end