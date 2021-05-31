-------------------------------------------------------------------------------
-- Copyright(C)   machine stdio                                              --
-- Author:        donney                                                     --
-- Email:         donney_luck@sina.cn                                        --
-- Date:          2021-05-28                                                 --
-- Description:   Global System control cluster start&stop&gm command        --
-- Modification:  null                                                       --
-------------------------------------------------------------------------------

local name, id = ...
local s = require "faci.service"
s.init(name, id)
