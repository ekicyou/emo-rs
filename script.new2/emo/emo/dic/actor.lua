-- actor管理
local MOD = {}

local wait_str = require "emo.dic.wait_str"

-- ============================================================
-- actor定義
-- ============================================================

--- アクター定義
--- @class Actor
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
function ACTOR_METHOD:wait(wait1, wait2, wait3, wait4, wait5)
    self.wait = { wait1, wait2, wait3, wait4, wait5 }
    return self
end

--- emote情報を設定する。
--- @param name string emote名
--- @param script string 展開するスクリプト
--- @return Actor
function ACTOR_METHOD:emote(name, script)
    if not self.emote_dic then self.emote_dic = {} end
    if not self.default_emote then self.default_emote = name end
    self.emote_dic[name] = script
    return self
end

--- wait情報を設定する。
---@param name string emote名
---@return Actor
function ACTOR_METHOD:set_default_emote(name)
    self.default_emote = name
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

--- アクター情報を作成する
---@return Actor
local function create_actor(name)
    local a = {
        name = name,
        talk_line = 1.0,
        scope_change_line = 1.5,
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
