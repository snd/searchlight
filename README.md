# searchlight

[![Build Status](https://travis-ci.org/snd/searchlight.png)](https://travis-ci.org/snd/searchlight)

searchlight is a simple redis search index for nodejs

### install

```
npm install searchlight
```

### use

```coffeescript
redis = require 'redis'
Searchlight = require 'searchlight'

client = redis.createClient()
client.select 10

searchlight = new Searchlight client

documentIdTextMap =
    1: "The one thing we can never get enough of is love. And the one thing we never give enough is love."
    2: "An artist is always alone - if he is an artist. No, what the artist needs is loneliness."
    3: "The aim of life is to live, and to live means to be aware, joyously, drunkenly, serenely, divinely aware."
    4: "Confusion is a word we have invented for an order which is not understood."

searchlight.rebuild documentIdTextMap, (err) ->
    throw err if err?

    searchlight.search 'art', (err, documentIds) ->
        throw err if err?
        console.log documentIds # => ['2']

        searchlight.search 'aim of life', (err, documentIds) ->
            throw err if err?
            console.log documentIds # => ['3']

            searchlight.search 'we', (err, documentIds) ->
                throw err if err?
                console.log documentIds # => ['1', '4']

                client.quit()
```

### license: MIT
