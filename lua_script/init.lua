--[[
エントリーポイント
]]

local outcome   = require "outcome"
local main_loop = require "main_loop"

local co = nil

--SHIORI.unload() -> Result<()>
local function unload()
    local co_item = co
    co = nil
    if co_item
    then return co_item(nil)
    else return false
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
    return co(args)
end

--SHIORI.request(req) -> Result<res: utf8_string>
local function request(req)
    return co(req)
end

--エントリーポイント
shiori = {
    load   = load,
    unload = unload,
    request= request
}

return shiori