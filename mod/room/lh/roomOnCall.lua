---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by dongyf.
--- DateTime: 2019-06-07 17:08
---
local roomOnCall = {}

function roomOnCall.onLoop(roomAgent)
    roomAgent:checkTime()
    roomAgent:updateRoom()
end

function roomOnCall.onBet(roomAgent, uid, msg)
    return roomAgent.roomLogic:onBet(uid, msg)
end

return roomOnCall
