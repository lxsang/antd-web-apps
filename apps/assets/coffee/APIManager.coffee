class APIManager extends window.classes.BaseObject
    constructor: () ->
        super "APIManager"

    init: (cname) ->
        console.log(cname)
        @ready()
            .then () ->
                if mobilecheck()
                    mobileConsole.init()
                # load the class
                return if not cname or cname is ""
                return console.error("Cannot find class ", cname) unless window.classes[cname]
                (new window.classes[cname]).init()
            .catch ( m, s ) ->
                console.error(m, s)

APIManager.dependencies = [
    "/assets/scripts/mobile_console.js"
]

makeclass "APIManager", APIManager