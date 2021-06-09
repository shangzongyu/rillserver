-------------------------------------------------------------------------------
-- Copyright(C)   machine stdio                                              --
-- Author:        donney                                                     --
-- Email:         donney_luck@sina.cn                                        --
-- Date:          2021-05-25                                                 --
-- Description:   faci module                                                --
-- Modification:  null                                                       --
-------------------------------------------------------------------------------

local skynet = require "skynet"
local lfstool = require "lfstool"
local env = require "faci.env"
local event = require "faci.event"
local reload = require "reload"

local M = {}

function M.get_env(file)
	local ok, result = reload.reload(file)
	return ok, result
end

function M.reload_module(file)
	local diff_time, ok = reload.reload(file)
	return diff_time, ok
end

function M.reload_modules()
	local path = skynet.getenv("app_root").."mod/"..env.name
    local diff_time = 0, ok
    lfstool.attrdir(path, function(file)
	local file = string.match(file, ".*mod/(.*)%.lua")
		if file then
			-- log.info(string.format("%s%d reload file:%s", env.name, env.id, file))
            INFO("reload file:"..file)
            dt, result = reload.reload(file)
            diff_time = diff_time + dt
            ok = result
		end
	end)
	return diff_time, ok
end

--通过 env的 mod 名 require 文件
local function require_modules()
	local path = skynet.getenv("app_root").."mod/".. env.name
	DEBUG("require_modules path: ", path)
	local recursive = true
	-- if string.find(env.name, 'room') then
	-- 	recursive = false
	-- 	local path = skynet.getenv("app_root").."mod/room"
	-- 	lfstool.attrdir(path, function(file)
	-- 		--DEBUG("file: ", file)
	-- 		local file = string.match(file, ".*mod/(.*)%.lua")
	-- 		if file then
	-- 			INFO(string.format("=============> %s%d require file:%s", env.name, env.id, file))
	-- 			require(file)
	-- 		end
	-- 	end, recursive)
	-- 	return
	-- end

	lfstool.attrdir(path, function(file)
		local file = string.match(file, ".*mod/(.*)%.lua")
		if file then
			INFO(string.format("=============> %s%d require file:%s", env.name, env.id, file))
			require(file)
		end
	end, recursive)
end

local module = {}
function M.get_module(name)
	--模块处理函数
	env.module[name] = env.module[name] or {
		dispatch = {},
		forward = {},
		event = {},
		watch = nil,
	}
	--模块全局变量
	env.static[name] = env.static[name] or {
	}
	return env.module[name], env.static[name]
end


local event_cache = {}
function M.fire_event(name, ...)
	DEBUG("fire event->", name, inspect(table.pack(...)) )

	if not event.can_fire(name) then
		ERROR("-----fire event fail, event->", name, " is not define------")
		return
	end
	--获取列表
	local cache = event_cache[name]
	if not cache then
		event_cache[name] = {}
		for i, v in pairs(env.module) do
			if type(v.event[name]) == "function" then
				table.insert(event_cache[name], v.event[name])
			end
		end
	end
	cache = event_cache[name]
	--执行注册时间 function
	for _, fun in ipairs(cache) do
		xpcall(fun, function(err)
			ERROR("error msg", inspect(err))
			ERROR(debug.traceback())
		end, ...)
	end
end

function M.init_modules()
	require_modules()
end

return M
