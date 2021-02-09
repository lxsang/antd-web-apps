require("sqlite")
function fail(msg)
	std.json()
	std.t(JSON.encode({error=msg}))
end

function result(obj)
	std.json()
	std.t(JSON.encode({result=obj, error=false}))
end

function die (msg)
  fail(msg)
  debug.traceback=nil
  error("Permission denied")
  return false
end

-- check if the sysdb is create, otherwise create the table
function sysdb()
	local meta = {}
	meta.sessionid = ""
	meta.username = ""
	meta.stamp = 0
	return require("dbmodel").get("sysdb", "sessions", meta)
end

function is_auth()
	local sessionid = nil
	if SESSION.sessionid and SESSION.sessionid ~= '0' then
		sessionid = SESSION.sessionid
	-- should be used only by API call
	elseif REQUEST.sessionid and REQUEST.sessionid ~= '0' then
		sessionid = REQUEST.sessionid
	end
	if sessionid == nil then
		return false
	end
	-- query session id from database
	local db = sysdb()
	if db == nil then return false end
	local cond = {exp= {["="] = { sessionid = sessionid }}}
	local data = db:find(cond)
	--print(JSON.encode(data))
	db:close()
	if data == nil or data[1] == nil then return die("No user data found") end
	-- next time check the stamp
	SESSION.user = data[1].username
	return true
end

function auth_or_die(msg)
	if(is_auth() == false) then
		die(msg)
	end
end