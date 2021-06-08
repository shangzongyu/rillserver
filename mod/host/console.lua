-------------------------------------------------------------------------------
-- Copyright(C)   machine stdio                                              --
-- Author:        donney                                                     --
-- Email:         donney_luck@sina.cn                                        --
-- Date:          2021-06-08                                                 --
-- Description:   host console (an extension of skynet console)              --
-- Modification:  null                                                       --
-------------------------------------------------------------------------------

local skynet = require "skynet"
local socket = require "skynet.socket"
local tool = require "tool"

local faci = require "faci.module"
local module = faci.get_module("console")
local dispatch = module.dispatch
local forward = module.forward
local event = module.event

local runconf = require(skynet.getenv("runconfig"))
local node = skynet.getenv("nodename")

local function send(fd, ...)
    local t = { ... }
    for k,v in ipairs(t) do
        t[k] = tostring(v)
    end
    socket.write(fd, table.concat(t,"\t"))
    socket.write(fd, "\n")
end

local function handle(fd, cmdline)
    local ret = skynet.call(skynet:self(), "lua", cmdline)
    send(fd, "ok")
    -- send(fd, ret)
end

local function main_loop(fd)
    socket.start(fd)
    send(fd, "Welcome to host console")
    local ok, err = pcall(function()
        while true do
            local cmdline = socket.readline(fd, "\n")
            if not cmdline then
                break
            end
            -- cmdlist = string.split(cmdline, " ")
            if cmdline ~= "" then
                handle(fd, cmdline)
                -- handle(fd, cmdlist[1], cmdlist[2])
            end

        end
    end)

    if not ok then
        skynet.error(fd, err) end
    skynet.error(fd, "disconnected")
    socket.close(fd)
end

function event.start()
    local cfg = runconf.service.host_common.console
    if node ~= cfg.node then
        return
    end

    local listenfd = socket.listen("127.0.0.1", cfg.port)
    log.info("Listen console port %d", cfg.port)

    socket.start(listenfd , function(fd, addr)
        log.info("connected %s%d", addr, fd)
        skynet.fork(main_loop, fd)
    end)
end
