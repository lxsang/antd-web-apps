BaseController:subclass(
    "ServiceController",
    {
        registry = {},
        models = {"subscribers"}
    }
)

function fail(msg)
    std.json()
    std.t(JSON.encode({error = msg}))
end

function result(obj)
    std.json()
    std.t(JSON.encode({result = obj, error = false}))
end

function ServiceController:sendmail()
    if not REQUEST.query.json then
        fail("unknown request")
    end
    local rq = (JSON.decodeString(REQUEST.query.json))
    local to = "xsang.le@gmail.com"
    local from = "From: " .. rq.email .. "\n"
    local suject = "Subject: " .. rq.subject .. "\n"
    local content = "Contact request from:" .. rq.name .. "\n Email: " .. rq.email .. "\n" .. rq.content .. "\n"

    local cmd = 'echo "' .. utils.escape(from .. suject .. content) .. '"| sendmail ' .. to

    --print(cmd)
    local r = os.execute(cmd)

    if r then
        result(r)
    else
        fail("Cannot send email at the moment, the service may be down")
    end
    return false
end

function ServiceController:subscribe()
    if not REQUEST.query.json then
        fail("unknown request")
    end
    local rq = (JSON.decodeString(REQUEST.query.json))
    -- check if email is exist
    local data = self.subscribers:find({exp = {["="] = {email = rq.email}}})
    if data and #data > 0 then
        fail("You are already/previously subscribed")
    else
        -- save to database
        self.subscribers:create(rq)
        result("Ok")
    end
    return false
end
