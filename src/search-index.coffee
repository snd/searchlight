_ = require 'underscore'

module.exports =

    invert: (index) ->
        unless 'object' is typeof index
            throw new Error 'index argument must be an object'

        invertedIndex = {}

        _.each index, (searchTerms, id) ->
            unless Array.isArray searchTerms
                throw new Error 'each value in the index object must be an array of search terms'
            _.uniq(searchTerms).forEach (term) ->
                invertedIndex[term] ?= []
                invertedIndex[term].push id

        return invertedIndex
