redis = require 'redis'
_ = require 'underscore'

searchlight = require '../src/searchlight'

module.exports =

    'setUp': (done) ->
        this.config =
            redis: redis.createClient()

        this.config.redis.flushdb()

        done()

    'tearDown': (done) ->
        this.config.redis.quit (err) ->
            throw err if err?
            done()

    'the stored index is identical to the last set index': (test) ->
        config = this.config

        index =
            0: ['it', 'is', 'what', 'it', 'is']
            1: ['what', 'is', 'it']
            2: ['it', 'is', 'a', 'banana']

        invertedIndex = searchlight.index.invert index

        searchlight.redis.set config, invertedIndex, (err) ->
            throw err if err?

            searchlight.redis.get config, (err, storedIndex) ->
                throw err if err?
                test.deepEqual invertedIndex, storedIndex
                test.done()

    'empty empties the index ': (test) ->
        config = this.config

        index =
            0: ['it', 'is', 'what', 'it', 'is']
            1: ['what', 'is', 'it']
            2: ['it', 'is', 'a', 'banana']

        invertedIndex = searchlight.index.invert index

        searchlight.redis.set config, invertedIndex, (err) ->
            throw err if err?

            searchlight.redis.empty config, (err, results) ->
                throw err if err?

                searchlight.redis.get config, (err, storedIndex) ->
                    throw err if err?
                    test.deepEqual storedIndex, {}
                    test.done()

    'remove removes a document from the index': (test) ->
        config = this.config

        index =
            0: ['it', 'is', 'what', 'it', 'is']
            1: ['what', 'is', 'it']
            2: ['it', 'is', 'a', 'banana']

        invertedIndex = searchlight.index.invert index

        searchlight.redis.set config, invertedIndex, (err) ->
            throw err if err?

            searchlight.redis.remove config, [2], (err, results) ->
                throw err if err?

                searchlight.redis.get config, (err, storedIndex) ->
                    throw err if err?
                    test.deepEqual storedIndex,
                        is: ['0', '1']
                        it: ['0', '1']
                        what: ['0', '1']
                    test.done()

    'removing all documents empties the index': (test) ->
        config = this.config

        index =
            0: ['it', 'is', 'what', 'it', 'is']
            1: ['what', 'is', 'it']
            2: ['it', 'is', 'a', 'banana']

        invertedIndex = searchlight.index.invert index

        searchlight.redis.set config, invertedIndex, (err) ->
            throw err if err?

            searchlight.redis.remove config, [0, 1, 2], (err, results) ->
                throw err if err?

                searchlight.redis.get config, (err, storedIndex) ->
                    throw err if err?
                    test.deepEqual storedIndex, {}
                    test.done()

    'add extends the index': (test) ->
        config = this.config

        index =
            0: ['it', 'is', 'what', 'it', 'is']
            1: ['what', 'is', 'it']

        addition =
            2: ['it', 'is', 'a', 'banana']

        combined =
            0: ['it', 'is', 'what', 'it', 'is']
            1: ['what', 'is', 'it']
            2: ['it', 'is', 'a', 'banana']

        invertedIndex = searchlight.index.invert index

        searchlight.redis.set config, invertedIndex, (err) ->
            throw err if err?

            invertedAddition = searchlight.index.invert addition

            searchlight.redis.add config, invertedAddition, (err) ->
                throw err if err?

                searchlight.redis.get config, (err, storedIndex) ->
                    throw err if err?
                    test.deepEqual storedIndex, searchlight.index.invert combined
                    test.done()

    'set overwrites the index': (test) ->
        config = this.config

        index =
            2: ['it', 'is', 'a', 'banana']

        index2 =
            0: ['it', 'is', 'what', 'it', 'is']
            1: ['what', 'is', 'it']

        invertedIndex = searchlight.index.invert index
        invertedIndex2 = searchlight.index.invert index2

        searchlight.redis.set config, invertedIndex, (err) ->
            throw err if err?

            searchlight.redis.set config, invertedIndex2, (err) ->
                throw err if err?

                searchlight.redis.get config, (err, storedIndex) ->
                    throw err if err?
                    test.deepEqual invertedIndex2, storedIndex
                    test.done()
