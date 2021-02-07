require(CONTROLLER_ROOT..".doccontroller")
DocController:subclass("JarvisController", {
    path_map = {
        vfs_path = "book://",
        local_path = "/home/mrsang/doc/jarvis",
    },
    name = "jarvis",
    elinks = {
        { name = "API", url = "https://doc.iohub.dev/antos/api/index.html" },
        { name = "Code", url = "https://github.com/lxsang/antos" }
    }
})
