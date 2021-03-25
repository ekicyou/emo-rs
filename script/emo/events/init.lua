--[[
イベントテーブル登録
[EV:???(data,req)]を登録していきます。
]]
local event_defs = {
    "events.fire_request",
    "events.no_entry",
    "events.talk",
    "events.talk_event",
}

--イベントテーブルの読み込み
local EV={}
do
    for i,v in ipairs(event_defs) do
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