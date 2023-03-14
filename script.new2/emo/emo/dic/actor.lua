-- actor管理
local MOD = {}

local META = {}
local METHID = {}
META.__index = METHID

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
function METHID:talk(emote, script)
    error('NOT_IMPL')
end


local actor_dic = {}

-- actor登録
function MOD.register(name, emote_dic, default_emote, wait1, wait2, wait3, env)
    local a = {
        name = name,
        emote_dic = emote_dic,
        default_emote = default_emote,
        emote = default_emote,
        wait1 = wait1,
        wait2 = wait2,
        wait3 = wait3,
        env = env,
    }
    actor_dic[name] = a
end

-- actorの取得
local function create_actor(scene, name)
    local a = {
        scene = scene,
        data = actor_dic[name],
    }
    setmetatable(a, META)
    return a
end

-- actorの取得
function MOD.create(scene, ...)
    local actors = {}
    for name in ... do
        local a = create_actor(scene, name)
        table.insert(actors, a)
    end
    return table.unpack(actors)
end


return MOD
