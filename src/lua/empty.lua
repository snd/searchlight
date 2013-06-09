local prefix = ARGV[1]

local keys = redis.call("KEYS", prefix .. "*")

for i = 1, #keys do
    redis.call("DEL", keys[i])
end
return #keys
