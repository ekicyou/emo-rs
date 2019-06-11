--[[
エントリーポイント
]]

local outcome   = require "outcome"
local main_loop = require "main_loop"
local response  = require "response"

local co = nil

--SHIORI.unload() -> Result<()>
local function unload()
    local co_item = co
    co = nil
    if co_item
    then
        local ok, rc = pcall(co_item, nil)
        if ok then  return rc
        else        return false
    else
        return false
    end
end

--SHIORI.load(hinst, ansi_load_dir) -> Result<()>
--load_dirはpath解決用のANSI文字列
local function load(hinst, ansi_load_dir)
    local args = {
        hinst           = hinst,
        ansi_load_dir   = ansi_load_dir,
    }
    unload()
    co = main_loop.create();
    local ok, rc = pcall(co, args)
    if ok then  return rc
    else        return false
end

--SHIORI.request(req) -> Result<res: utf8_string>
local function request(req)
    local ok, rc = pcall(co, req)
    if ok then  return rc
    else
        local res = response.err(rc)
        return res
    end
end

--エントリーポイント
local entry = {
    load   = load,
    unload = unload,
    request= request,
}
shiori = entry

return entry