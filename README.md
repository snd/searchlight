# searchlight

simple redis search index

## Installation

```
npm install searchlight
```

## Example

```coffeescript
redis = require 'redis'
Searchlight = require './lib/searchlight'

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

## API

- `constructor(redisClient, [options])`
    - Number `options.minPrefixLength`
- `rebuild(documentIdTextMap)`
- `search(searchstring)`
    - String `searchstring`

## License: MIT
