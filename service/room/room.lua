-------------------------------------------------------------------------------
-- Copyright(C)   machine stdio                                              --
-- Author:        donney                                                     --
-- Email:         donney_luck@sina.cn                                        --
-- Date:          2021-05-25                                                 --
-- Description:   service room                                               --
-- Modification:  null                                                       --
-------------------------------------------------------------------------------

require("base.init")

local name, id = ...
local s = require "faci.service"
s.init(name, id)