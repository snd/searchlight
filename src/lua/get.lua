local prefix = ARGV[1]

local keys = redis.call("KEYS", prefix .. "*")

local index = {}

for i = 1, #keys do
    local key = string.sub(keys[i], #prefix + 1)
    index[key] = redis.call("SMEMBERS", keys[i])
end

return cjson.encode(index)
