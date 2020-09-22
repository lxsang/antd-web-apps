BaseModel:subclass("CommentModel", {
    registry = {},
    name = "comments",
    fields = {
        pid = "INTEGER",
        name = "TEXT",
        email = "TEXT",
        content = "TEXT",
        time = "NUMERIC",
        rid = "INTEGER DEFAULT 0"
    }
})
