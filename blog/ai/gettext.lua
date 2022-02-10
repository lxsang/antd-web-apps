local gettext = {}
require("sqlite")
gettext.get = function(q)
    local db = require("os.libs.dbmodel").get("mrsang","blogs",nil)
    if not db then return nil end
    local exp = {["="] =q}
     local cond = { 
        exp = exp, 
        fields = {"id", "content"}
    }
    local data, sort = db:find(cond)
    db:close()
    if not data or #data == 0 then return nil end
    --for k,v in pairs(data) do
    --    data[k].content = bytes.__tostring(std.b64decode(data[k].content)):gsub("%%","%%%%")
    --end
    return data 
end

gettext.stopwords = function(ospath)
    --local ospath = require("fs/vfs").ospath(path)
    local words = {}
    for line in io.lines(ospath) do
        words[line] = true
    end
    return words
end

return gettext