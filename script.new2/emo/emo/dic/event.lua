-- イベント辞書
local MOD = {}
local META = {}


-- ############################################################
-- クラス：イベントエントリ
-- ############################################################

-- イベントエントリのメタテーブル
local ENTRY_META = {}


-- 新しいイベントエントリ格納庫を返す。
function ENTRY_META:new_store()
    local store = self.store
    if not store then
        store = {}
        self.store = store
    end
    local item = {}
    table.insert(self.store, item)
    return item
end

-- イベントエントリ：コンストラクタ
local function create_entry(name)
    local a = {}
    a.name = name
    setmetatable(a, ENTRY_META)
    return a
end


-- ############################################################
-- イベントエントリの管理
-- ############################################################
-- イベントエントリ辞書
local entry = {}

-- イベント登録用オブジェクトを返す。
function META.__index(event_name)
    local ev = entry[event_name]
    if not ev then
        ev = create_entry()
    end
    return ev:new_store()
end


setmetatable(MOD, META)
return MOD