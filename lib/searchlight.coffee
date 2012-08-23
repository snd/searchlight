string = require './string'

module.exports = class

    constructor: (@redisClient, @options = {}) ->
        @options.minPrefixLength ?= 3

    rebuild: (documentIdTextMap, cb) ->
        multi = @redisClient.multi()
        multi.flushdb()
        index = string.makeIndex @options.minPrefixLength, documentIdTextMap
        for token, ids of index
            do (token, ids) -> multi.sadd token, ids
        multi.exec cb

    search: (searchstring, cb) ->
        tokens = string.tokenize searchstring
        return cb null, [] if tokens.length is 0
        @redisClient.sinter tokens, cb
