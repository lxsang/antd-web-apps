BaseModel:subclass("SectionsModel",{
    name = "cv_sections",
    fields = {
        title = "TEXT",
        start = "NUMERIC",
        location = "TEXT",
        ["end"]	= "NUMERIC",
        content = "TEXT",
        subtitle = "TEXT",
        publish	= "NUMERIC",
        cid = "NUMERIC",
    }
})