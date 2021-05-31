-------------------------------------------------------------------------------
-- Copyright(C)   machine stdio                                              --
-- Author:        donney                                                     --
-- Email:         donney_luck@sina.cn                                        --
-- Date:          2021-05-31                                                 --
-- Description:   supermoniter command                                       --
-- Modification:  null                                                       --
-------------------------------------------------------------------------------

local skynet = require "skynet"
local module = require "faci.module"
local faci_module= module.get_module("faci")
local faci_dispatch = faci_module.dispatch

local cache = {}

function faci_dispatch.registe(info)
  cache[info.region_id] = info
  ERROR("registe info", inspect(cache))
end