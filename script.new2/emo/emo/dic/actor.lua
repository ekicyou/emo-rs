-- actor管理
local MOD = {}

local wait_str = require "emo.dic.wait_str"
local ss = require "emo.dic.sakura_script"

-- ============================================================
-- actor定義
-- ============================================================

--- アクター情報
--- @class Actor
--- @field wait number[] 会話ウェイト
--- @field BOARD_METHOD table ボードに指定する表情メソッドテーブル
--- @field default_emote_script string デフォルトエモートに切り替えるスクリプト
local ACTOR_METHOD = {}
local ACTOR_META = {}
ACTOR_META.__index = ACTOR_METHOD

--- wait情報を設定する。
--- @param wait1 number 一般文字wait、直前の残waitを確定
--- @param wait2 number 半濁点
--- @param wait3 number エクステンション（！、？）
--- @param wait4 number 濁点
--- @param wait5 number 点々、直前の残waitを確定
--- @return Actor
function ACTOR_METHOD:set_wait(wait1, wait2, wait3, wait4, wait5)
    self.wait = { wait1, wait2, wait3, wait4, wait5 }
    return self
end

--- emote情報を設定する。
--- @param emote string emote名
--- @vararg string|number 展開するスクリプト（複数指定可能）
--- @return Actor
function ACTOR_METHOD:set_emote(emote, ...)
    local items = {}
    for _, v in ipairs({ ... }) do
        if type(v) == "number" then
            v = ss.surface(v)
        end
        table.insert(items, v)
    end
    if not self.default_emote_script then self.default_emote_script = items[1] end

    local function SEL()
        local length = #items
        local index = math.random(1, length)
        local element = items[index]
        return element
    end

    --- エモート後にトークを行う。
    --- @param board any ボード
    --- @param talk string トーク
    local function EMOTE_TALK(board, talk, ...)
        board:emote_script(SEL())
        board:talk(talk, ...)
    end
    self.BOARD_METHOD[emote] = EMOTE_TALK

    return self
end

--- スコープ切り替え時の改行幅を設定する。
---@param em number 改行幅
---@return Actor
function ACTOR_METHOD:set_scope_change_line(em)
    self.scope_change_line = em
    return self
end

--- 新しいトークの改行幅を設定する。
---@param em number 改行幅
---@return Actor
function ACTOR_METHOD:set_talk_line(em)
    self.talk_line = em
    return self
end

-- ============================================================
-- コンストラクタ
-- ============================================================

--- アクター情報を作成する
---@return Actor
local function create_actor(name)
    local a = {
        name = name,
        talk_line = 1.0,
        scope_change_line = 1.5,
        BOARD_METHOD = {},
    }
    setmetatable(a, ACTOR_META)
    return a
end

-- ============================================================
-- モジュール
-- ============================================================

local actor_dic = {} -- actorデータ辞書

--- actor定義の登録
--- @param name string アクター名
--- @return Actor
function MOD.register(name)
    local a = create_actor(name)
    actor_dic[name] = a
    return a
end

--- actor定義の取得
--- @param name string アクター名
--- @return Actor
function MOD.get(name)
    return actor_dic[name]
end

return MOD
