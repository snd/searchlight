var searchlight = require('searchlight');
var redis = require('redis');

var documents = {
    1: "Now it happened that the king of that land held a feast, which was to\n" +
       "last three days; and out of those who came to it his son was to choose\n" +
       "a bride for himself. Ashputtel's two sisters were asked to come; so they\n" +
       "called her up, and said, 'Now, comb our hair, brush our shoes, and tie\n" +
       "our sashes for us, for we are going to dance at the king's feast.'",
    2: "Rapunzel grew into the most beautiful child under the sun. When she was\n" +
       "twelve years old, the enchantress shut her into a tower, which lay in\n" +
       "a forest, and had neither stairs nor door, but quite at the top was a\n" +
       "little window.",
    3: "The two children were so fond of one another that they always held each\n" +
       "other by the hand when they went out together, and when Snow-white said:\n" +
       "'We will not leave each other,' Rose-red answered: 'Never so long as we\n" +
       "live,' and their mother would add: 'What one has she must share with the\n" +
       "other.'"
};

console.log('documents:\n', documents);

var index = {};

for (id in documents) {
    index[id] = searchlight.string.tokenize(documents[id]);
};

console.log('index:\n', index);

var invertedIndex = searchlight.index.invert(index);

console.log('invertedIndex:\n', invertedIndex);

var searchConfig = {
    redis: redis.createClient()
};

searchlight.redis.set(searchConfig, invertedIndex, function(err) {
    if (err) throw err;

    var searchText = 'snow-white rose-red';

    console.log('searchText:\n', searchText);

    var searchTerms = searchlight.string.tokenize(searchText);

    console.log('searchTerms:\n', searchTerms);

    searchlight.redis.search(searchConfig, searchTerms, function(err, results) {
        if (err) throw err;

        console.log('results:\n', results);

        searchConfig.redis.quit();
    });
});
