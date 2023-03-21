-- actor管理
local MOD = {}

local wait_str = require "emo.dic.wait_str"

-- ============================================================
-- actor
-- ============================================================

--- アクター
--- @class Actor
local ACTOR_METHOD = {}
local ACTOR_META = {}
ACTOR_META.__index = ACTOR_METHOD

-- トークの追加
function ACTOR_META:__call(...)
    local emote, script = ...
    if script == nil then
        script = emote
        emote = nil
    end
    return self:talk(emote, script)
end

local function WAIT(ms)
    local wait_ms = ms - 50
    if wait_ms <= 50 then return "" end
    local w50 = math.floor(wait_ms / 50)
    local remain = wait_ms - (w50 * 50)
end

-- トークの追加
function ACTOR_METHOD:talk(emote, script)
    error('NOT_IMPL')
end

-- ============================================================
-- actor定義
-- ============================================================

--- アクター定義
--- @class ActorParams
local PARAMS_METHOD = {}
local PARAMS_META = {}
PARAMS_META.__index = PARAMS_METHOD

--- wait情報を設定する。
--- @param wait1 number 一般文字wait、直前の残waitを確定
---@param wait2 number 半濁点
---@param wait3 number エクステンション（！、？）
---@param wait4 number 濁点
---@param wait5 number 点々、直前の残waitを確定
---@return ActorParams
function PARAMS_METHOD:wait(wait1, wait2, wait3, wait4, wait5)
    self.wait = { wait1, wait2, wait3, wait4, wait5 }
    return self
end

--- emote情報を設定する。
---@param name string emote名
---@param script string 展開するスクリプト
---@return ActorParams
function PARAMS_METHOD:emote(name, script)
    if not self.emote_dic then self.emote_dic = {} end
    if not self.default_emote then self.default_emote = name end
    self.emote_dic[name] = script
    return self
end

--- wait情報を設定する。
---@param name string emote名
---@return ActorParams
function PARAMS_METHOD:set_default_emote(name)
    self.default_emote = name
    return self
end

--- スコープ切り替え時の改行幅を設定する。
---@param em number 改行幅
---@return ActorParams
function PARAMS_METHOD:set_scope_change_line(em)
    self.scope_change_line = em
    return self
end

--- 新しいトークの改行幅を設定する。
---@param em number 改行幅
---@return ActorParams
function PARAMS_METHOD:set_talk_line(em)
    self.talk_line = em
    return self
end

--- アクター情報を作成する
---@return ActorParams
local function create_params(name)
    local a = {
        name = name,
        talk_line = 1.0,
        scope_change_line = 1.5,
    }
    setmetatable(a, PARAMS_META)
    return a
end

-- ============================================================
-- モジュール
-- ============================================================

local actor_dic = {} -- actorデータ辞書

--- actor定義の登録
--- @return ActorParams
function MOD.register(name)
    local a = create_params(name)
    actor_dic[name] = a
    return a
end

--- actorの取得
local function create_actor(scene, scope, name)
    local a = {
        scene = scene,
        scope = nil,
        actor = actor_dic[name],
    }
    setmetatable(a, ACTOR_META)
    return a
end

--- actorの取得
---@return Actor
function MOD.create(scene, ...)
    local actors = {}
    for i, name in ipairs({ ... }) do
        local a = create_actor(scene, i, name)
        table.insert(actors, a)
    end
    return unpack(actors)
end

return MOD
