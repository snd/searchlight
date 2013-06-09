_ = require 'underscore'

lua = require './lua'

defaultKeyPrefix = 'searchlight:'

checkConfig = (config) ->
    unless 'object' is typeof config
        throw new Error 'config argument must be an object'
    unless 'object' is typeof config.redis
        throw new Error 'config.redis argument must be an object'

module.exports =

    # query
    # -----

    # time complexity: O(m * n) worst case where m is the number of search terms
    # and n is the cardinality of the smallest set
    # search has no side effects.

    search: (config, searchTerms, cb) ->
        checkConfig config
        unless Array.isArray searchTerms
            throw new Error 'searchTerms argument must be an array'
        unless 'function' is typeof cb
            throw new Error 'cb argument must be a function'

        if searchTerms.length is 0
            process.nextTick ->
                cb null, []
            return

        prefix = config.keyPrefix or defaultKeyPrefix

        keys = searchTerms.map (term) -> prefix + term

        config.redis.sinter keys, cb

    # get has no side effects

    get: (config, cb) ->
        checkConfig config
        unless 'function' is typeof cb
            throw new Error 'cb argument must be a function'

        prefix = config.keyPrefix or defaultKeyPrefix

        config.redis.eval lua.get, 0, prefix, (err, result) ->
            return cb err if err?

            cb null, JSON.parse result

    # command
    # -------

    # time complexity: O(m) where m is the number of keys in the
    # invertedIndex object.
    # add is atomic.

    add: (config, invertedIndex, cb) ->
        checkConfig config
        unless 'object' is typeof invertedIndex
            throw new Error 'invertedIndex argument must be an object'
        unless 'function' is typeof cb
            throw new Error 'cb argument must be a function'

        prefix = config.keyPrefix or defaultKeyPrefix

        config.redis.eval lua.add, 0, prefix, JSON.stringify(invertedIndex), cb

    # same as empty and then add but in one atomic operation.
    # time complexity: O(n + m) where n is the number of keys in the database
    # and m is the number of keys in the invertedIndex object.

    set: (config, invertedIndex, cb) ->
        checkConfig config
        unless 'object' is typeof invertedIndex
            throw new Error 'invertedIndex argument must be an object'
        unless 'function' is typeof cb
            throw new Error 'cb argument must be a function'

        prefix = config.keyPrefix or defaultKeyPrefix

        config.redis.eval lua.set, 0, prefix, JSON.stringify(invertedIndex), cb

    # time complexity: O(n) where n is the number of keys in the database.
    # delete is atomic.

    remove: (config, ids, cb) ->
        checkConfig config
        unless Array.isArray ids
            throw new Error 'ids argument must be an array'
        unless 'function' is typeof cb
            throw new Error 'cb argument must be a function'

        prefix = config.keyPrefix or defaultKeyPrefix

        config.redis.eval lua.remove, 0, prefix, JSON.stringify(ids), cb

    # empty the entire search index
    # returns the count of cleared keys
    # time complexity: O(n) where n is the number of keys in the database.
    # clear is atomic.

    empty: (config, cb) ->
        checkConfig config
        unless 'function' is typeof cb
            throw new Error 'cb argument must be a function'

        prefix = config.keyPrefix or defaultKeyPrefix

        config.redis.eval lua.empty, 0, prefix, cb
