-------------------------------------------------------------------------------
-- Copyright(C)   machine studio                                              --
-- Author:        donney                                                     --
-- Email:         donney_luck@sina.cn                                        --
-- Date:          2021-06-08                                                 --
-- Description:   host console (an extension of skynet console)              --
-- Modification:  extend skynet debug_console                                --
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

-------------------------------------------------------------------------------
--                       skynet debug console commands                       --
-------------------------------------------------------------------------------
local SKYNET_COMMAND = {
        list = "List all the service",
        stat = "Dump all stats",
        info = "info address : get service infomation",
        exit = "exit address : kill a lua service",
        kill = "kill address : kill service",
        mem = "mem : show memory status",
        gc = "gc : force every lua service do garbage collect",
        start = "lanuch a new lua service",
        snax = "lanuch a new snax service",
        clearcache = "clear lua code cache",
        service = "List unique service",
        task = "task address : show service task detail",
        uniqtask = "task address : show service unique task detail",
        inject = "inject address luascript.lua",
        logon = "logon address",
        logoff = "logoff address",
        log = "launch a new lua service with log",
        debug = "debug address : debug a lua service",
        signal = "signal address sig",
        cmem = "Show C memory info",
        jmem = "Show jemalloc mem stats",
        ping = "ping address",
        call = "call address ...",
        trace = "trace address [proto] [on|off]",
        netstat = "netstat : show netstat",
        profactive = "profactive [on|off] : active/deactive jemalloc heap profilling",
        dumpheap = "dumpheap : dump heap profilling",
        killtask = "killtask address threadname : threadname listed by task",
        dbgcmd = "run address debug command",
}

-------------------------------------------------------------------------------
--                        host debug console commands                        --
-------------------------------------------------------------------------------
local LOCAL_COMMAND = {
    stop   = "stop   [ stop_all | mod ]",
    reload = "realod [ mod | mod/file ]",
    update = "update [  |  ]"
}

local COMMAND = {}

local function send(fd, ...)
    local t = { ... }
    for k,v in ipairs(t) do
        t[k] = tostring(v)
    end
    socket.write(fd, table.concat(t,"\t"))
    socket.write(fd, "\n")
end

local function handle(addr, fd, cmd, ...)
-- local function handle(fd, cmd, arg1, arg2)
    local ret
    f = SKYNET_COMMAND[cmd]
    if f ~= nil then
        --sendto skynet console
        return
    end
    local f  = COMMAND[cmd]
    if f ~= nil then
       f(addr, fd, ...)
       return
    end

    --local ret = skynet.call(skynet:self(), "lua", cmd.."."..arg1)
    --send(fd, "ok")
    --send(fd, ret)
end

function COMMAND.help(addr, fd)
    socket.write(fd, "--local commands-----------------------------------------\n")
    for k, v in pairs(LOCAL_COMMAND) do
        socket.write(fd, k)
        socket.write(fd, "\t")
        socket.write(fd, v)
        socket.write(fd, "\n")
    end
    socket.write(fd, "--skynet commands ---------------------------------------\n")
    for k, v in pairs(SKYNET_COMMAND) do
        socket.write(fd, k)
        socket.write(fd, "\t")
        socket.write(fd, v)
        socket.write(fd, "\n")
    end
end


function COMMAND.stop(addr, fd, arg1, ...)
    local ret = skynet.call(skynet:self(), "lua", "stop."..arg1)
    send(fd, ret)
end

function COMMAND.update(addr, fd, arg1, ...)
    -- local ret = skynet.call(skynet_daemon)
end

function COMMAND.reload(addr, fd, arg1, arg2)
    local t = {
       name = arg1,
       mod = arg2
    }
    INFO(serpent(t))
    local ret = skynet.call(skynet:self(), "lua", "reload.mod", addr, fd, t)
end

local function main_loop(addr, fd)
    socket.start(fd)
    send(fd, "Welcome to host console")
    local ok, err = pcall(function()
        while true do
            local cmdline = socket.readline(fd, "\r\n")
            if not cmdline then
                break
            end
            cmdlist = string.split(cmdline, " ")
            if #cmdlist <= 3 then
                handle(addr, fd, cmdlist[1], cmdlist[2], cmdlist[3])
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
        skynet.fork(main_loop, addr, fd)
    end)
end
