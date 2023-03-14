-- イベント辞書
local MOD = {}
local META = {}

local entry = require "dic.entry"

-- ############################################################
-- クラス：イベント
-- ############################################################

-- イベントのメタテーブル
local EVENT_META = {}

-- 新しいイベントエントリを返す。
function EVENT_META:new_entry()
    if not self.store then
        self.store = {}
    end
    local a = entry.create()
    table.insert(self.store, a)
    return a
end

-- イベントエントリ：コンストラクタ
local function create_event(id)
    local a = {}
    a.id = id
    setmetatable(a, EVENT_META)
    return a
end

-- ############################################################
-- イベントの管理
-- ############################################################
-- イベント辞書
local event_dic = {}

-- イベント登録用オブジェクトを返す。
function META.__index(id)
    local ev = event_dic[id]
    if not ev then
        ev = create_event(id)
        event_dic[id] = ev
    end
    return ev:new_store()
end

function META.get_entry(event_name)

end

setmetatable(MOD, META)
return MOD
