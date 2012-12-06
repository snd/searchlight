_ = require 'underscore'
_s = require 'underscore.string'

umlautReplacementMap =
    ae: /[äÄ]/g
    oe: /[öÖ]/g
    ue: /[üÜ]/g

module.exports =

    replaceUmlauts: (string) ->
        replaced = string
        for replacement, umlaut of umlautReplacementMap
            do (replacement, umlaut) ->
                replaced = replaced.replace umlaut, replacement
        replaced

    tokenize: (string) ->

        # make lowercase
        # replace umlauts
        # split into words (split by whitespace)

        words = _s.words module.exports.replaceUmlauts string.toLowerCase()

        # remove everything except for lowercase chars from each word

        processed = words.map (word) -> word.replace /[^a-z0-9]/g, ''

        # remove empty words
        # remove duplicates

        _.uniq processed.filter (word) -> word isnt ''

    inits: (string, minPrefixLen = 1) ->
        throw new Error 'minPrefixLen must be > 0' if minPrefixLen < 1
        return [] if string is '' or minPrefixLen > string.length
        [minPrefixLen..string.length].map (i) -> string.substr 0, i

    makeIndex: (minPrefixLength, documentIdTextMap) ->
        index = {}

        push = (word, id) ->
            index[word] ?= []
            index[word].push id

        _.each documentIdTextMap, (string, documentId) ->
            module.exports.tokenize(string).forEach (word) ->
                if word.length <= minPrefixLength then push word, documentId
                else module.exports.inits(word, minPrefixLength).forEach (init) ->
                    push init, documentId
        index
