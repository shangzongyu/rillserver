-------------------------------------------------------------------------------
-- Copyright(C)   machine stdio                                              --
-- Author:        donney                                                     --
-- Email:         donney_luck@sina.cn                                        --
-- Date:          2022-02-11                                                 --
-- Description:   redisdb interface                                          --
-- Modification:  null                                                       --
-------------------------------------------------------------------------------

local redis = require("skynet.db.redis")
local redisdb = {}

function redisdb:start(conf)
  local db = redis.connect(conf)
  local o = {db = db}
  setmetatable(o, redisdb)
  return o
end

function redisdb:delete(key)
  return self.db:del(key)
end

function redisdb:set(key, val)
  return self.db:set(key, val)
end

function redisdb:get(key)
  return self.db:get(key)
end

function redisdb:findOne(key)
  return self.db:get(key)
end

function redisdb:hset(key, ...)
  return self.db:hset(key, ...)
end

return redisdb
