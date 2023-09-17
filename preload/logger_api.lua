-------------------------------------------------------------------------------
-- Copyright(C)   machine studio                                              --
-- Author:        donney                                                     --
-- Email:         donney_luck@sina.cn                                        --
-- Date:          2022-02-28                                                 --
-- Description:   logger file                                                --
-- Modification:  modify                                                     --
-------------------------------------------------------------------------------
local skynet = require "skynet"
local table = table

-- 日志级别
local log_level = {
    LOG_DEFAULT = 1,
    LOG_TRACE = 1,
    LOG_DEBUG = 2,
    LOG_INFO = 3,
    LOG_WARN = 4,
    LOG_ERROR = 5,
    LOG_FATAL = 6
}

local defaultLevel = tonumber(skynet.getenv "log_default_lv") or log_level.LOG_DEBUG
local daemon = skynet.getenv("daemon")
local prefix = ""
function LOG_PREFIX(pre)
    prefix = "[" .. pre .. "]"
end
local color_gray = "\x1b[30m"
local color_red = "\x1b[31m"
local color_green = "\x1b[32m"
local color_yellow = "\x1b[33m"
local color_blud = "\x1b[34m"
local color_purple = "\x1b[35m"
local color_cyan = "\x1b[36m"
local color_white = "\x1b[37m"
local color_reset = "\x1b[0m"
-- 日志 --
local function logger(str, level, color)
    return function(...)
        if level >= defaultLevel then
            local info = table.pack(...)
            local now = os.time()
            local date_time = ""
            if daemon == nil then
                date_time = os.date("[%Y-%m-%d %H:%M:%S] ", now)
                info[#info + 1] = "\x1b[0m"
            else
                color = ""
            end
            skynet.error(string.format("%s%s%s%s", date_time, color, str, prefix), table.unpack(info))
        end
    end
end

-- local M = {
--   TRACE = logger("[trace]", log_level.LOG_TRACE, "\x1b[35m"),
--   DEBUG = logger("[debug]", log_level.LOG_DEBUG, "\x1b[32m"),
--   INFO  = logger("[info]", log_level.LOG_INFO, "\x1b[34m"),
--   WARN  = logger("[warning]", log_level.LOG_WARN, "\x1b[33m"),
--   ERROR   = logger("[error]", log_level.LOG_ERROR, "\x1b[31m"),
--   FATAL = logger("[fatal]", log_level.LOG_FATAL,"\x1b[31m")
-- }

local M = {
    TRACE = logger("[T]", log_level.LOG_TRACE, "\x1b[35m"),
    DEBUG = logger("[D]", log_level.LOG_DEBUG, "\x1b[32m"),
    INFO = logger("[I]", log_level.LOG_INFO, "\x1b[34m"),
    WARN = logger("[W]", log_level.LOG_WARN, "\x1b[33m"),
    ERROR = logger("[E]", log_level.LOG_ERROR, "\x1b[31m"),
    FATAL = logger("[F]", log_level.LOG_FATAL, "\x1b[31m")
}

-- 错误日志 --

setmetatable(M, {
    __call = function(t)
        for k, v in pairs(t) do
            _G[k] = v
        end
    end
})

M()

return M
