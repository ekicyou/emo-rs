local ACTOR = {}

local function push_talk_raw(talk, s)
    if s == nil then
        return
    end
    talk.script = talk.script .. string(s)
end

local function push_talk_script(actor,script)
    local talk = actor.talk
    local raw = actor:script_to_raw(script)
    return push_talk_raw(talk, raw)
end

local function push_talk_table_arg(actor,talk,key,value)
    if type(arg)=="function" then
        local rc = arg()
        return push_talk_table_arg(actor,talk,rc,value)
    end
    local actor_value = actor[key]
    local tp = type(actor_value)
    if tp=="function" then
        local rc = actor_value(value)
        return push_talk_raw(talk, rc)
    elseif tp=="nil" then
        return push_talk_raw(talk, key)
    end
    return push_talk_raw(talk, actor_value)
end

local function push_talk_table(actor,t)
    local talk = actor.talk
    for _,v in ipairs(t) do
        push_talk_table_arg(actor, talk, v, nil)
    end
    for k,v in pairs(t) do
        push_talk_table_arg(actor, talk, k, v)
    end
end


local function push_talk(actor, arg, ...)
    local tp = type(arg)
    if tp=="nil" then
        return actor
    elseif tp=="function" then
        local rc = tp()
        if type(rc)~="nil" then
            return push_talk(actor,rc,...)
        end
    elseif tp=="string" then
        push_talk_script(actor,arg)
    elseif tp=="table" then
        push_talk_table(actor,arg)
    end
    return push_talk(actor,...)
end

-- 会話
local function call(actor, ...)
    return push_talk(actor, ...)
end

local meta_ACTOR = {__call = call, __index=ACTOR}

-- Wait設定(濁点, 感嘆詞, 半濁点, リーダ)
function ACTOR:set_wait(w1,w2,w3,w4)
    self.wait1 = w1
    self.wait2 = w2
    self.wait3 = w3
    self.wait4 = w4
end

-- スクリプトをRAW文字列へ変換する。
function ACTOR:script_to_raw(script)
    local raw = script
    return raw
end


local actors = {}

-- actor作成
local function add(name)
    -- actor オブジェクト
    local actor = {}
    setmetatable(actor, meta_ACTOR)
    actor.name = name
    actors[name] = actor
    return actor
end

-- 全actor取得
local function actors()
    return actors
end

-- actor モジュール
local MOD = {
    add = add,
    actors = actors,
}

return MOD