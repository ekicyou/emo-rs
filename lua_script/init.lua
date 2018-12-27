--[[
エントリーポイント
]]

local outcome   = require "outcome"
local main_loop = require "main_loop"

--SHIORI.load(hinst, ansi_load_dir, ansi_lua_path) -> Result<()>
local function load(hinst, ansi_load_dir, ansi_lua_path)

end

--SHIORI.unload() -> Result<()>
local function unload()

end

--SHIORI.request(req) -> Result<res: utf8_string> 
local function request(req)

end

--エントリーポイント
shiori = {
    load   = load,
    unload = unload,
    request= request
}

return shiori