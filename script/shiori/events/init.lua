--[[
イベントテーブル
]]
local response  = require "shiori.response"


local EV={}
require("shiori.events.on_secound_change").(EV)

--イベントが無い場合の処理
local function no_entry(req)
    return response.no_content()
end

M.no_entry = no_entry

setmetatable(EV, {
    __index=function(table, key)
        return no_entry
    end
})


local M={}
M.get_event_handler= function()
    local H={}
    setmetatable(H, {
        __index= EV,
    })
    return H
end

--エントリーポイント
return M