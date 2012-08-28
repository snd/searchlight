string = require '../lib/string'

module.exports =

    'replaceUmlauts':

        'string without umlauts passes unchanged': (test) ->
            test.equals 'bar foo blub', string.replaceUmlauts 'bar foo blub'
            test.done()

        'lowercase umlauts are replaced': (test) ->
            test.equals 'Baer Moerder Muehle Buehne',
                string.replaceUmlauts 'Bär Mörder Mühle Bühne'
            test.done()

        'uppercase umlauts are replaced': (test) ->
            test.equals 'aehre oesterreich ueber',
                string.replaceUmlauts 'Ähre Österreich Über'
            test.done()

    'tokenize':

        'empty string has no tokens': (test) ->
            test.deepEqual [], string.tokenize ''
            test.done()

        'single word is tokenized correctly': (test) ->
            test.deepEqual ['traenen'], string.tokenize '   ,Tränen!   '
            test.done()

        'digits are not ignored': (test) ->
            test.deepEqual ['360', 'grad'], string.tokenize '   360  Grad   '
            test.done()

        'complex string is tokenized correctly': (test) ->
            input = "Blut, Schweiß und Tränen gibt’s umsonst. Alles andere kostet Geld. Zum Beispiel Kostüme, Requisiten, Beleuchtung, Bühnenbild, Plakate und und und. Dafür sammeln wir – damit wir dem Publikum am 9. und 10. Juni 2012 mit dem Tanzstück \"Gräfin Báthory\" zwei unvergessliche Abende bereiten können."
            expected = 'blut schwei und traenen gibts umsonst alles andere kostet geld zum beispiel kostueme requisiten beleuchtung buehnenbild plakate dafuer sammeln wir damit dem publikum am 9 10 juni 2012 mit tanzstueck graefin bthory zwei unvergessliche abende bereiten koennen'.split ' '
            test.deepEqual expected, string.tokenize input
            test.done()

    'inits':

        'empty string has no inits': (test) ->
            test.deepEqual [], string.inits ''
            test.done()

        'single char has only himself as init': (test) ->
            test.deepEqual ['a'], string.inits 'a'
            test.done()

        'long string has many inits': (test) ->
            test.deepEqual ['a', 'ab', 'abc', 'abcd', 'abcde'], string.inits 'abcde'
            test.done()

        'minPrefixLen has effect': (test) ->
            test.deepEqual ['abc', 'abcd', 'abcde'], string.inits 'abcde', 3
            test.done()

        'return only string if minPrefixLen equals length of string': (test) ->
            test.deepEqual ['abcde'], string.inits 'abcde', 5
            test.done()

        'minPrefixLen < 1 is not allowed': (test) ->
            test.throws -> string.inits 'abcde', 0
            test.done()

        'if minPrefixLen is larger than string return empty array': (test) ->
            test.deepEqual [], string.inits 'abcde', 6
            test.done()

    'makeIndex':

        'for one document with one word shorter than minPrefixLength': (test) ->

            index = string.makeIndex 3,
                1: 'du'

            test.deepEqual index,
                du: [1]

            test.done()

        'for one document with one word': (test) ->

            index = string.makeIndex 3,
                1: 'hochzeit'

            test.deepEqual index,
                hoc: [1]
                hoch: [1]
                hochz: [1]
                hochze: [1]
                hochzei: [1]
                hochzeit: [1]

            test.done()

        'for one document with two words': (test) ->

            index = string.makeIndex 3,
                1: 'hoch tief'

            test.deepEqual index,
                hoc: [1]
                hoch: [1]
                tie: [1]
                tief: [1]

            test.done()

        'complex': (test) ->

            index = string.makeIndex 3,
                1: 'hochzeit tiefzeit'
                abcd: 'tief, hoch'
                3678: 'zeit, tie äre'

            test.deepEqual index,
                hoc: [1, 'abcd']
                hoch: [1, 'abcd']
                hochz: [1]
                hochze: [1]
                hochzei: [1]
                hochzeit: [1]
                tie: [1, 3678, 'abcd']
                tief: [1, 'abcd']
                tiefz: [1]
                tiefze: [1]
                tiefzei: [1]
                tiefzeit: [1]
                zei: [3678]
                zeit: [3678]
                aer: [3678]
                aere: [3678]

            test.done()
