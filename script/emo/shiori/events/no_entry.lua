local response  = require "shiori.response"
local utils     = require "shiori.utils"

return function(EV)
--
function EV:no_entry(data, req)
    local id = req.id

    -- notify なら保存
    if req.method == "notify" then
        local a = utils.get_tree_entry(data ,"notify")
        a[id] = req
        return response.no_content()
    end

    -- 初めての未処理リクエストなら保存
    local a = utils.get_tree_entry(data ,"save", "no_entry")
    if a[id] == nil then a[id] = req
    end

    -- 応答
    local opt = {["X-Warn-Resion"]= "no_entry"}
    return response.no_content(opt)
end
--
end
