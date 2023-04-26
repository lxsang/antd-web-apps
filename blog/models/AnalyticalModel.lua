BaseModel:subclass("AnalyticalModel",{
    registry = {},
    name = "st_similarity",
    fields = {
        pid	= "NUMERIC",
	sid	= "NUMERIC",
	score = "NUMERIC"
    }
})

function AnalyticalModel:similarof(id)
    return self:find({
        where = {pid = id},
        order = { "score$desc"}
    })
end