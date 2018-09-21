#zlib library
importScripts('wvnc_asm.js')
#zlib library
importScripts('pako.min.js')
# jpeg library
importScripts('jpeg-decoder.js')
api = {}
engine = undefined
#frame_buffer = undefined
Module.onRuntimeInitialized = () ->
    api =
    {
        createBuffer: Module.cwrap('create_buffer', 'number', ['number', 'number']),
        destroyBuffer: Module.cwrap('destroy_buffer', '', ['number']),
        updateBuffer: Module.cwrap("update", 'number', ['number', 'number', 'number', 'number', 'number', 'number']),
        decodeBuffer: Module.cwrap("decode",'number', ['number', 'number', 'number','number'] )
    }

pixelValue = (value, depth) ->
    pixel =
        r: 255
        g: 255
        b: 255
        a: 255
    #console.log("len is" + arr.length)
    if depth is 24 or depth is 32
        pixel.r = value & 0xFF
        pixel.g = (value >> 8) & 0xFF
        pixel.b = (value >> 16) & 0xFF
    else if depth is 16
        pixel.r = (value & 0x1F) * (255 / 31)
        pixel.g = ((value >> 5) & 0x3F) * (255 / 63)
        pixel.b = ((value >> 11) & 0x1F) * (255 / 31)
    #console.log pixel
    return pixel

getImageData = (d) ->
    return d.pixels if engine.depth is 32
    step = engine.depth / 8
    npixels = d.pixels.length / step
    data = new Uint8ClampedArray d.w * d.h * 4
    for i in [0..npixels - 1]
        value = 0
        value = value | d.pixels[i * step + j] << (j * 8) for j in [0..step - 1]
        pixel = pixelValue value, engine.depth
        data[i * 4] = pixel.r
        data[i * 4 + 1] = pixel.g
        data[i * 4 + 2] = pixel.b
        data[i * 4 + 3] = pixel.a
    return data

decodeRaw = (d) ->
    d.pixels = getImageData d
    return d

decodeJPEG = (d) ->
    raw = decode d.pixels, { useTArray: true, colorTransform: true }
    d.pixels = raw.data
    return d
    ###
    blob = new Blob [d.pixels], { type: "image/jpeg" }
    reader = new FileReader()
    reader.onloadend = () ->
        d.pixels = reader.result
        postMessage d
    reader.readAsDataURL blob
    ###

update = (msg) ->
    d = {}
    #ecconho "native"
    data = new Uint8Array msg
    d.x = data[1] | (data[2]<<8)
    d.y = data[3] | (data[4]<<8)
    d.w = data[5] | (data[6]<<8)
    d.h = data[7] | (data[8]<<8)
    d.flag = data[9]
    d.pixels = data.subarray 10
    # the zlib is slower than expected
    switch d.flag
        when 0x0 # raw data
            raw = decodeRaw d
        when 0x1 # jpeg data
            raw = decodeJPEG(d)
        when 0x2 # raw compress in zlib format
            d.pixels =  pako.inflate(d.pixels)
            raw = decodeRaw d
        when 0x3 # jpeg compress in zlib format
            d.pixels = pako.inflate(d.pixels)
            raw = decodeJPEG(d)
    return unless raw
    raw.pixels = raw.pixels.buffer
    # fill the rectangle
    postMessage raw, [raw.pixels]

wasm_update = (msg) ->
    datain = new Uint8Array msg
    x = datain[1] | (datain[2] << 8)
    y = datain[3] | (datain[4] << 8)
    w = datain[5] | (datain[6] << 8)
    h = datain[7] | (datain[8] << 8)
    flag = datain[9]
    p = api.createBuffer datain.length
    Module.HEAP8.set datain, p
    size = w * h * 4
    po = api.decodeBuffer p, datain.length, engine.depth, size
    #api.updateBuffer frame_buffer, p, datain.length, engine.w, engine.h, engine.depth
    # create buffer array and send back to main
    dataout = new Uint8Array Module.HEAP8.buffer, po, size
    # console.log dataout
    msg = {}
    tmp = new Uint8Array size
    tmp.set dataout, 0
    msg.pixels = tmp.buffer
    msg.x = x
    msg.y = y
    msg.w = w
    msg.h = h
    postMessage msg, [msg.pixels]
    api.destroyBuffer p
    if flag isnt 0x0 or engine.depth isnt 32
        api.destroyBuffer po

onmessage = (e) ->
    if e.data.depth
        engine = e.data
        #api.destroyBuffer frame_buffer if frame_buffer
        #frame_buffer = api.createBuffer engine.w * engine.h * 4
    #else if e.data.cleanup
    #    api.destroyBuffer frame_buffer if frame_buffer
    else
        return wasm_update e.data if engine.wasm
        update e.data