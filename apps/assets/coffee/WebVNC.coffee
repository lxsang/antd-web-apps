class WebVNC extends window.classes.BaseObject
    constructor: () ->
        super "WebVNC"
    
    init: () ->
        me = @
        @ready()
            .then () ->
                me.initVNCClient()
            .catch (m, s) ->
                console.error(m, s)
    
    initVNCClient: () ->
        args = 
        {
            element: 'canvas',
            ws: 'wss://localhost:9192/wvnc',
            worker: '/assets/scripts/decoder.js'
        }

        @client = new WVNC args
        me = @
        @client.onpassword = () ->
            return new Promise (r,e) ->
                r('lxsan9')
        @client.oncredential = () ->
            return new Promise (r,e) ->
                r('mrsang', '!x$@n9')
        @client.oncopy = (text) ->
            ($ "#clipboard")[0].value = text
        @client.init()
            .then () ->
                $("#connect").click (e) ->
                    me.client.connect "192.168.1.20:5901", {
                        bbp: 32,
                        flag: 3,
                        quality: 30
                    }
                $("#stop").click (e) ->
                    me.client.disconnect()
                
                $("#btclipboard").click (e) ->
                    me.client.sendTextAsClipboard ($ "#clipboard")[0].value
            .catch (m,s) ->
                console.error m, s
WebVNC.dependencies = [
    "/assets/scripts/wvnc.js"
]
makeclass "WebVNC", WebVNC