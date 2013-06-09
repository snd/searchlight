string = require '../src/string'

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
