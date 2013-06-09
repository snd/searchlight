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

        # make lowercase
        # replace umlauts
        # split into words (split by whitespace)
        # remove non alphanumeric chars
        # remove empty words
        # remove duplicates

        lowerCase = string.toLowerCase().replace /[\-_]/g, ' '

        words = _s.words module.exports.replaceUmlauts lowerCase

        processed = words.map module.exports.removeNonAlphanumeric

        _.uniq processed.filter (word) -> word isnt ''
