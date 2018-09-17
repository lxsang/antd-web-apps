class APIManager extends window.classes.BaseObject
    constructor: (@args) ->
        super "APIManager"

    init: () ->
        me = @
        return console.error "No class found" unless @args and @args.length > 0
        cname = (@args.splice 0,1)[0].trim()
        @ready()
            .then () ->
                if mobilecheck()
                    mobileConsole.init()
                # load the class
                return if not cname or cname is ""
                return console.error("Cannot find class ", cname) unless window.classes[cname]
                (new window.classes[cname](me.args)).init()
            .catch ( m, s ) ->
                console.error(m, s)

APIManager.dependencies = [
    "/assets/scripts/mobile_console.js"
]

makeclass "APIManager", APIManager