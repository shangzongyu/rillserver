---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by dongyf.
--- DateTime: 2019-06-07 16:14
---

local RoomLH = class("RoomLH")
local skynet = require "skynet"
local tablex = require "pl.tablex"
local libcenter = require "libcenter"
local roomLogic = require("lh.logic")
local roomOnCall = require("lh.roomOnCall")

local Cards = Cards
local Date = require('pl.Date')

function RoomLH:roomInit(room_type)
    self.players = {}

    local date = Date()
    date:_init()
    DEBUG("当前时间: ", date:toLocal())

    roomLogic:start(self)
end

function RoomLH:is_player_num_overload()
    return tablex.size(self.players) >= 5000
end

function RoomLH:initialize()
    RoomLH.onCall = roomOnCall
    RoomLH.roomLogic = roomLogic
end

function RoomLH:broadcast(msg, filterUid)
    for k,v in pairs(self.players) do
        if not filterUid or filterUid ~= k then
            --libcenter.send2client(k,msg)
            skynet.send(v.agent, "lua", 'send2client',msg)
        end
    end
end

function RoomLH:enter(data)
    local uid = data.uid
    local player = {
        uid = uid,
        agent = data.agent,
        node = data.node,
    }
    self.players[uid]=player
    self:broadcast({_cmd = "room_move.add", uid=uid,}, uid)

    return SYSTEM_ERROR.success
end

function RoomLH:leave(uid)
    if not uid then
        ERROR("RoomLH leave uid is nil")
        return SYSTEM_ERROR.error
    end
    self.players[uid] = nil
    self:broadcast({_cmd = "movegame.leave", uid = uid}, uid)

    return SYSTEM_ERROR.success
end

function RoomLH:onRequest(...)
    local uid = select(1, ...)
    local cmd = select(2, ...)
    local msg = select(3, ...)
    DEBUG('uid: ', uid, ' cmd: ', cmd, ' msg: ', inspect(msg))

    if cmd then
        cmd = 'on' .. cmd
        if self.onCall[cmd] then
            return self.onCall[cmd](self, uid, msg)
        end
    end

    return false
end

return RoomLH