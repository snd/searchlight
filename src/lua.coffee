module.exports =

    set:

        """
            local prefix = ARGV[1]
            local index = cjson.decode(ARGV[2])

            local keys = redis.call("KEYS", prefix .. "*")

            for i = 1, #keys do
                redis.call("DEL", keys[i])
            end

            for term, ids in pairs(index) do
                redis.call("SADD", prefix .. term, unpack(ids))
            end
        """

    get:

        """
            local prefix = ARGV[1]

            local keys = redis.call("KEYS", prefix .. "*")

            local index = {}

            for i = 1, #keys do
                local key = string.sub(keys[i], #prefix + 1)
                index[key] = redis.call("SMEMBERS", keys[i])
            end

            return cjson.encode(index)
        """

    add:

        """
            local prefix = ARGV[1]
            local index = cjson.decode(ARGV[2])

            for term, ids in pairs(index) do
                redis.call("SADD", prefix .. term, unpack(ids))
            end
        """

    empty:

        """
            local prefix = ARGV[1]

            local keys = redis.call("KEYS", prefix .. "*")

            for i = 1, #keys do
                redis.call("DEL", keys[i])
            end
            return #keys
        """

    remove:

        """
            local prefix = ARGV[1]
            local ids = cjson.decode(ARGV[2])

            local keys = redis.call("KEYS", prefix .. "*")

            for i = 1, #keys do
                redis.call("SREM", keys[i], unpack(ids))
            end
            return #keys
        """
