--[[
イベント検索・分岐処理
]]

local response  = require "response"
local utils     = require "utils"

return function(EV)
-- SHIORI リクエスト呼び出し
function EV:fire_request(data, req)
    -- Statusがある場合の分解
    local status_dic = utils.get_status(req.status)
    req.status_dic = status_dic

    -- 日時フィールドが未登録なら登録
    if not req.now then
        req.now = os.time()
    end
    if not req.date then
        req.date = os.date("*t", req.now)
    end

    -- イベント分岐
    local id = req.id
    local fn = self[id]
    return fn(self, data, req)
end
--
end
