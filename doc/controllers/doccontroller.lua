BaseController:subclass("DocController")

local getpath = function(vfspath, controller)
    return vfspath:gsub(controller.path_map.vfs_path,
                        controller.path_map.local_path)
end

local pre_process_md = function(str, obj)
    local content = str
    for capture in str:gmatch("(%[%[@book:image:[^\n%]]*%]%])") do
        local apath = capture:match("%[%[@book:image:([^\n%]]*)%]%]")
        local pattern = capture:gsub("%[", "%%["):gsub("%]", "%%]"):gsub("%-",
                                                                         "%%-")
        if apath then
            apath = apath:gsub(" ", "%%%%20")
            print(apath)
            content = content:gsub(pattern, "![](" .. HTTP_ROOT .. "/" ..
                                       obj.name .. "/asset/" .. apath .. ")")
        end
    end
    return content
end

local post_process_md = function(str, obj)
    local content = str
    local has_model = false
    -- 3D model
    for capture in str:gmatch("(%[%[@book:3dmodel:[^\n%]]*%]%])") do
        local apath = capture:match("%[%[@book:3dmodel:([^\n%]]*)%]%]")
        local pattern = capture:gsub("%[", "%%["):gsub("%]", "%%]"):gsub("%-",
                                                                         "%%-")
        if apath then
            -- apath = utils.urlencode(apath):gsub("%%", "%%%%")
            apath = apath:gsub(" ", "%%20")
            content = content:gsub(pattern,
                                   "<model-viewer src=\"" .. HTTP_ROOT .. "/" ..
                                       obj.name .. "/asset/" .. apath ..
                                       "\" auto-rotate camera-controls></model-viewer>")
            has_model = true
        end
    end
    -- Youtube video
    for capture in str:gmatch("(%[%[youtube:[^\n%]]*%]%])") do
        local apath = capture:match("%[%[youtube:([^\n%]]*)%]%]")
        local pattern = capture:gsub("%[", "%%["):gsub("%]", "%%]"):gsub("%-",
                                                                         "%%-")
        if apath then
            content = content:gsub(pattern,
                                   "<iframe style='width:100%%;height: auto;min-height: 400px;' src=\"https://www.youtube.com/embed/" ..
                                       apath .. "\"> </iframe>")
        end
    end

    return content, has_model
end
function DocController:loadTOC()
    local path = self.path_map.local_path .. "/meta.json"
    local result = {error = false}
    if ulib.exists(path) then
        local bmeta = JSON.decodeFile(path)
        if bmeta == nil then
            result.error = true
            result.data = "Unable to read book meta.json"
        else
            result.data = {
                name = bmeta.name,
                path = self.path_map.vfs_path .. "/INTRO.md",
                entries = {},
                parent = nil
            }
            -- read all the entries
            for kc, vc in pairs(bmeta.entries) do
                local cpath = getpath(vc.path, self) .. "/meta.json"
                if ulib.exists(cpath) then
                    local cmeta = JSON.decodeFile(cpath)
                    if cmeta then
                        local chapter = {
                            name = cmeta.name,
                            path = vc.path .. "/INTRO.md",
                            tpath = vc.path,
                            entries = {},
                            parent = result.data,
                            id = kc
                        }
                        -- read all sections
                        for ks, vs in pairs(cmeta.entries) do
                            local spath = getpath(vs.path, self) .. "/meta.json"
                            local smeta = JSON.decodeFile(spath)
                            if smeta then
                                local section =
                                    {
                                        name = smeta.name,
                                        path = vs.path .. "/INTRO.md",
                                        tpath = vs.path,
                                        entries = {},
                                        parent = chapter,
                                        id = ks
                                    }
                                -- read all files
                                for kf, vf in pairs(smeta.entries) do
                                    local fpath = getpath(vf.path, self)
                                    if ulib.exists(fpath) then
                                        local file = io.open(fpath, "r")
                                        io.input(file)
                                        local line = io.read()
                                        io.close()
                                        if line then
                                            local file =
                                                {
                                                    name = std.trim(
                                                        std.trim(line, "#"), " "),
                                                    path = vf.path,
                                                    tpath = vf.path,
                                                    parent = section,
                                                    id = kf
                                                }
                                            table.insert(section.entries, file)
                                        end
                                    end
                                end
                                table.insert(chapter.entries, section)
                            end
                        end
                        table.insert(result.data.entries, chapter)
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
    self.template:set("elinks", self.elinks)

    -- read data from the parameter
    local path = nil
    if args[1] then
        local b64text = args[1]
        if b64text then
            local p = bytes.__tostring(std.b64decode(b64text .. "=="))
            if p then
                toc.cpath = p
                path = getpath(p, self)
                if path and ulib.exists(path) then
                    self.template:set("url", HTTP_ROOT .. '/' .. self.name ..
                                          '/' ..
                                          std.b64encode(toc.cpath):gsub("=", ""))
                end
            end
        end
    else
        toc.cpath = self.path_map.vfs_path
        path = self.path_map.local_path .. "/INTRO.md"
    end
    if path and ulib.exists(path) then
        local has_3d = false
        local file = io.open(path, "r")
        local content = ""
        local md = require("md")
        local callback = function(s) content = content .. s end
        md.to_html(pre_process_md(file:read("*a"), self), callback)
        file.close()
        content, has_3d = post_process_md(content, self)
        -- replace some display plugins

        self.template:setView("book", "index")
        self.template:set("data", content)
        self.template:set("has_3d", has_3d)
    else
        self.template:setView("notfound", "index")
    end
    return true
end

function DocController:search(...)
    local args = {...}
    local query = REQUEST.q
    if query then
        local cmd = "grep -ri --include=\\*.md "
        local arr = explode(query, " ")
        local patterns = {}
        for k, v in ipairs(arr) do
            local world = std.trim(v, " ")
            if v and v ~= "" then
                cmd = cmd .. " -e '" .. v .. "' "
                table.insert(patterns, v:lower())
            end
        end
        if #patterns > 0 then
            local toc = self:loadTOC()
            toc.controller = self.name
            self.template:set("toc", toc)
            self.template:setView("search", "index")
            cmd = cmd .. self.path_map.local_path
            local handle = io.popen(cmd)
            local result = {}
            for line in handle:lines() do
                file = line:match("^[^:]*")
                if file then
                    if not result[file] then
                        result[file] = {}
                    end
                    local content = line:gsub("^[^:]*:", ""):lower()
                    for k, p in ipairs(patterns) do
                        content = content:gsub(p,
                                               "<span class='pattern'>" .. p ..
                                                   "</span>")
                    end
                    table.insert(result[file], content)
                end
            end
            handle:close()
            -- process the result
            self.template:set("data", result)
            self.template:set("controller", self.name)
            self.template:set("map", self.path_map)
            self.template:set("elinks", self.elinks)
        else
            return self:actionnotfound(table.unpack(args))
        end
    else
        return self:actionnotfound(table.unpack(args))
    end
    return true
end

function DocController:asset(...)
    local args = {...}
    if #args == 0 then return self:actionnotfound(table.unpack(args)) end

    local path = self.path_map.local_path .. "/" .. implode(args, DIR_SEP)

    if self.registry.fileaccess and ulib.exists(path) then
        local mime = std.mimeOf(path)
        if POLICY.mimes[mime] then
            std.sendFile(path)
        else
            self:error("Access forbidden: " .. path)
        end
    else
        self:error("Asset file not found or access forbidden: " .. path)
    end
    return false
end
function DocController:api(...)
    local args = {...}
    if not self.path_map.api_path then
        return self:actionnotfound(table.unpack(args))
    end
    local rpath = "index.html"
    if #args ~= 0 then rpath = implode(args, "/") end
    local path = self.path_map.api_path .. "/" .. rpath

    if ulib.exists(path) then
        local mime = std.mimeOf(path)
        if POLICY.mimes[mime] then
            std.sendFile(path)
        else
            self:error("Access forbidden: " .. path)
        end
    else
        self:error("File not found or access forbidden: " .. path)
    end
    return false
end

function DocController:actionnotfound(...)
    local args = {...}
    return self:index(table.unpack(args))
end
