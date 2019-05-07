BaseController:subclass(
    "SystemController",
    {
        registry = {},
        models = {}
    }
)

function SystemController:actionnotfound(...)
    return self:index(table.unpack({...}))
end

function SystemController:index(...)
    local api = {
        description = "This api handle system operations",
        actions = {
            ["/packages"] = "Handle all operation relate to package: list, install, cache, uninstall",
            ["/settings"] = "Save user setting",
            ["/application"] = "Call a specific server side application api",
            ["/apigateway"] = "Gateway for executing custom server side code"
        }
    }
    result(api)
    return false
end

function SystemController:packages(...)
    auth_or_die("User unauthorized. Please login")
    local rq = (JSON.decodeString(REQUEST.json))
    local packages = require("packages")
    packages.init(rq.args.paths)
    if rq ~= nil then
        -- check user command here
        if (rq.command == "install") then
            packages.install(rq.args)
        elseif rq.command == "cache" then
            packages.cache(rq.args)
        elseif rq.command == "list" then
            packages.list(rq.args.paths)
        elseif rq.command == "uninstall" then
            packages.uninstall(rq.args.path)
        else
            fail("Uknown packages command")
        end
    else
        fail("Uknown request")
    end
end

function SystemController:settings(...)
    auth_or_die("User unauthorized. Please login")
    local user = SESSION.user
    if user then
        local ospath = require("vfs").ospath("home:///", user)
        if REQUEST and REQUEST.json then
            local f = io.open(ospath .. "/" .. ".settings.json", "w")
            if f then
                f:write(REQUEST.json)
                f:close()
                result(true)
            else
                fail("Cannot save setting")
            end
        else
            fail("No setting founds")
        end
    else
        fail("User not found")
    end
end

function SystemController:application(...)
    auth_or_die("User unauthorized. Please login")
    local rq = nil
    if REQUEST.json ~= nil then
        rq = (JSON.decodeString(REQUEST.json))
    else
        rq = REQUEST
    end

    if rq.path ~= nil then
        local pkg = require("vfs").ospath(rq.path)
        if pkg == nil then
            pkg = WWW_ROOT .. "/packages/" .. rq.path
        --die("unkown request path:"..rq.path)
        end
        pkg = pkg .. "/api.lua"
        if ulib.exists(pkg) then
            dofile(pkg).exec(rq.method, rq.arguments)
        else
            fail("Uknown  application handler: " .. pkg)
        end
    else
        fail("Uknown request")
    end
end

function SystemController:apigateway(...)
    local use_ws = false
    if REQUEST and REQUEST.ws == "1" then
        -- override the global echo command
        echo = std.ws.swrite
        use_ws = true
    else
        std.json()
    end
    local exec_with_user_priv = function(data)
        local uid = ulib.uid(SESSION.user)
        if not ulib.setgid(uid.gid) or not ulib.setuid(uid.id) then
            echo("Cannot set permission to execute the code")
            return
        end
        local r, e
        e = "{'error': 'Unknow function'}"
        if data.code then
            r, e = load(data.code)
            if r then
                local status, result = pcall(r)
                if (status) then
                    echo(JSON.encode(result))
                else
                    echo(result)
                end
            else
                echo(e)
            end
        elseif data.path then
            r, e = loadfile(data.path)
            if r then
                local status, result = pcall(r, data.parameters)
                if (status) then
                    echo(JSON.encode(result))
                else
                    echo(result)
                end
            else
                echo(e)
            end
        else
            echo(e)
        end
    end

    if (is_auth()) then
        local pid = ulib.fork()
        if (pid == -1) then
            echo("{'error':'Cannot create process'}")
        elseif pid > 0 then -- parent
            -- wait for the child exit or websocket exit
            ulib.waitpid(pid, 0)
            print("Parent exit")
        else -- child
            if use_ws then
                if std.ws.enable() then
                    -- read header
                    local header = std.ws.header()
                    if header then
                        if header.mask == 0 then
                            print("Data is not masked")
                            std.ws.close(1012)
                        elseif header.opcode == std.ws.CLOSE then
                            print("Connection closed")
                            std.ws.close(1000)
                        elseif header.opcode == std.ws.TEXT then
                            -- read the file
                            local data = std.ws.read(header)
                            if data then
                                data = (JSON.decodeString(data))
                                exec_with_user_priv(data)
                                std.ws.close(1011)
                            else
                                echo("Error: Invalid  request")
                                std.ws.close(1011)
                            end
                        end
                    else
                        std.ws.close(1011)
                    end
                else
                    print("Web socket is not available.")
                end
            else
                if REQUEST.json then
                    data = JSON.decodeString(REQUEST.json)
                    --std.json()
                    exec_with_user_priv(data)
                else
                    fail("Unkown request")
                end
            end
            print("Child exit")
            ulib.kill(-1)
        end
    else
        echo('{"error":"User unauthorized. Please login"}')
    end
end
