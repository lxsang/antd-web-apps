BaseController:subclass("CommentController",
                        {registry = {}, models = {"comment", "pages"}})

local function process_md(input)
    local md = require("md")
    local content = ""
    local callback = function(s) content = content .. s end
    md.to_html(input, callback)
    return content
end

local function sendmail(to, subject, content)
    LOG_DEBUG("Sending email to %s", to)
    local from = "From: contact@iohub.dev\nTo: " .. to .. "\n"
    local suject = "Subject: " .. subject .. "\n"

    local cmd = 'echo "' .. utils.escape(from .. suject .. content) ..
                    '"| sendmail ' .. to
    local r = os.execute(cmd)

    if r then return true end
    return false
end
function CommentController:index(...)
    if (REQUEST.method == "OPTIONS") then
        result("")
        return false
    end
    if not REQUEST.json then
        fail("Invalid request")
        return false
    end
    local rq = (JSON.decodeString(REQUEST.json))
    if (rq) then
        local pages, order = self.pages:find({where = {uri = rq.page}})
        if not pages or #order == 0 then
            fail("Be the first to comment")
        else
            local pid = pages[1].id
            local comments, order = self.comment:find({
                    where = {
                        pid = pid,
                        rid = 0
                    },
                    order = {"time$asc"},
                    fields = {"id", "time", "name", "rid", "pid", "content"}
                })
            if not comments or #order == 0 then
                fail("Be the first to comment")
            else
                for idx, v in pairs(order) do
                    local data = comments[v]
                    data.content = process_md(data.content)
                    data.children = {}
                    -- find all the replies to this thread
                    local sub_comments, suborder =
                        self.comment:find(
                            {
                                where = {
                                    pid = pid,
                                    rid = data.id
                                },
                                order = {"time$asc"}

                            })
                    if sub_comments and #suborder ~= 0 then
                        for i, subc in pairs(suborder) do
                            sub_comments[subc].content =
                                process_md(sub_comments[subc].content)
                        end
                        data.children = sub_comments
                    end
                end
                result(comments)
            end
        end
    else
        fail("Invalid request")
    end
    return false
end

function CommentController:post(...)
    if (REQUEST.method == "OPTIONS") then
        result("")
        return false
    end
    if not REQUEST.json then
        fail("Invalid request")
        return false
    end
    local rq = (JSON.decodeString(REQUEST.json))
    if rq then
        local pages, order = self.pages:find({where = rq.page})
        if not pages or #order == 0 then
            -- insert data
            if self.pages:create(rq.page) then
                rq.comment.pid = self.pages.db:lastInsertID()
            else
                fail("Unable to initialize comment thread for page: " ..
                         rq.page.uri)
                return false
            end
        else
            rq.comment.pid = pages[1].id
        end
        -- now insert the comment
        rq.comment.time = os.time(os.date("!*t"))
        if (self.comment:create(rq.comment)) then
            rq.comment.id = self.comment.db:lastInsertID()

            rq.comment.content = process_md(rq.comment.content)
            -- notify the author
            if rq.author then
                sendmail(rq.author, rq.comment.name ..
                             " has commented on one of your pages",
                         rq.comment.name .. " has commented on your page: " ..
                             rq.page.uri ..
                             ".\nBest regards,\nEmail automatically sent by QuickTalk API")
            end
            -- send mail to all users of current page
            local cmts, cmti = self.comment:find(
                {
                    where = {
                        pid = rq.comment.pid,
                        ["email$ne"] = rq.comment.email
                    },
                    fields = {"id", "email"}
                })
                -- check duplicate email
            if cmts and #cmti > 0 then
                local sent = {}
                for idx, v in pairs(cmti) do
                    if not sent[cmts[v].email] then
                        sendmail(cmts[v].email, rq.comment.name ..
                                 " has written something on a page that you've commented on",
                             rq.comment.name ..
                                 " has written something on a page that you've commented. \nPlease visit this page: " ..
                                 rq.page.uri..
                                 " for updates on the discussion.\nBest regards,\nEmail automatically sent by QuickTalk API")
                        sent[cmts[v].email] = true
                    end
                end
            end
            rq.comment.email = ""
            result(rq.comment)
        else
            fail("Unable to save comment")
        end
    else
        fail("Invalid request")
    end
    return false
end

function CommentController:preview(...)
    if (REQUEST.method == "OPTIONS") then
        result("")
        return false
    end
    if not REQUEST.json then
        fail("Invalid request")
        return false
    end
    local rq = (JSON.decodeString(REQUEST.json))
    if (rq and rq.data) then
        result(process_md(rq.data))
    else
        fail("Invalid request")
    end
    return false
end
