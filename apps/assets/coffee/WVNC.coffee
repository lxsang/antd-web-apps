class WVNC extends window.classes.BaseObject
    constructor: (@args) ->
        super "WVNC"
        @socket = undefined
        @uri = undefined
        @uri = @args[0] if @args and @args.length > 0
        @canvas = undefined
        @canvas = ($ @args[1])[0] if @args and @args.length > 1
        @scale = 0.8
        @decoder = new Worker('/assets/scripts/decoder.js')
        me = @
        @mouseMask = 0
        @decoder.onmessage = (e) ->
            me.process e.data
    init: () ->
        me = @
        @ready()
            .then () ->
                $("#stop").click (e) -> me.socket.close() if me.socket
                $("#connect").click (e) ->
                    me.openSession()
                me.initInputEvent()
            .catch (m, s) ->
                console.error(m, s)

    initInputEvent: () ->
        me = @

        getMousePos = (e) ->
            rect = me.canvas.getBoundingClientRect()
            pos=
                x:  Math.floor((e.clientX - rect.left) / me.scale)
                y: Math.floor((e.clientY - rect.top) / me.scale)
            return pos

        sendMouseLocation = (e) ->
            p = getMousePos e
            me.sendPointEvent p.x, p.y, me.mouseMask

        return unless me.canvas
        ($ me.canvas).css "cursor", "none"
        ($ me.canvas).contextmenu (e) ->
            e.preventDefault()
            return false

        ($ me.canvas).mousemove (e) -> sendMouseLocation e

        ($ me.canvas).mousedown (e) ->
            state = 1 << e.button
            me.mouseMask = me.mouseMask | state
            sendMouseLocation e
            #e.preventDefault()

        ($ me.canvas).mouseup (e) ->
            state = 1 << e.button
            me.mouseMask = me.mouseMask & (~state)
            sendMouseLocation e
            #e.preventDefault()
        
        me.canvas.onkeydown = me.canvas.onkeyup = (e) ->
            # get the key code
            keycode = e.keyCode
            #console.log e
            switch keycode
                when 8  then code = 0xFF08 #back space
                when 9  then code = 0xff89 #0xFF09 # tab ?
                when 13 then code = 0xFF0D # return
                when 27 then code = 0xFF1B # esc
                when 46 then code = 0xFFFF # delete to verify
                when 38 then code = 0xFF52 # up
                when 40 then code = 0xFF54 # down
                when 37 then code = 0xFF51 # left
                when 39 then code = 0xFF53 # right
                when 91 then code = 0xFFE7 # meta left
                when 93 then code = 0xFFE8 # meta right
                when 16 then code = 0xFFE1 # shift left
                when 17 then code = 0xFFE3 # ctrl left
                when 18 then code = 0xFFE9 # alt left
                when 20 then code = 0xFFE5 # capslock
                when 113 then code = 0xFFBF # f2
                when 112 then code = 0xFFBE # f1
                when 114 then code = 0xFFC0 # f3
                when 115 then code = 0xFFC1 # f4
                when 116 then code = 0xFFC2 # f5
                when 117 then code = 0xFFC3 # f6
                when 118 then code = 0xFFC4 # f7
                when 119 then code = 0xFFC5 # f8
                when 120 then code = 0xFFC6 # f9
                when 121 then code =  0xFFC7 # f10
                when 122 then code = 0xFFC8 # f11
                when 123 then code = 0xFFC9 # f12
                else
                    code = e.key.charCodeAt(0) #if not e.ctrlKey and not e.altKey
            #if ((keycode > 47 and keycode < 58) or (keycode > 64 and keycode < 91)  or (keycode > 95 and keycode < 112)  or (keycode > 185 and keycode < 193) or (keycode > 218 && keycode < 223))
            #    code = e.key.charCodeAt(0)
            #else 
            #    code = keycode
            e.preventDefault()
            return unless code
            if e.type is "keydown"
                me.sendKeyEvent code, 1
            else if e.type is "keyup"
                me.sendKeyEvent code, 0

        # mouse wheel event
        hamster = Hamster @canvas
        hamster.wheel (event, delta, deltaX, deltaY) ->
            p = getMousePos event.originalEvent
            if delta > 0
                me.sendPointEvent p.x, p.y, 8
                me.sendPointEvent p.x, p.y, 0
                return
            me.sendPointEvent p.x, p.y, 16
            me.sendPointEvent p.x, p.y, 0

    initCanvas: (w, h , d) ->
        me = @
        @depth = d
        @canvas.width = w
        @canvas.height = h
        @engine =
            w: w,
            h: h,
            depth: @depth,
            wasm: true
        @decoder.postMessage @engine
        @setScale @scale

    process: (msg) ->
        if not @socket
            return
        data = new Uint8Array msg.pixels
        #w = @buffer.width * @scale
        #h = @buffer.height * @scale
        ctx = @canvas.getContext "2d", { alpha: false }
        imgData = ctx.createImageData  msg.w, msg.h
        imgData.data.set data
        ctx.putImageData imgData, msg.x, msg.y
        

    setScale: (n) ->
        @scale = n
        @canvas.style.transformOrigin = '0 0'
        @canvas.style.transform = 'scale(' + n + ')'


    openSession: () ->
        me = @
        @socket.close() if @socket
        return unless @uri
        @socket = new WebSocket @uri
        @socket.binaryType = "arraybuffer"
        @socket.onopen = () ->
            console.log "socket opened"
            me.initConnection()

        @socket.onmessage =  (e) ->
            me.consume e
        @socket.onclose = () ->
            me.socket = null
            console.log "socket closed"

    initConnection: () ->
        vncserver = "192.168.1.20:5901"
        data = new Uint8Array vncserver.length + 3
        data[0] = 32 # bbp
        ###
        flag:
            0: raw data no compress
            1: jpeg no compress
            2: raw data compressed by zlib
            3: jpeg data compressed by zlib
        ###
        data[1] = 1
        data[2] = 40 # jpeg quality
        ## rate in milisecond

        data.set (new TextEncoder()).encode(vncserver), 3
        @socket.send(@buildCommand 0x01, data)

    sendPointEvent: (x, y, mask) ->
        return unless @socket
        data = new Uint8Array 5
        data[0] = x & 0xFF
        data[1] = x >> 8
        data[2] = y & 0xFF
        data[3] = y >> 8
        data[4] = mask
        @socket.send( @buildCommand 0x05, data )

    sendKeyEvent: (code, v) ->
        return unless @socket
        data = new Uint8Array 3
        data[0] = code & 0xFF
        data[1] = code >> 8
        data[2] = v
        console.log code, v
        @socket.send( @buildCommand 0x06, data )

    buildCommand: (hex, o) ->
        data = undefined
        switch typeof o
            when 'string'
                data = (new TextEncoder()).encode(o)
            when 'number'
                data = new Uint8Array [o]
            else
                data = o
        cmd = new Uint8Array data.length + 3
        cmd[0] = hex
        cmd[2] = data.length >> 8
        cmd[1] = data.length & 0x0F
        cmd.set data, 3
        #console.log "the command is", cmd.buffer
        return cmd.buffer
                

    consume: (e) ->
        data = new Uint8Array e.data
        cmd = data[0]
        switch  cmd
            when 0xFE #error
                data = data.subarray 1, data.length - 1
                dec = new TextDecoder("utf-8")
                console.log "Error", dec.decode(data)
            when 0x81
                console.log "Request for password"
                pass = "lxsan9"#"!x$@n9"
                @socket.send (@buildCommand 0x02, pass)
            when 0x82
                console.log "Request for login"
                user = "mrsang"
                pass = "!x$@n9"
                arr = new Uint8Array user.length + pass.length + 1
                arr.set (new TextEncoder()).encode(user), 0
                arr.set ['\0'], user.length
                arr.set (new TextEncoder()).encode(pass), user.length + 1
                @socket.send(@buildCommand 0x03, arr)
            when 0x83
                console.log "resize"
                w = data[1] | (data[2]<<8)
                h = data[3] | (data[4]<<8)
                depth = data[5]
                @initCanvas w, h, depth
                # status command for ack
                @socket.send(@buildCommand 0x04, 1)
            when 0x84
                # send data to web assembly for decoding
                @decoder.postMessage data.buffer, [data.buffer]
            else
                console.log cmd
        
WVNC.dependencies = [
    "/assets/scripts/hamster.js"
]

makeclass "WVNC", WVNC