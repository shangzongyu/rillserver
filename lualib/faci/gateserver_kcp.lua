local skynet = require "skynet"
local netpack = require "skynet.netpack"
local socketdriver = require "skynet.socketdriver"
local socket = require("skynet.socket")

local gateserver = {}

--local socket    -- listen socket
local queue         -- message queue
local maxclient     -- max client
local client_number = 0
local CMD = setmetatable({}, { __gc = function() netpack.clear(queue) end })
local nodelay = false

local FUNC = {}
local connection = {}

function gateserver.openclient(fd)
    if connection[fd] then
        socketdriver.start(fd)
    end
end

function gateserver.closeclient(fd)
    local c = connection[fd]
    if c then
        connection[fd] = false
        socketdriver.close(fd)
    end
end

function gateserver.start(handler)
    assert(handler.message)
    assert(handler.connect)
    function FUNC.on_receive(data, from)
        print(socket.udp_address(from))
    end

    function CMD.open( source, conf )
        assert(socket)
        local address = conf.address or "0.0.0.0"
        local port = assert(conf.port)
        maxclient = conf.maxclient or 1024
        -- nodelay = conf.nodelay
        socket.udp(FUNC.on_receive, address, port)
        if handler.open then
            return handler.open(source, conf)
        end
    end

    skynet.start(function()
        skynet.dispatch("lua", function (_, address, cmd, ...)
            local f = CMD[cmd]
            if f then
                skynet.ret(skynet.pack(f(address, ...)))
            else
                --skynet.ret(skynet.pack(handler.command(cmd, address, ...)))
            end
        end)

    end)
end

return gateserver
