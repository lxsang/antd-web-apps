class WVNC extends window.classes.BaseObject
    constructor: (@args) ->
        super "WVNC"
        @socket = undefined
        @uri = undefined
        @uri = @args[0] if @args and @args.length > 0

    init: () ->
        me = @
        @ready()
            .then () ->
                me.openSession()
            .catch (m, s) ->
                console.error(m, s)

    openSession: () ->
        me = @
        $("#stop").click (e) -> me.socket.close() if me.socket
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
        vncserver = "mrsang.local"
        @socket.send(@buildCommand 0x01, vncserver)

    buildCommand: (hex, o) ->
        data = undefined
        switch typeof o
            when 'string'
                data = (new TextEncoder()).encode(o)
            else
                data = o
        cmd = new Uint8Array data.length + 3
        cmd[0] = hex
        cmd[2] = data.length >> 8
        cmd[1] = data.length & 0x0F
        cmd.set data, 3
        console.log "the command is", cmd.buffer
        return cmd.buffer
                

    consume: (e) ->
        data = new Uint8Array e.data
        cmd = data[0]
        switch  cmd
            when 0xFE #error
                data = data.subarray 1, data.length - 1
                dec = new TextDecoder("utf-8")
                console.log "Error",dec.decode(data)
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
                console.log w,h,depth
            when 0x84
                console.log "update"
                x = data[1] | (data[2]<<8)
                y = data[3] | (data[4]<<8)
                w = data[5] | (data[6]<<8)
                h = data[7] | (data[8]<<8)
                pixels = data.subarray 9, data.length - 1
                console.log x,y,w,h, pixels.length
            else
                console.log cmd
        #@socket.close()
        

WVNC.dependencies = [
]

makeclass "WVNC", WVNC