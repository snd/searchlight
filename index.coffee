common = require './common'

searchlight =
    rebuild: (documentIdTextMap, cb) ->
        multi = @redisClient.multi()
        multi.flushdb()
        index = common.makeIndex @options.minPrefixLength, documentIdTextMap
        for token, ids of index
            do (token, ids) -> multi.sadd token, ids
        multi.exec cb

    search: (searchstring, cb) ->
        tokens = common.tokenize searchstring
        return cb null, [] if tokens.length is 0
        @redisClient.sinter tokens, cb

module.exports = (redisClient, options) ->
    s = Object.create searchlight
    s.redisClient = redisClient
    s.options = options || {}
    s.options.minPrefixLength ?= 3
    s

