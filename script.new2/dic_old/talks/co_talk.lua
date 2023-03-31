-------- ここからこのまま
local response  = require "shiori.response"
local normal = require "talks.normal"
return function(EV)
-------- ここまでこのまま

--ランダムトーク
function EV:ランダムトーク(data, req)
    local value = normal.call(data, req)
    return response.talk(value)
end

-------- ここからこのまま
end
-------- ここまでこのまま
