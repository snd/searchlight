_ = require 'underscore'
_s = require 'underscore.string'

module.exports =

    # string manipulation
    # -------------------

    umlautReplacementMap:
        ae: /[äÄ]/g
        oe: /[öÖ]/g
        ue: /[üÜ]/g

    replaceUmlauts: (string) ->
        replaced = string
        for replacement, umlaut of module.exports.umlautReplacementMap
            do (replacement, umlaut) ->
                replaced = replaced.replace umlaut, replacement
        return replaced

    removeNonAlphanumeric: (string) ->
        string.replace /[^a-z0-9]/g, ''

    inits: (string, minPrefixLen = 1) ->
        throw new Error 'minPrefixLen must be > 0' if minPrefixLen < 1
        return [] if string is '' or minPrefixLen > string.length
        [minPrefixLen..string.length].map (i) -> string.substr 0, i

    tokenize: (string) ->

        string = string.toLowerCase()

        # replace - and _ by whitespace to later break words on it
        string = string.replace /[\-_]/g, ' '

        string = module.exports.replaceUmlauts string

        # split into words
        words = _s.words string

        words = words.map module.exports.removeNonAlphanumeric

        # remove empty words
        words = words.filter (word) -> word isnt ''

        # remove duplicates
        _.uniq words
