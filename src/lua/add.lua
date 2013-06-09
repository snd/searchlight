local prefix = ARGV[1]
local index = cjson.decode(ARGV[2])

for term, ids in pairs(index) do
    redis.call("SADD", prefix .. term, unpack(ids))
end
