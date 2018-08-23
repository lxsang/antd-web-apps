BaseObject = Object:extends{registry = {}, class="BaseObject"}


function BaseObject:log(msg, level)
    level = level or "INFO"
    if self.registry.logger then
        self.registry.logger:log(msg,level)
    end
end

function BaseObject:debug(msg)
    self:log(msg, "DEBUG")
end

function BaseObject:error(msg, trace)
    html()
    echo(msg)
    self:log(msg,"ERROR")
    if trace then
        debug.traceback=nil
        error(msg)
    else
        error(msg)
    end
    return false
end