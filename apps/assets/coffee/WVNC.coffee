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
        vncserver = "localhost:5901"
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
        console.log e
WVNC.dependencies = [
]

makeclass "WVNC", WVNC