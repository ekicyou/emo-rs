local response  = require "shiori.response"

return function(EV)
-- 秒の更新
function EV:OnSecondChange(env, req)
    return self:no_entry(env, req)
end

--翻訳イベント。変更せずに返す。
function EV:OnTranslate(env, req)
    local value = req.reference[0]
    return response.ok(value)
end

--
end
