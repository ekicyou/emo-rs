local response  = require "shiori.response"

return function(EV)
-- 秒の更新
function EV:OnSecondChange(data, req)
    return self:no_entry(data, req)
end

--
end
