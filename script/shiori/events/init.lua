--[[
イベントテーブル
]]
local response  = require "shiori.response"

--イベントテーブルの読み込み
local EV={}
require("shiori.events.no_entry").(EV)
require("shiori.events.on_secound_change").(EV)

--イベントが無い場合の処理
setmetatable(EV, {
    __index=function(table, key)
        return EV.no_entry
    end
})

local M={}
M.get_event_table= function()
    local H={}
    setmetatable(H, {
        __index= EV,
    })
    return H
end

--エントリーポイント
return M