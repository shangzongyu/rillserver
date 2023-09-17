---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by dongyf.
--- DateTime: 2019-06-08 10:47
---
local Card = Card

local rule = {}

rule.MAX_RANKLIST = 20
-- 30轮之后规则改变了
rule.CHANGE_ROUND = 30

-- 通用状态
rule.LH_ACTION = {
    -- 房间动作：开始游戏
    EMPTY = 0, -- 空状态
    SHUFFLE = 1, -- 洗牌
    READY = 2, -- 准备
    HOLE = 3, -- 发牌
    BET = 4, -- 下注
    OPEN = 5, -- 开牌
    BONUS = 6, -- 发奖
    RETURN = 7, -- 退还
    WIN = 8, -- 结算
    STOP = 9 -- 维护中 停止中
}

local LH_ACTION = rule.LH_ACTION
rule.LH_ACTION_STR = {
    -- 玩家动作
    [LH_ACTION.EMPTY] = "空",
    [LH_ACTION.SHUFFLE] = "洗牌",
    [LH_ACTION.READY] = "准备",
    [LH_ACTION.HOLE] = "发牌",
    [LH_ACTION.BET] = "下注",
    [LH_ACTION.OPEN] = "开牌",
    [LH_ACTION.BONUS] = "发奖",
    [LH_ACTION.STOP] = "维护中"
}

-- 每种状态
rule.LH_COUNTDOWN = {
    [LH_ACTION.EMPTY] = 3,
    [LH_ACTION.SHUFFLE] = 3,
    [LH_ACTION.READY] = 3,
    [LH_ACTION.HOLE] = 3,
    [LH_ACTION.BET] = 20,
    [LH_ACTION.OPEN] = 3,
    [LH_ACTION.BONUS] = 4,
    [LH_ACTION.STOP] = 2
}

-- 赌注位置
rule.LH_BETPOS = {
    NONE = 0,
    LONG = 1, -- 龙
    HU = 2, -- 虎
    HE = 3, -- 和
    LONG_SPADE = 4, -- 龙黑桃
    LONG_HEART = 5, -- 龙红桃
    LONG_CLUB = 6, -- 龙梅花
    LONG_DIAMOND = 7, -- 龙方块
    HU_SPADE = 8, -- 虎黑桃
    HU_HEART = 9, -- 虎红桃
    HU_CLUB = 10, -- 虎梅花
    HU_DIAMOND = 11, -- 虎方块
    YZY = 12, -- 压庄赢
    YZS = 13 -- 压庄输
}

-- 赌注赔率
local LH_BETPOS = rule.LH_BETPOS
rule.LH_BETPOS_RATE = {
    [LH_BETPOS.LONG] = 1.95,
    [LH_BETPOS.HU] = 1.95,
    [LH_BETPOS.HE] = 20,
    [LH_BETPOS.LONG_SPADE] = 3.9,
    [LH_BETPOS.LONG_HEART] = 3.9,
    [LH_BETPOS.LONG_CLUB] = 3.9,
    [LH_BETPOS.LONG_DIAMOND] = 3.9,
    [LH_BETPOS.HU_SPADE] = 3.9,
    [LH_BETPOS.HU_HEART] = 3.9,
    [LH_BETPOS.HU_CLUB] = 3.9,
    [LH_BETPOS.HU_DIAMOND] = 3.9,
    [LH_BETPOS.YZY] = 1.95,
    [LH_BETPOS.YZS] = 1.95
}

-- 开奖结果
rule.LH_BONUS = {
    LONG = 1,
    HU = 2,
    HE = 3
}

rule.LH_SUITPOS_LONG = {
    [Card.CARD_SUIT.SPADE] = LH_BETPOS.LONG_SPADE,
    [Card.CARD_SUIT.HEART] = LH_BETPOS.LONG_HEART,
    [Card.CARD_SUIT.CLUB] = LH_BETPOS.LONG_CLUB,
    [Card.CARD_SUIT.DIAMOND] = LH_BETPOS.LONG_DIAMOND
}

rule.LH_SUITPOS_HU = {
    [Card.CARD_SUIT.SPADE] = LH_BETPOS.HU_SPADE,
    [Card.CARD_SUIT.HEART] = LH_BETPOS.HU_HEART,
    [Card.CARD_SUIT.CLUB] = LH_BETPOS.HU_CLUB,
    [Card.CARD_SUIT.DIAMOND] = LH_BETPOS.HU_DIAMOND
}

-- 下注倍数
rule.LH_AI_MUL = {
    [1] = {1, 1},
    [2] = {2, 3},
    [3] = {4, 12},
    [4] = {13, 20},
    [5] = {21, 49},
    [6] = {50, 50}
}

return rule
