local packages={}
local vfs = require("vfs")
local uid = ulib.uid(SESSION.user)

packages._cache = function(y)
	local p = vfs.ospath(y).."/packages.cache"
	if y:find("^os://") then
		p = __api__.tmpdir.."/packages.cache"
	end
	local f = io.open(p, "w")
	local has_cache = false
	local i = 1
	local meta = {}
	if f then
		local files = vfs.readDir(y)
		for k,v in pairs(files) do
			if v.type == "dir"  then
				local f1 = io.open(vfs.ospath(v.path.."/package.json"))
				if f1 then
					
					local name = std.basename(v.path)
					local mt = JSON.decodeString(f1:read("*all"))
					mt.path = v.path
					meta[i] ='"'..name..'":'..JSON.encode(mt)
					i = i+1
					f1:close()
					has_cache = true;
				end
			end
		end
		f:write(table.concat(meta, ","))
		f:close()
		if has_cache == false then
			ulib.delete(p);
		end
	end
end

-- we will change this later
packages.list = function(paths)
	std.json()
	std.t("{\"result\" : { ")
	local first = true
	--std.f(__ROOT__.."/system/packages.json")
	for k,v in pairs(paths) do
		local osp = vfs.ospath(v.."/packages.cache")
		if v:find("^os://") then
			osp = __api__.tmpdir.."/packages.cache"
		end
		if  ulib.exists(osp) == false then
			packages._cache(v)
		end
		if ulib.exists(osp) then
			if first == false then 
				std.t(",")
			else
				first = false
			end
			std.f(osp)
		end
	end
	std.t("}, \"error\":false}")
end

-- generate the packages caches
packages.cache = function(args)
	-- perform a packages caches
	for x,y in pairs(args.paths) do
		packages._cache(y)
	end 
	result(true)
end
-- install a function from zip file
packages.install = function(args)
	local path = vfs.ospath(args.dest)
	local zip = vfs.ospath(args.zip)
	if(ulib.exists(path) == false) then
		-- create directory if not exist
		ulib.mkdir(path)
		-- change permission
		ulib.chown(path, uid.id, uid.gid)
	end
	-- extract the zip file to it
	if(ulib.unzip(zip, path)) then
		-- read metadata
		local meta = JSON.decodeFile(path.."/metadata.json")
		meta.path = args.dest
		meta.scope = "user"
		local f=io.open(path.."/package.json","w")
		if f then 
			f:write(JSON.encode(meta)) 
			f:close()
		end
		result(true)
	else
		fail("Problem extracting zip file")
	end
	
end
-- uninstall the package
packages.uninstall = function(path)
	local osf = vfs.ospath(path)
	if(osf and ulib.exists(osf) ) then
		--remove it
		ulib.delete(osf)
		result(true)
	else
		fail("Cannot find package")
	end
end
-- set user packages environment
packages.init = function(paths)
	if(paths) then
		for k,v in pairs(paths) do
			local p = vfs.ospath(v)
			if p and (ulib.exists(p) == false) then
				ulib.mkdir(p)
				-- change permission
				ulib.chown(p, uid.id, uid.gid)
			end
		end
	end
end

return packages 
