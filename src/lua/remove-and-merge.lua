local prefix = ARGV[1]
local ids_to_be_removed = cjson.decode(ARGV[2])
local index_to_be_merged = cjson.decode(ARGV[3])

if #ids_to_be_removed>0 then
    local keys = redis.call("KEYS", prefix .. "*")

    for i = 1, #keys do
        redis.call("SREM", keys[i], unpack(ids_to_be_removed))
    end
end

for term, ids in pairs(index_to_be_merged) do
    redis.call("SADD", prefix .. term, unpack(ids))
end
