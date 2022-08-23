local response  = require "response"
local EV        = require "event"

--翻訳イベント。変更せずに返す。
function EV:OnTranslate(data, req)
    local value = req.reference[0]
    return response.ok(value)
end

--起動トーク
function EV:OnBoot(data, req)
    local value = [=[\1\s[10]\0\s[0]OnBoot:起動トークです。\e]=]
    return response.talk(req.now, value)
end
