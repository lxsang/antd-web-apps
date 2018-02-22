
if not REQUEST.query.json then
    fail("unknown request")
end
local rq = (JSON.decodeString(REQUEST.query.json))
local  to = "xsang.le@gmail.com"
local from = "From: "..rq.email.."\n"
local suject = "Subject: "..rq.subject.."\n"
local content = "Contact request from:"..rq.name.."\n Email:"..rq.email.."\n"..rq.content.."\n"

local cmd = 'echo "'..utils.escape(from..suject..content)..'"| sendmail '..to

--print(cmd)
local r = os.execute(cmd)

if r then
    result(r)
else
    fail("Cannot send email at the moment, the service may be down")
end