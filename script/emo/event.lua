--[[
イベント検索・分岐処理
]]

local response  = require "response"
local utils     = require "utils"
local EV = {}

-- SHIORI リクエスト呼び出し
function EV:fire_request(data, req)
    -- Statusがある場合の分解
    local status_dic = utils.get_status(req.status)
    req.status_dic = status_dic

    -- 日時フィールドが未登録なら登録
    if not req.now then
        req.now = os.time()
    end
    if not req.date then
        req.date = os.date("*t", req.now)
    end

    -- イベント分岐
    local id = req.id
    local fn = self[id]
    return fn(self, data, req)
end

--イベントが無い場合はno_entryにリダイレクトする
setmetatable(EV, {
    __index=function(table, key)
        return EV.no_entry
    end
})

--未登録イベントの処理
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


--イベントテーブルを返す
return EV