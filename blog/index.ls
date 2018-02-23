<?lua
    BLOG_ROOT = __ROOT__.."/blog"
    -- if a file request, just respond it
    local action = REQUEST.query.action
    if not action or action == "" then
        return require("blog.router")("top:10")
    end

    local path = BLOG_ROOT.."/"..action
    if unix.exists(path) then
        
        local mime = std.mime(path)
        if mime == "application/octet-stream" then
            std.html()
            echo("Acess denied to: "..path)
        else
            std.header(mime)
            if std.is_bin(path) then
                std.fb(path)
            else
                std.f(path)
            end    
        end
    else
        print("Perform action.."..action)
        return require("blog.router")(action)
    end
?>