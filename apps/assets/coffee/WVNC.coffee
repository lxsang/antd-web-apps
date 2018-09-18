class WVNC extends window.classes.BaseObject
    constructor: (@args) ->
        super "WVNC"
        @socket = undefined
        @uri = undefined
        @uri = @args[0] if @args and @args.length > 0
        @canvas = undefined
        @canvas = ($ @args[1])[0] if @args and @args.length > 1
        @buffer = $("<canvas>")[0]
        @counter = 0
    init: () ->
        me = @
        @ready()
            .then () ->
                $("#stop").click (e) -> me.socket.close() if me.socket
                $("#connect").click (e) ->
                    me.counter  = 0
                    me.openSession()
                ($ me.canvas).css "cursor","none"
                ($ me.canvas).mousemove (e) ->
                    rect = me.canvas.getBoundingClientRect()
                    x = Math.floor(e.clientX - rect.left)
                    y = Math.floor(e.clientY - rect.top)
                    me.sendPointEvent x, y, 0
            .catch (m, s) ->
                console.error(m, s)

    initCanvas: (w, h , d) ->
        me = @
        @depth = d
        @buffer.width = w
        @buffer.height = h
        ctx = @buffer.getContext('2d')
        data = ctx.createImageData w, h
        ctx.putImageData data, 0, 0
        #@callback = () ->
        #    me.draw()
        @draw()

    updateCanvas: (x, y, w, h, pixels) ->
        ctx = @buffer.getContext('2d')
        ctx.globalAlpha = 1.0
        imgData = ctx.createImageData w, h
        imgData.data.set @getCanvasImageData(pixels, w, h)
        ctx.putImageData imgData, x, y
        @counter = @counter + 1
        @draw()
        #if @counter > 50
        #    @draw()
        #    @couter = 0
    
    getCanvasImageData: (pixels, w, h) ->
        return pixels if @depth is 32
        step = @depth / 8
        npixels = pixels.length / step
        data = new Uint8ClampedArray w * h * 4
        for i in [0..npixels - 1]
            value = 0
            value = value | pixels[i * step + j] << (j * 8) for j in [0..step - 1]
            pixel = @pixelValue value
            data[i * 4] = pixel.r
            data[i * 4 + 1] = pixel.g
            data[i * 4 + 2] = pixel.b
            data[i * 4 + 3] = pixel.a
        return data

    draw: () ->
        if not @socket
            return
        scale = 1.0
        w = @buffer.width * scale
        h = @buffer.height * scale
        @canvas.width = w
        @canvas.height = h
        ctx = @canvas.getContext "2d"
        ctx.save()
        ctx.scale scale, scale
        ctx.clearRect 0, 0, w, h
        ctx.drawImage @buffer, 0, 0
        ctx.restore()

    pixelValue: (value) ->
        pixel =
            r: 255
            g: 255
            b: 255
            a: 255
        #console.log("len is" + arr.length)
        if @depth is 24 or @depth is 32
            pixel.r = value & 0xFF
            pixel.g = (value >> 8) & 0xFF
            pixel.b = (value >> 16) & 0xFF
        else if @depth is 16
            pixel.r = (value & 0x1F) * (255 / 31)
            pixel.g = ((value >> 5) & 0x3F) * (255 / 63)
            pixel.b = ((value >> 11) & 0x1F) * (255 / 31)
        #console.log pixel
        return pixel

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
        vncserver = "192.168.1.8:5900"
        @socket.send(@buildCommand 0x01, vncserver)

    sendPointEvent: (x,y,mask) ->
        return unless @socket
        data = new Uint8Array 5
        data[0] = x & 0xFF
        data[1] = x >> 8
        data[2] = y & 0xFF
        data[3] = y >> 8
        data[4] = 0 
        #console.log x,y
        @socket.send( @buildCommand 0x05, data )

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
                pass = "sang"
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
                #console.log "update"
                x = data[1] | (data[2]<<8)
                y = data[3] | (data[4]<<8)
                w = data[5] | (data[6]<<8)
                h = data[7] | (data[8]<<8)
                zlib = data[9]
                #console.log zlib
                pixels = data.subarray 10
                # the zlib is slower than expected
                pixels =  pako.inflate(pixels) if zlib is 1
                @updateCanvas x, y, w, h, pixels
                # ack
                #@socket.send(@buildCommand 0x04, 1)
            else
                console.log cmd
        
WVNC.dependencies = [
    "/assets/scripts/pako.min.js"
]

makeclass "WVNC", WVNC