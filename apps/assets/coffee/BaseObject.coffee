# private function
require = (lib) ->
    return new Promise (r, e) ->
        return r() if window.libraries[lib]
        $.getScript window.myuri + lib
            .done (d) ->
                window.libraries[lib] = true
                r()
            .fail (m, s) ->
                e(m, s)

class BaseObject
    constructor: (@name) ->

    ready: () ->
        me = @
        return new Promise (r, e) ->
            me.resolveDep()
                .then () -> r()
                .catch (m, s) -> e(m, s)

    resolveDep: () ->
        me = @
        return new Promise (r, e) ->
            dep = window.classes[me.name].dependencies
            r() unless dep

            fn = (l, i) ->
                return r() if i >= dep.length
                require(l[i])
                    .then () -> fn(l, i + 1)
                    .catch (m, s) -> e(m, s)
            fn dep, 0

makeclass "BaseObject", BaseObject
            