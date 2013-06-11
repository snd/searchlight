var searchlight = require('searchlight');
var redis = require('redis');

// NOTE:
// this example uses Q (https://github.com/kriskowal/q) to organize async code.
// you should too!

var Q = require('q');

var movies = [
    {
        id: 1,
        title: "Being John Malkovich",
        genre: "Drama, Science Fiction, Fantasy, Comedy",
        cast: "John Cusack, Cameron Diaz, John Malkovich"
    },
    {
        id: 2,
        title: "Death of a Salesman",
        genre: "Drama",
        cast: "Dustin Hoffman, John Malkovich"
    },
    {
        id: 3,
        title: "The Graduate",
        genre: "Drama, Romance, Classics, Comedy",
        cast: "Dustin Hoffman, Anne Bancroft, Katharine Ross"
    }
];

console.log('movies:\n', movies);

// forward indexes
// ---------------

var forwardTitleIndex = {};

movies.forEach(function(movie) {
    var searchTerms = [];
    searchlight.string.tokenize(movie.title).forEach(function(searchTerm) {
        searchTerms = searchTerms.concat(searchlight.string.inits(searchTerm, 3));
    });
    forwardTitleIndex[movie.id] = searchTerms;
});

console.log('forwardTitleIndex:\n', forwardTitleIndex);

var forwardGenreIndex = {};

movies.forEach(function(movie) {
    forwardGenreIndex[movie.id] =
        movie.genre.split(',').map(searchlight.string.normalize);
});

console.log('forwardGenreIndex:\n', forwardGenreIndex);

var forwardCastIndex = {};

movies.forEach(function(movie) {
    forwardCastIndex[movie.id] =
        movie.cast.split(',').map(searchlight.string.normalize);
});

console.log('forwardCastIndex:\n', forwardCastIndex);

// inverted indexes
// ----------------

var invertedTitleIndex = searchlight.index.invert(forwardTitleIndex);

console.log('invertedTitleIndex:\n', invertedTitleIndex);

var invertedGenreIndex = searchlight.index.invert(forwardGenreIndex);

console.log('invertedGenreIndex:\n', invertedGenreIndex);

var invertedCastIndex = searchlight.index.invert(forwardCastIndex);

console.log('invertedCastIndex:\n', invertedCastIndex);


// rebuilding indexes
// ------------------

var redisClient = redis.createClient();

var titleConfig = {
    redis: redisClient,
    keyPrefix: 'searchlight:title:'
};

var genreConfig = {
    redis: redisClient,
    keyPrefix: 'searchlight:genre:'
};

var castConfig = {
    redis: redisClient,
    keyPrefix: 'searchlight:cast:'
};

var rebuildIndexes = function() {
    return Q.all([
        Q.nfcall(searchlight.redis.rebuild, titleConfig, invertedTitleIndex),
        Q.nfcall(searchlight.redis.rebuild, genreConfig, invertedGenreIndex),
        Q.nfcall(searchlight.redis.rebuild, castConfig, invertedCastIndex)
    ]);
};

var search = function(string) {
    return Q.all([
        Q.nfcall(
            searchlight.redis.search,
            titleConfig,
            searchlight.string.tokenize(string)
        ),
        Q.nfcall(
            searchlight.redis.search,
            genreConfig,
            [searchlight.string.normalize(string)]
        ),
        Q.nfcall(
            searchlight.redis.search,
            castConfig,
            [searchlight.string.normalize(string)]
        )
    ]);
};

displayResults = function(string) {
    return search(string).then(function(movieIds) {
        console.log('results for "' + string + '"');
        console.log('title:', movieIds[0]);
        console.log('genre:', movieIds[1]);
        console.log('cast:', movieIds[2]);
    });
};

rebuildIndexes().then(function() {
    Q.all([
        displayResults('john malkovich'),
        displayResults('comedy'),
        displayResults('dustin hoffman'),
        displayResults('sales'),
    ]).done(function() {
        redisClient.quit();
    });
});
