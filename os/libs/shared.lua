local shared = {}
shared.get =  function(sharedid)
    if sharedid == "all" then
        -- get all shared files
        local db = require("dbmodel").get("sysdb", "shared", nil)
        if db == nil then die("Cannot get shared database") end
        local data = db:getAll()
        if data == nil then die("No file found") end
        local i = 1
        local ret = {}
        for k,v in pairs(data) do
            if(ulib.exists(v.path)) then
                local r = ulib.file_stat(v.path)
                if(r.error == nil) then
                    r.path = "shared://"..v.sid
                    r.filename = std.basename(v.path)
                    if r.mime == "application/octet-stream" then
                        r.mime = std.extra_mime(r.filename)
                    end
                    ret[i] = r
                    i = i+1
                end
            else
                local cond = { ["="] = { sid = v.sid } }
                db:delete(cond) 
            end
        end
        db:close()
        --std.json()
        result(ret)
    else
        
        local p = shared.ospath(sharedid)
        std.sendFile(p)
    end
end

shared.ospath = function(sharedid)
    local db = require("dbmodel").get("sysdb", "shared", nil)
    if db == nil then die("Cannot get shared database") end
    local cond = { exp = { ["="] = { sid = sharedid } } }
    local data = db:find(cond) 
    db:close()
    if data == nil or data[1] == nil then die("Cannot get shared file with: "..sharedid) end
    return data[1].path
end
return shared;
