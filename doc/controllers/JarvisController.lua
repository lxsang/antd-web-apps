require(CONTROLLER_ROOT..".doccontroller")
DocController:subclass("JarvisController", {
    path_map = {
        vfs_path = "book://",
        local_path = DOC_DIR.."/jarvis",
    },
    name = "jarvis"
})
