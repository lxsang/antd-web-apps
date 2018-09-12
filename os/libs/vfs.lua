local vfs = {}


vfs.ospath = function(path)
	local user = SESSION.user
	local prefix = string.match(path, "%a+://")
	if(prefix ~= nil) then
		local suffix = string.gsub(path,prefix,"")
		if prefix == "home://" then
			return string.format(VFS_HOME,user)..'/'..suffix 
		elseif prefix == "desktop://" then
			return string.format(VFS_HOME,user).."/.desktop/"..suffix
		elseif prefix == "shared://" then
			return require("shared").ospath(std.trim(suffix,"/")) 
		elseif prefix == "os://" then
			return WWW_ROOT.."/"..suffix
		else
			return nil
		end			
	else
		return nil;
	end
end


vfs.delete = function(path)
	local r,m = vfs.checkperm(path,"write")
	if r then
		if ulib.delete(m) then
			-- change permission
			return true,nil
		else
			return false,"Cant not delete the file"
		end
	else
		return r,m
	end
end

vfs.exists = function(path)
	local osfile = vfs.ospath(path)
	return ulib.exists(osfile)
end

vfs.fileinfo = function(vfspath)
	local ospath = vfs.ospath(vfspath)
	if ospath  then
		if(ulib.exists(ospath) == false) then return false,"File not found" end
		local r = ulib.file_stat(ospath)
		if(r.error ~= nil) then return false,r.error end
		r.path = vfspath
		r.name = std.basename(vfspath)
		if r.mime == "application/octet-stream" then
			r.mime = std.extra_mime(r.name)
		end
		return true,r
	else
		return false,"Resource not found"
	end
end

vfs.mkdir = function(path)
	local file = std.basename(path)
	local folder = string.gsub(path, utils.escape_pattern(file),"")
	local r,m = vfs.checkperm(folder,"write")
	
	if r then
		local osfile = m.."/"..file
		local uid = ulib.uid(SESSION.user)
		ulib.mkdir(osfile)
		-- change permission
		ulib.chown(osfile, uid.id, uid.gid)
		return true,nil
	else
		return r,m
	end
end

vfs.move = function(src,dest)
	local file = std.basename(dest)
	local folder = string.gsub(dest, utils.escape_pattern(file),"")
	
	local sp,sm = vfs.checkperm(src,"write")
	if sp then
		local dp,dm = vfs.checkperm(folder,"write")
		if dp then
			ulib.move(sm,dm.."/"..file)
			-- change permission
			return true,nil
		else
			return dp,dm
		end
	else
		return sp,sm
	end
end

vfs.write = function(path,data)
	local file = std.basename(path)
	local folder = string.gsub(path, utils.escape_pattern(file),"")
	
	local r,m = vfs.checkperm(folder,"write")
	if r then
		local osfile = m.."/"..file
		
		if ulib.exists(osfile) then
			local r1,m1 = vfs.checkperm(path,"write")
			if not r1 then
				return r1, m1..": "..path
			end
		end

		local uid = ulib.uid(SESSION.user)
		--
		if data ~= "" then
			local header = string.match(data, "^data%:%w+%/%w+;base64,")
			if header ~= nil then
				local b64data = string.gsub(data, header,"")
				local barr = std.b64decode(b64data)
				if std.isBinary(osfile) then
					bytes.write(barr,osfile)
				else
					local f = io.open(osfile, "w")
					f:write(bytes.__tostring(barr))
					f:close()
				end
			end
		else
			bytes.write(bytes.new(0),osfile)
		end
		--f:close()
		-- change permission
		ulib.chown(osfile, uid.id, uid.gid)
		return true,nil
	else
		return r,m..": "..folder
	end
end

vfs.upload = function(path)
	local r,m = vfs.checkperm(path,"write")
	if(r) then
		local uid = ulib.uid(SESSION.user)
		local file = m.."/"..REQUEST.query["upload.file"]
		ulib.move(REQUEST.query["upload.tmp"], file)
		ulib.chown(file, uid.id, uid.gid)
		return true, nil
	else
		return r,m
	end
end

vfs.checkperm = function(path, right)
	local osfile = vfs.ospath(path)
	local perm = vfs.perm(osfile)
	print(osfile)
	if not ulib.exists(osfile) then
		return false,"Resource does not exist"
	end
	-- check if user own the file
	if perm ~= nil then
		if perm[right] == true then
			print("Permission granted")
			return true,osfile
		else
			print("Permission denie")
			return false,"You dont have "..right.." permission on this file"
		end
	else
		return false,"User is unrecognized"
	end
end

vfs.perm = function(file)
	local user = SESSION.user
	local uid = ulib.uid(user)
	local st = ulib.file_stat(file)
	-- check if user own the file
	if uid ~= nil and st ~= nil and st.perm ~= nil then
		--print(JSON.encode({uid, st}))
		if(uid.id == st.uid) then -- the user owned the file
			print("file belong to user")
			return st.perm.owner
		elseif uid.groups and uid.groups[st.gid] then
			print("User belong to this group")	
			return st.perm.group
		else
			print("User belong to other")
			return st.perm.other
		end	
	else
		return nil
	end
end

vfs.readDir = function(vfspath)
	if(string.sub(vfspath,-1) == "/") then
		prefix = string.sub(vfspath,1,-2)
	else
		prefix = vfspath
	end
	local ospath = vfs.ospath(vfspath,SESSION.user)
	local r = ulib.read_dir(ospath, prefix)
	if(r.error ~= nil) then return nil end
	-- add extra mime type 
	for k,v in pairs(r) do
		if v.mime == "application/octet-stream" then
			v.mime = std.extra_mime(v.filename)
		end
	end
	return r
end

return vfs
