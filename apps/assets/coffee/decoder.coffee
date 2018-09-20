#zlib library
importScripts('pako.min.js')
# jpeg library
importScripts('jpeg-decoder.js')
resolution = undefined
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
    return d.pixels if resolution.depth is 32
    step = resolution.depth / 8
    npixels = d.pixels.length / step
    data = new Uint8ClampedArray d.w * d.h * 4
    for i in [0..npixels - 1]
        value = 0
        value = value | d.pixels[i * step + j] << (j * 8) for j in [0..step - 1]
        pixel = pixelValue value, resolution.depth
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

onmessage = (e) ->
    return resolution = e.data if e.data.depth
    update e.data