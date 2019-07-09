local M = {}

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

M.get_tree_entry = get_tree_entry

-- SHIORI Request Status: を分解して返す。
function M.get_status(status)
    if type(status) ~= "string" then return {}
    end
    local rc = {}
    for k, v in string.gmatch(status, "([%w_]+)(%([^%)]*%))*,?") do
        if not v then v = true
        end
        rc[k] = v
    end
end

return M