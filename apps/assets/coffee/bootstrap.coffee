window.classes = {}
window.libraries = {}
window.myuri = "/"
window.mobilecheck = () ->
    if navigator.userAgent.match(/Android/i) or navigator.userAgent.match(/webOS/i) or navigator.userAgent.match(/iPhone/i) or navigator.userAgent.match(/iPad/i) or navigator.userAgent.match(/iPod/i) or navigator.userAgent.match(/BlackBerry/i) or navigator.userAgent.match(/Windows Phone/i)
        return true
    return false

window.makeclass = (n, o) -> window.classes[n] = o

window.require = (lib) ->
    return new Promise (r, e) ->
        return r() if window.libraries[lib]
        $.getScript window.myuri + lib
            .done (d) ->
                window.libraries[lib] = true
                r()
            .fail (m, s) ->
                e(m, s)
