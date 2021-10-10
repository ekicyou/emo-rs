local ACTOR = {}

-- 引数が関数、あるいは関数を持つテーブルの場合にtrueを返す。
local function is_function(v)
    local tp = type(v)
    if tp=="function" then
        return true
    elseif tp=="table" then
        local meta = getmetatable(v)
        if meta.__call then
            return true
        end
    end
    return false
end

-- 引数が関数または関数と解釈可能なテーブルの場合、関数を呼び出して値を返す。
local function fn2result(v)
    if is_function(v) then
        return fn2result(v())
    end
    return v
end

local function push_talk_raw(talk, s)
    if s == nil then
        return
    end
    talk.script = talk.script .. string(s)
end

local function push_script(actor,script)
    local talk = actor.talk
    local raw = actor:script_to_raw(script)
    return push_talk_raw(talk, raw)
end

local function push_talk_table_arg(actor,talk,key,value)
    local dic_value = actor[key]
    local tp = type(dic_value)
    if is_function(dic_value) then
        local rc = dic_value(value)
        return push_talk_raw(talk, rc)
    elseif tp=="nil" then
        return push_talk_raw(talk, key)
    end
    return push_talk_raw(talk, dic_value)
end

local function push_table(actor,t)
    local talk = actor.talk
    for _,v in ipairs(t) do
        v = fn2result(v)
        push_talk_table_arg(actor, talk, v, nil)
    end
    for k,v in pairs(t) do
        v = fn2result(v)
        push_talk_table_arg(actor, talk, k, v)
    end
end


local function push_talk(actor, arg, ...)
    arg = fn2result(arg)
    if type(arg)=="table" then
        push_table(actor,arg)
    else
        push_script(actor,arg)
    end
    if #{...}>0 then
        return push_talk(actor,...)
    end
    return actor
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