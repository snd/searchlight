fs = require 'fs'

module.exports =

    rebuild: fs.readFileSync(__dirname + '/lua/rebuild.lua', 'utf-8')
    get: fs.readFileSync(__dirname + '/lua/get.lua', 'utf-8')
    merge: fs.readFileSync(__dirname + '/lua/merge.lua', 'utf-8')
    removeAndMerge: fs.readFileSync(__dirname + '/lua/remove-and-merge.lua', 'utf-8')
