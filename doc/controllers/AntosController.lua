require(CONTROLLER_ROOT..".doccontroller")
DocController:subclass("AntosController", {
    path_map = {
        vfs_path = "home://testws/antos",
        local_path = "/home/mrsang/testws/antos"
    },
    name = "antos",
    elinks = {
        { name = "API", url = "https://doc.iohub.dev/antos/api/" }
    }
})
