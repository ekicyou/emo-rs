local response  = require "shiori.response"

return function(EV)
--
EV.OnSecondChange = function(...)
    return EV.no_entry(...)
end
--
end
