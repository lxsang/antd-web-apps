BaseController:subclass(
    "OfficeController",
    {
        registry = {},
        models = {}
    }
)
local docType = function(ext)
    if ext == "doc" or ext=="docx" or ext =="odt" then
        return "word"
    elseif ext == "csv" or ext =="ods" or ext== "xls" or ext == "xlsx" then
        return "cell"
    elseif ext == "odp" or ext == "ppt" or ext == "pptx" then
        return "slide"
    else
        return "none"
    end
end

function OfficeController:index(sid)
    -- doing nothing here
    require("sqlite")
    local ospath = require("shared").ospath(sid)
    local ext = ospath:match("^.+%.(.+)$")
    local name = ospath:match("^.+/(.+)$")
    if(ulib.exists(ospath)) then
        local stat = ulib.file_stat(ospath)
        if stat.error == nil then
            local key = std.sha1(ospath..":"..stat.mtime)
            self.template:set("shareid", sid)
            self.template:set("ext", ext )
            self.template:set("doctype", docType(ext) )
            self.template:set("name", name)
            self.template:set("key", key)
        end
    end
    self:switchLayout("office")
    return true
end

function OfficeController:shared(id)
    require("sqlite")
    require(BASE_FRW.."shared").get(id)
    return false
end

function OfficeController:save(sid)
    require("sqlite")
    local ospath = require("shared").ospath(sid)
    std.json()
    local obj = {
        error = false,
        result = false
    }
    
    if not REQUEST.json then
        obj.error = "Invalid request"
        echo(JSON.encode(obj))
        return false
    end
    local data = JSON.decodeString(REQUEST.json)
    if not data then
        obj.error = "Invalid request"
        echo(JSON.encode(obj))
        return false
    end
    if data.status == 2 then
        local tmpfile = "/tmp/"..std.sha1(ospath)
        local cmd = "curl -o "..tmpfile..' "'..data.url..'"'
        os.execute(cmd)
        -- move file to correct position
        if ulib.exists(tmpfile) then
            cmd = "mv "..tmpfile.." "..ospath
            os.execute(cmd)
            print("File "..ospath.." sync with remote")
        else
            obj.error = "Unable to sync file"
            echo(JSON.encode(obj))
            return false
        end
    end
    
    obj.result = "OK"
    echo(JSON.encode(obj))
    return false
end

function OfficeController:actionnotfound(...)
    self.template:setView("index")
    return self:index(table.unpack({...}))
end