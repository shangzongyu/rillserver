-------------------------------------------------------------------------------
-- Copyright(C)   machine studio                                              --
-- Author:        donney                                                     --
-- Email:         donney_luck@sina.cn                                        --
-- Date:          2022-04-20                                                 --
-- Description:   web auth for sdk  same as login_auth.lua                   --
-- Modification:  null                                                       --
-------------------------------------------------------------------------------
local skynet = require "skynet"
local cluster = require "skynet.cluster"
local httpd = require "http.httpd"
local sockethelper = require "http.sockethelper"
local httpc     = require "http.httpc"
local md5       = require "md5"
local json      = require "cjson"

local faci = require "faci.module"
local module = faci.get_module("auth")
local dispatch = module.dispatch
local forward = module.forward
local event = module.event

local runconf = require(skynet.getenv("runconfig"))

--sdk 列表
local sdk = {
    inner = 0,
    uugame = 1,
    ghome = 2,
    gamepot = 3,
    max = 4,
}


local ghome_idx = 0

-- 以下是各个渠道的验证方式
local function gamepot_auth(jsonData)
    --构造请求
    local method = "POST"
    local host = "https://gamepot.apigw.ntruss.com"
    local url = "/gpapps/v1/loginauth"
    local recvheader = {}
    local content = {
        projectId = "2f90b2da-78ad-46f5-89a9-0bf2b653d7c1",
        memberId = jsonData.account,
        token = jsonData.password,
    }
    --auth可能携带换行 需要过滤
    local header = {
        ["Content-Type"] = "application/json",
        -- ["charset"] = "utf-8",
        -- ["Authorization"] = "Bearer " .. auth
    }
    INFO("request:","time=",skynet.time(), "content=",content)
    local status, body = httpc.request(method, host, url, recvheader, header, json.encode(content))
    INFO("response:","time=",skynet.time(),"body=",body)
    return body
end


local function ghome_auth(jsonData)
    --构造请求
    local method = "POST"
    local host = "http://mservice.sdo.com"
    local recvheader = {}
    local appid = "791000419"
    local appsecretkey = "3896a24d5cddb5e0b1676b3d786bd462"
    local time = math.floor(skynet.time() * 1000)
    local sign_str = "appid=" .. appid .. "&sequence=" .. ghome_idx  .. "&ticket_id=" .. jsonData.password .. "&timestamp=" .. time
    local signature = md5.sumhexa(sign_str .. appsecretkey)

    local header = {
        ["Content-Type"] = "application/json",
        -- ["charset"] = "utf-8",
        -- ["Authorization"] = "Bearer " .. auth
    }
    local url = "/v1/open/ticket?" .. sign_str .. "&sign=" ..signature

    INFO("request","time=",skynet.time(), host .. url)
    local status, body = httpc.request(method, host, url, recvheader, header, "")
    if status == 200 then
        ghome_idx = ghome_idx + 1
        ERROR(ghome_idx)
    end
    INFO("response:","time=",skynet.time(),"body=",body)
    return body
end


local auth_handler = {
    [sdk.gamepot] = gamepot_auth,
    [sdk.ghome] = ghome_auth,
}

function dispatch.login_auth(addr, fd , q)
    local jsonData = json.decode(q.body)
    local sdk = math.floor(jsonData.sdk)
    local fc = auth_handler[sdk]

    return fc(jsonData)
end
