BaseController:subclass(
    "VFSController",
    {
        registry = {},
        models = {}
    }
)

function VFSController:actionnotfound(...)
    return self:index(table.unpack({...}))
end

function VFSController:index(...)
    local api = {
        description = "This api handle file operations",
        actions = {
            ["/fileinfo"] = "Get file information",
            ["/exists"] = "Check if file exists",
            ["/delete"] = "Delete a file",
            ["/get"] = "Get a file content",
            ["/mkdir"] = "Create directory",
            ["/move"] = "Move file to a new destination",
            ["/publish"] = "Share a file to all users",
            ["/scandir"] = "List all files and folders",
            ["/write"] = "Write data to file",
            ["/shared"] = "Get shared file content"
        }
    }
    result(api)
    return false
end

function VFSController:fileinfo(...)
    auth_or_die("User unauthorized. Please login")
    local vfspath = (JSON.decodeString(REQUEST.json)).path
    local r, m = require("vfs").fileinfo(vfspath)
    if r then
        result(m)
    else
        fail(m)
    end
    return false
end

function VFSController:exists(...)
    auth_or_die("User unauthorized. Please login")

    local vfs = require("vfs")
    local rq = (JSON.decodeString(REQUEST.json))

    if rq ~= nil then
        result(vfs.exists(rq.path))
    else
        fail("Uknown request")
    end
    return false
end

function VFSController:delete(...)
    auth_or_die("User unauthorized. Please login")

    local vfs = require("vfs")
    local rq = (JSON.decodeString(REQUEST.json))

    if rq ~= nil then
        local r, e = vfs.delete(rq.path)
        if r then
            result(r)
        else
            fail(e)
        end
    else
        fail("Uknown request")
    end
    return false
end

function VFSController:get(...)
    local args = {...}
    local uri = implode(args, "/")
    auth_or_die("User unauthorized. Please login")
    local vfsfile = utils.decodeURI(uri)
    local r, m = require("vfs").checkperm(vfsfile, "read")
    if r then
        local mime = std.mimeOf(m)
        if mime == "audio/mpeg" then
            local finfo = ulib.file_stat(m)
            local len = tostring(math.floor(finfo.size))
            local len1 = tostring(math.floor(finfo.size - 1))
            std.status(200, "OK")
            std.custom_header("Pragma", "public")
            std.custom_header("Expires", "0")
            std.custom_header("Content-Type", mime)
            std.custom_header("Content-Length", len)
            std.custom_header("Content-Disposition", "inline; filename=" .. std.basename(m))
            std.custom_header("Content-Range:", "bytes 0-" .. len1 .. "/" .. len)
            std.custom_header("Accept-Ranges", "bytes")
            std.custom_header("X-Pad", "avoid browser bug")
            std.custom_header("Content-Transfer-Encoding", "binary")
            std.custom_header("Cache-Control", "no-cache, no-store")
            std.custom_header("Connection", "Keep-Alive")
            std.custom_header("Etag", "a404b-c3f-47c3a14937c80")
            std.header_flush()
        else
            std.header(mime)
        end

        if std.is_bin(m) then
            std.fb(m)
        else
            std.f(m)
        end
    else
        fail(m)
    end

    return false
end

function VFSController:mkdir(...)
    auth_or_die("User unauthorized. Please login")

    local rq = (JSON.decodeString(REQUEST.json))

    if rq ~= nil then
        local r, m = require("vfs").mkdir(rq.path)
        if r then
            result(r)
        else
            fail(m)
        end
    else
        fail("Uknown request")
    end
    return false
end

function VFSController:move(...)
    auth_or_die("User unauthorized. Please login")

    local rq = (JSON.decodeString(REQUEST.json))

    if rq ~= nil then
        local r, m = require("vfs").move(rq.src, rq.dest)
        if r then
            result(r)
        else
            fail(m)
        end
    else
        fail("Uknown request")
    end
    return false
end

function VFSController:publish(...)
    auth_or_die("User unauthorized. Please login")

    local rq = (JSON.decodeString(REQUEST.json))

    if rq ~= nil then
        local p = nil
        if rq.publish then
            p = require("vfs").ospath(rq.path)
        else
            p = require("shared").ospath(rq.path)
        end
        local user = SESSION.user
        local uid = ulib.uid(user)
        local st = ulib.file_stat(p)
        if uid.id ~= st.uid then
            die("Only the owner can share or unshare this file")
        end
        local entry = {sid = std.sha1(p), user = SESSION.user, path = p, uid = uid.id}
        local db = require("dbmodel").get("sysdb", "shared", entry)
        if db == nil then
            die("Cannot get system database")
        end
        local cond = nil
        if rq.publish then
            cond = {exp = {["="] = {path = p}}}
            local data = db:find(cond)
            if data == nil or data[0] == nil then
                -- insert entry
                db:insert(entry)
            end
        else
            cond = {["="] = {sid = rq.path}}
            db:delete(cond)
        end
        db:close()
        result(entry.sid)
    else
        fail("Uknown request")
    end
    return false
end

function VFSController:scandir(...)
    auth_or_die("User unauthorized. Please login")
    local rq = JSON.decodeString(REQUEST.json)
    local vfspath = rq.path
    local r = require("vfs").readDir(vfspath)
    if r == nil then
        fail("Resource not found: " .. rq.path)
    else
        --print(JSON.encode(readDir(ospath, vfspath)))
        result(r)
    end
    return false
end

function VFSController:upload(...)
    auth_or_die("User unauthorized. Please login")
    local vfs = require("vfs")
    if REQUEST then
        local r, m = require("vfs").upload(REQUEST.path)
        if r then
            result(r)
        else
            fail(m)
        end
    else
        fail("Query not found")
    end
    return false
end

function VFSController:write(...)
    auth_or_die("User unauthorized. Please login")
    local rq = (JSON.decodeString(REQUEST.json))

    if rq ~= nil then
        local r, m = require("vfs").write(rq.path, rq.data)
        if r then
            result(r)
        else
            fail(m)
        end
    else
        fail("Uknown request")
    end
    return false
end

function VFSController:shared(sid)
    require("shared").get(sid)
end