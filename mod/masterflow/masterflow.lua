-------------------------------------------------------------------------------
-- Copyright(C)   machine stdio                                              --
-- Author:        donney                                                     --
-- Email:         donney_luck@sina.cn                                        --
-- Date:          2021-05-31                                                 --
-- Description:   masterflow -> slaveflow  command transport                 --
-- Modification:  null                                                       --
-------------------------------------------------------------------------------
local module = require "faci.module"
local faci_module= module.get_module("faci")
local faci_dispatch = faci_module.dispatch

function faci_dispatch.registe(info)
  INFO("registe info"..inspect(info))
end