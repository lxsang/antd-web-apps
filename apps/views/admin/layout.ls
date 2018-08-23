<?lua
    local args = {...}
    echo("Admin pages<br />")
    local views = args[1]
    for k, v in pairs(views) do
        echo(k.." -> ")
        v:render()
        echo("<br/>")
    end
    --views.__main__:render()
?>