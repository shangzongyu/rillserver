local skynet = require "skynet"
local netpack = require "skynet.netpack"
local socketdriver = require "skynet.socketdriver"
local socket = require("skynet.socket")

-------------------------------------------------------------------------------
-- Copyright(C)   machine studio                                              --
-- Author:        donney                                                     --
-- Email:         donney_luck@sina.cn                                        --
-- Date:          2022-04-01                                                 --
-- Description:   class tcp                                                  --
-- Modification:  null                                                       --
-------------------------------------------------------------------------------
local lkcp = require("lkcp")
local kcp = class('kcp') -- 'kcp' is the class' name
local kcp_map = {}
local udp

function kcp:initialize(conv, fd, SendWrap)
    self._kcp = lkcp.lkcp_create(conv, SendWrap)
    self._kcp:lkcp_nodelay(1, 10, 2, 1)
    self._kcp:lkcp_wndsize(128, 128)
    self._fd = fd
    --self.deviceModel
    self.heartbeat = true
end

function kcp:send(data)
    self._kcp:lkcp_send(data)
end

function kcp:input(data)
    self._kcp:lkcp_input(data)
    self.heartbeat = true
end

function kcp:update(data)
end
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Copyright(C)   machine studio                                              --
-- Author:        donney                                                     --
-- Email:         donney_luck@sina.cn                                        --
-- Date:          2022-04-01                                                 --
-- Description:   gateserver_kcp                                             --
-- Modification:  null                                                       --
-------------------------------------------------------------------------------


local gateserver = {}

--local socket    -- listen socket
local queue         -- message queue
local maxclient     -- max client
local client_number = 0
local CMD = setmetatable({}, { __gc = function() netpack.clear(queue) end })
local nodelay = false

local connection = {}


local FUNC = {}


function gateserver.openclient(fd)
    if connection[fd] then

    end
end
function gateserver.closeclient(fd) local c = connection[fd] if c then
        connection[fd] = false
    end
end

function gateserver.start(handler)
    assert(handler.message)
    assert(handler.connect)

    function FUNC.on_receive(data, from)
        local addr, port = socket.udp_address(from)
        -- 按理来说客户端与服务端的初次连接使用TCP更为适合（一个KCP对象只服务一个
        -- 连接，所以初次连接的客户端在服务端并没有对应的KCP对象），但是为了偷懒我采
        -- 用了这样的方式：
        --TODO: 是否可以直接用connection当作 kcpmap 调通后在调整
        if not connection[from] then
            connection[from] = true
            handler.connect(from, addr..':'..port)
            kcp_map[from] = kcp:new(1, from, function (data)
                print("send data:"..data)
                socket.sendto(udp, from, data)
            end)

            -- 创建完kcp对象后 直接把数据给下层
            kcp_map[from]:input(data)
        elseif kcp_map[from] then
            kcp_map[from]:input(data)
        end
    end

    function FUNC.update()
        for k, v in pairs(kcp_map) do
            v:update(_timer)
        end
        timer = timer + updateInterval * 10
    end

    function CMD.open( source, conf )
        assert(socket)
        local address = conf.address or "0.0.0.0"
        local port = assert(conf.port)
        maxclient = conf.maxclient or 1024
        -- nodelay = conf.nodelay
        udp = socket.udp(FUNC.on_receive, address, port)
        if handler.open then
            handler.open(source, conf)
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
