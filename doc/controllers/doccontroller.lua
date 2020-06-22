BaseController:subclass("DocController")

local getpath = function(vfspath, controller)
    return vfspath:gsub(controller.path_map.vfs_path, controller.path_map.local_path)
end

function DocController:loadTOC()
    local path = self.path_map.local_path.."/meta.json"
    local result = { error = false}
    if ulib.exists(path) then
        local bmeta = JSON.decodeFile(path)
        if bmeta == nil then
            result.error = true
            result.data = "Unable to read book meta.json"
        else
            result.data = {
                name = bmeta.name,
                path = self.path_map.vfs_path.."/INTRO.md",
                entries = {}
            }
            -- read all the entries
            for kc,vc in pairs(bmeta.entries) do
                local cpath = getpath(vc.path, self).."/meta.json"
                if ulib.exists(cpath) then
                    local cmeta = JSON.decodeFile(cpath)
                    if cmeta then
                        local chapter = {
                            name = cmeta.name,
                            path = vc.path.."/INTRO.md",
                            entries = {}
                        }
                        -- read all sections
                        for ks,vs in pairs(cmeta.entries) do
                            local spath = getpath(vs.path, self).."/meta.json"
                            local smeta = JSON.decodeFile(spath)
                            if smeta then
                                local section = {
                                    name = smeta.name,
                                    path = vs.path.."/INTRO.md",
                                    entries = {}
                                }
                                -- read all files
                                for kf,vf in pairs(smeta.entries) do
                                    local fpath = getpath(vf.path, self)
                                    if ulib.exists(fpath) then
                                        local file = io.open(fpath, "r")
                                        io.input(file)
                                        local line = io.read()
                                        io.close()
                                        if line then
                                            local file = {
                                                name = std.trim(std.trim(line, "#"), " "),
                                                path = vf.path
                                            }
                                            table.insert( section.entries, file)
                                        end
                                    end
                                end
                                table.insert( chapter.entries, section)
                            end
                        end
                        table.insert( result.data.entries, chapter)
                    end
                end
            end
        end
    else
        result.error = true
        result.data = "No meta-data found"
    end
    return result
end

function DocController:index(...)
    local args = {...}
    local toc = self:loadTOC()
    toc.controller = self.name
    self.template:set("toc", toc)
    -- read data from the parameter
    local path = nil
    if args[1] then
        local b64text = args[1]
        if b64text then
            local p = bytes.__tostring(std.b64decode(b64text .. "=="))
            if p then
                path = getpath(p, self)
            end
        end
    else
        path = self.path_map.local_path.."/INTRO.md"
    end
    if path and ulib.exists(path) then
        local file = io.open(path, "r")
        local content = file:read("*a")
        file.close()
        self.template:setView("index", "index")
        self.template:set("data", content)
    else
        self.template:setView("notfound", "index")
    end
    return true
end

function DocController:actionnotfound(...)
    local args = {...}
    return self:index(table.unpack(args))
end