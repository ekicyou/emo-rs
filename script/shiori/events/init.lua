--[[
イベントテーブル
]]

--イベントテーブルの読み込み
local EV={}
do
    local items = {
        "shiori.events.fire_request",
        "shiori.events.no_entry",
        "shiori.events.on_secound_change"
    }
    for i,v in ipairs(items) do
        local reg = require(v)
        reg(EV)
    end
end

--イベントが無い場合はno_entryにリダイレクトする
setmetatable(EV, {
    __index=function(table, key)
        return EV.no_entry
    end
})



--イベントテーブル取得
local M={}
function M.get_event_table()
    local H={}
    setmetatable(H, {
        __index= EV,
    })
    return H
end

return M