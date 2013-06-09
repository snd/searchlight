searchlight = require '../src/searchlight'

module.exports =

    'invert':

        'for an empty index': (test) ->
            index = searchlight.index.invert {}

            test.deepEqual index, {}

            test.done()

        'for one document with one word': (test) ->

            index = searchlight.index.invert
                1: ['du']

            test.deepEqual index,
                du: [1]

            test.done()

        'for one document with two words': (test) ->

            index = searchlight.index.invert
                1: ['hoch', 'tief']

            test.deepEqual index,
                hoch: [1]
                tief: [1]

            test.done()
