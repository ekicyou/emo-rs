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

local function get_status(status, pos, t)
    -- ローカル関数：(k=v)のマッチ
    local function kv(t)
        local all, k, v = string.match(status, "^(,?([^=%),]+)=([^=%),]+))", pos)
        if all == nil then return
        end
        pos = pos + #all
        t[k] =v
        kv(t)
    end

    -- ローカル関数：()のマッチ
    local function kakko()
        local all = string.match(status, "^%(", pos)
        if all == nil then return true
        end
        pos = pos + #all
        local t = {}
        kv(t)

        local all = string.match(status, "^%)", pos)
        if all ~= nil then pos = pos + #all
        end
        return t
    end

    -- keyのマッチ
    local all, k = string.match(status, "^(,?([%w_]+))", pos)
    if k == nil then return
    end
    pos = pos + #all

    -- (k=v,...)のマッチ
    t[k] = kakko()
    return get_status(status, pos, t)
end

function M.get_status(status)
    if type(status) ~= "string" then return {}
    end
    local t = {}
    get_status(status, 1, t)
    return t
end

return M