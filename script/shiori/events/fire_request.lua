local response  = require "shiori.response"

return function(EV)
-- SHIORI リクエスト呼び出し
function EV:fire_request(env, req)
    local id = req.id
    local fn = self[id]
    return fn(self, env, req)
end
--
end
