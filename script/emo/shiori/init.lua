--[[
エントリーポイント
]]

local main_loop = require "shiori.main_loop"
local response  = require "shiori.response"

local emo_env = nil


--SHIORI.unload() -> bool
local function raw_unload()
    local env = emo_env
    emo_env = nil
    if env then
        return env(nil)
    else
        return false
    end
end

local function shiori_unload()
    local ok, rc = pcall(raw_unload)
    if ok then return rc
    else return false
    end
end

--SHIORI.load(hinst, ansi_load_dir) -> bool
--load_dirはpath解決用のANSI文字列
local function raw_load(hinst, ansi_load_dir)
    shiori_unload()
    local args = {
        hinst         = hinst,
        ansi_load_dir = ansi_load_dir,
    }
    emo_env = main_loop.create();
    return emo_env(args)
end

local function shiori_load(hinst, ansi_load_dir)
    local ok, rc = pcall(raw_load, hinst, ansi_load_dir)
    if ok then return rc
    else return false
    end
end

--SHIORI.request(req) -> res
local function raw_request(req)
    return emo_env(req)
end

local function shiori_request(req)
    local ok, rc = pcall(raw_request, req)
    if ok then return rc
    else
        local res = response.err(rc)
        return res
    end
end

--エントリーポイント

shiori = {
    load    = shiori_load,
    unload  = shiori_unload,
    request = shiori_request,
    raw     = {
        load    = raw_load,
        unload  = raw_unload,
        request = raw_request,
    }
}

return shiori
