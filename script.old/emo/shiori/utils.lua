local M = {}

-- tableのツリー構造をたどり、tableを取得する
-- 存在しない場合は空テーブルを登録して返す
local function get_tree_entry(self, key, ...)
    if type(self) ~= "table" then return nil
    end
    if key == nil then return self
    end
    local sub = self[key]
    if type(sub) ~= "table" then
        sub = {}
        self[key] = sub
    end
    return get_tree_entry(sub, ...)
end
local Tree={}
M.get_tree_entry = get_tree_entry
Tree.ENTRY       = get_tree_entry
local meta_Tree  = {__index=Tree}
function M.init_tree_entry(t)
    setmetatable(t, meta_Tree)
    return t
end

-- dataオブジェクトから対応するenv/saveを取得する
local function get_data_entry(self, ...)
    local env  = get_tree_entry(self , "env" , ...)
    local save = get_tree_entry(self , "save", ...)
    return env, save
end
local Data={}
M.get_data_entry = get_data_entry
Data.ENTRY       = get_data_entry
local meta_Data = {__index=Data}
function M.init_data_table(data)
    setmetatable(data, meta_Data)
    local env, save = data:ENTRY()
    M.init_tree_entry(env)
    M.init_tree_entry(save)
    return data
end

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

-- merge(a, b) テーブルaにbを合成する。同じキーの場合はaを優先する。
local function merge(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
        return a or b
    end
    for k,bv in pairs(b) do
        local av = a[k]
        local at = type(av)
        if at == "nil" then
            a[k] = bv
        elseif at == "table" then
            a[k] = merge(av, bv)
        end
    end
    return a
end
function M.merge(a, b)
    return merge(a, b)
end

-- unimplemented() 未実装の戻り値、nilを返す。
function M.unimplemented()
    return nil
end

return M