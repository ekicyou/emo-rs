local response  = require "shiori.response"
local utils     = require "shiori.utils"

return function(EV)
--
function EV:no_entry(env, req)
    -- 初めての未処理リクエストなら保存
    local id = req.id
    local a = utils.get_tree_entry(env ,"save", "no_entry")
    if a[id] == nil then a[id] = req
    end
    -- 応答
    local opt = {["X-Warn-Resion"]= "no_entry"}
    return response.no_content(opt)
end
--
end
