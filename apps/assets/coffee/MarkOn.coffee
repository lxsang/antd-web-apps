class MarkOn extends window.classes.BaseObject
    constructor: (@id) ->
        super "MarkOn"
    
    init: () ->
        me = @
        @ready()
            .then () ->
                me.editor = new SimpleMDE { element: $(me.id)[0] }
            .catch (m, s) ->
                console.error(m, s)

MarkOn.dependencies = [
    "/rst/gscripts/mde/simplemde.min.js"
]

makeclass "MarkOn", MarkOn