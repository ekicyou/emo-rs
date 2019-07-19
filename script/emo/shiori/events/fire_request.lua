local response  = require "shiori.response"
local utils     = require "shiori.utils"

return function(EV)
-- SHIORI リクエスト呼び出し
function EV:fire_request(data, req)
    -- Statusがある場合の分解
    local status_dic = utils.get_status(req.status)
    req.status_dic = status_dic

    -- 日時フィールドが未登録なら登録
    if req.date == nil then
        req.date = os.date("*t")
    end

    -- イベント分岐
    local id = req.id
    local fn = self[id]
    return fn(self, data, req)
end
--
end
