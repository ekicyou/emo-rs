local response  = require "shiori.response"

-- tableのツリー構造をたどり、tableを取得する
-- 存在しない場合は空テーブルを登録して返す
local function get_tree_entry(table, key, ...)
    if type(table) ~= "table" then return nil
    end
    if key == nil then return table
    end
    local sub = table[key]
    if type(sub) ~= "table" then
        sub = {}
        table[key] = sub
    end
    return get_tree_entry(sub, ...)
end


return function(EV)
--
function EV:no_entry(env, req)
    -- 初めての未処理リクエストなら保存
    local id = req.id
    local a = get_tree_entry(env ,"save", "no_entry")
    if a[id] == nil then a[id] = req
    end
    -- 応答
    local opt = {["X-Warn-Resion"]= "no_entry"}
    return response.no_content(opt)
end
--
end
