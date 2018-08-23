<?lua
    echo("<h1>Default page</h1>")

    local args = {...}
    local views = args[1]
    if views.__main__ then
        views.__main__:render()
    end
?>