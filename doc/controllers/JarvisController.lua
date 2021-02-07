require(CONTROLLER_ROOT..".doccontroller")
DocController:subclass("JarvisController", {
    path_map = {
        vfs_path = "book://",
        local_path = "/home/mrsang/doc/jarvis",
    },
    name = "jarvis"
})
