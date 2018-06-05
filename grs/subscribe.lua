
if not REQUEST.query.json then
    fail("unknown request")
end
local rq = (JSON.decodeString(REQUEST.query.json))
local sample = {name = "toto", email = "toto@mail.fr"}
local db = require("db.model").get("mrsang","subscribers",sample)

if db then
    -- check if email is exist
    local data = db:find({exp = { ["="] = { email = rq.email } }})
    if data and #data > 0 then
        fail("You are already/previously subscribed")
    else
        -- save to database
        db:insert(rq)
        result("Ok")
    end
    db:close()
else
    fail("Cannot subscribe at the moment, the service may be down")
end