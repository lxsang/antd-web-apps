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
            #ws: 'wss://localhost:9192/wvnc',
            ws: 'wss://lxsang.me/wvnc',
            worker: '/assets/scripts/decoder.js'
        }

        @client = new WVNC args
        me = @
        @client.onpassword = () ->
            return new Promise (r,e) ->
                r('demopass')
        @client.oncredential = () ->
            return new Promise (r,e) ->
                r('demo', 'demo')
        @client.oncopy = (text) ->
            cosole.log text
        @client.init()
            .then () ->
                $("#connect").click (e) ->
                    me.client.connect "/opt/www/vnc.conf", {
                        bbp: 32,
                        flag: 3,
                        quality: 30
                    }
                $("#tbstatus").html "32bbp, compression JPEG & ZLib, JPEG quality 30%"
                $("#stop").click (e) ->
                    me.client.disconnect()
                $("#selscale").on 'change', (e) ->
                    value = Number(@value)/100
                    me.client.setScale value
                #$("#btclipboard").click (e) ->
                #    me.client.sendTextAsClipboard ($ "#clipboard")[0].value
            .catch (m,s) ->
                console.error m, s
WebVNC.dependencies = [
    "/assets/scripts/wvnc.js"
]
makeclass "WebVNC", WebVNC