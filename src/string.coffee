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

    removeSpecialChars: (string) ->
        string.replace /[^a-z0-9 ]/g, ''

    inits: (string, minPrefixLen = 1) ->
        throw new Error 'minPrefixLen must be > 0' if minPrefixLen < 1
        return [] if string is '' or minPrefixLen > string.length
        [minPrefixLen..string.length].map (i) -> string.substr 0, i

    normalize: (string) ->
        string = string.toLowerCase()
        string = string.trim()
        string = module.exports.replaceUmlauts string
        module.exports.removeSpecialChars string

    # split words on whitespace or - or _
    words: (string) ->
        _s.words string.replace /[\-_]/g, ' '

    uniqueNonEmptyWords: (words) ->
        _.uniq words.filter (word) -> word isnt ''
