local response  = require "shiori.response"

return function(EV)
--
function EV:OnSecondChange(env, req)
    return self:no_entry(env, req)
end
--
end
