fs = require 'fs'

module.exports =

    set: fs.readFileSync(__dirname + '/lua/set.lua', 'utf-8')
    get: fs.readFileSync(__dirname + '/lua/get.lua', 'utf-8')
    add: fs.readFileSync(__dirname + '/lua/add.lua', 'utf-8')
    empty: fs.readFileSync(__dirname + '/lua/empty.lua', 'utf-8')
    remove: fs.readFileSync(__dirname + '/lua/remove.lua', 'utf-8')
