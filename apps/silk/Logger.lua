Logger = Object:extends{levels = {}}

function Logger:initialize()
end

function Logger:log(msg,level)
end

function Logger:info(msg)
    self.log(msg, "INFO")
end

function Logger:debug(msg)
    self.log(msg, "DEBUG")
end


function Logger:error(msg)
    self.log(msg, "ERROR")
end