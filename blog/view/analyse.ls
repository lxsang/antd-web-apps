<?lua
local arg = {...}
local data = arg[1]
loadscript(BLOG_ROOT.."/view/top.ls")("Welcome to my blog", false)
echo(data)
?>