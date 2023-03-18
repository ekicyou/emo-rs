-- actor管理
local MOD = {}

--- @class Actor
local METHOD = {}
local META = {}
META.__index = METHOD

-- トークの追加
function META:__call(...)
    local emote, script = ...
    if script == nil then
        script = emote
        emote = nil
    end
    return self:talk(emote, script)
end

-- トークの追加
function METHOD:talk(emote, script)
    error('NOT_IMPL')
end

local actor_dic = {}

-- actor登録
function MOD.register(name, wait, emote_dic, default_emote)
    local a = {
        name = name,
        emote_dic = emote_dic,
        default_emote = default_emote,
        emote = default_emote,
        wait = wait,
    }
    actor_dic[name] = a
end

-- actorの取得
local function create_actor(scene, name)
    local a = {
        scene = scene,
        actor = actor_dic[name],
    }
    setmetatable(a, META)
    return a
end

--- actorの取得
---@return Actor
function MOD.create(scene, ...)
    local actors = {}
    for _, name in ipairs({ ... }) do
        local a = create_actor(scene, name)
        table.insert(actors, a)
    end
    return table.unpack(actors)
end

return MOD
