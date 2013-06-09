local prefix = ARGV[1]
local ids = cjson.decode(ARGV[2])

local keys = redis.call("KEYS", prefix .. "*")

for i = 1, #keys do
    redis.call("SREM", keys[i], unpack(ids))
end
return #keys
