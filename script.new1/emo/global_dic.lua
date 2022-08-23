local utf8 = require "utf8"
local dic = {}
local cache = {}

-- 辞書エントリの取得または初期化
local function get_entry(key)
    if dic[key] == nil then
        dic[key] = {}
    end
    return dic[key]
end

-- 辞書初期化
local function init_dic()
    local function INSERT(entry, value)
        local tp = type(value)
        if tp == "function" then
            table.insert(entry,value)
        elseif tp == "string" then
            table.insert(entry,value)
        elseif tp == "number" then
            table.insert(entry,value)
        elseif tp == "table" then
            for i, sub in ipairs(value) do
                INSERT(entry, sub)
            end
        end
    end
    for k,v in pairs(_G) do
        local entry = get_entry(k)
        INSERT(entry,v)
    end
end

-- 辞書を検索してパターンに一致する辞書エントリ一覧を返す。
local function scan_dic_impl(pattern)
    local items = {}
    for k,v in dic do
        if utf8.find(s, pattern) then
            items.insert(v)
        end
    end
    return {
        items = items,
        swap = nil,
    }
end

-- 辞書をキャッシュから検索して辞書エントリーを返す。
local function scan_dic(pattern)
    if cache[pattern] == nil then
        cache[pattern] = scan_dic_impl(pattern)
    end
    return cache[pattern]
end


init_dic()

return {

}