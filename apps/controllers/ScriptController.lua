BaseController:subclass("ScriptController", {
    registry = {}
})

function ScriptController:index( name )
    local path = WWW_ROOT..DIR_SEP.."assets"..DIR_SEP.."shs"..DIR_SEP..name..".sh"

    if ulib.exists(path) then
        std.header("text/plain")
        std.f(path)
    else
        self:error("No script found")
    end
    return false
end

function ScriptController:actionnotfound(...)
    return self:index(table.unpack({...}))
end