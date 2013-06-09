local prefix = ARGV[1]
local index = cjson.decode(ARGV[2])

local keys = redis.call("KEYS", prefix .. "*")

for i = 1, #keys do
    redis.call("DEL", keys[i])
end

for term, ids in pairs(index) do
    redis.call("SADD", prefix .. term, unpack(ids))
end
