require(CONTROLLER_ROOT..".doccontroller")
DocController:subclass("AntosController", {
    path_map = {
        vfs_path = "book://",
        local_path = DOC_DIR.."/antos",
    },
    name = "antos",
    elinks = {
        { name = "API", url = "https://ci.iohub.dev/public/antos-release/doc/1.2.x/" },
        { name = "Code", url = "https://github.com/lxsang/antos" }
    }
})
