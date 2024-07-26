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
    if not REQUEST.json then
        fail("unknown request")
        return
    end
    local setting = JSON.decodeFile(SMTP_SETTING)

    local socket = require 'socket'
    local smtp = require 'socket.smtp'
    local ssl = require 'ssl'
    local https = require 'ssl.https'
    local ltn12 = require 'ltn12'

    local sslCreate = function()
        local sock = socket.tcp()
        return setmetatable({
            connect = function(_, host, port)
                local r, e = sock:connect(host, port)
                if not r then return r, e end
                sock = ssl.wrap(sock, {mode='client', protocol='tlsv1_2'})
                return sock:dohandshake()
            end
        }, {
            __index = function(t,n)
                return function(_, ...)
                    return sock[n](sock, ...)
                end
            end
        })
    end


    if not setting then
        fail("Dont know how to connect to SMTP server")
        return
    end
    local rq = (JSON.decodeString(REQUEST.json))
    local to = "contact@iohub.dev"
    
    local msg = {
        headers = {
            from = string.format("%s <%s>", rq.name, rq.email),
            to = string.format("Contact <%s>",to),
            subject = rq.subject
        },
        body = rq.content
    }
    LOG_INFO("Send mail on server %s user %s port %d: %s", setting.server, setting.user, setting.port, JSON.encode(msg))
    local ok, err = smtp.send {
        from = string.format("<%s>",rq.email),
        rcpt = string.format('<%s>', to),
        source = smtp.message(msg),
        user = setting.user,
        password = setting.password,
        server = setting.server,
        port = math.floor(setting.port),
        create = sslCreate
    }
    if not ok then
        fail(err)
    else
        result("Email sent")
    end
end

function ServiceController:subscribe()
    if not REQUEST.json then
        fail("unknown request")
    end
    local rq = (JSON.decodeString(REQUEST.json))
    -- check if email is exist
    local data = self.subscribers:find({where = {email = rq.email}})
    if data and #data > 0 then
        fail("You are already/previously subscribed")
    else
        -- save to database
        self.subscribers:create(rq)
        result("Ok")
    end
    return false
end
