-- scene管理
local MOD = {}
local local_entry = require "emo.dic.local_entry"

local SCENE_META = {}

-- actorの取得
function SCENE_META:actor(...)
    error('NOT_IMPL')
end

-- ローカルエントリーの作成
function SCENE_META:local_entry()
    error('NOT_IMPL')
end


-- scene作成
function MOD.create(env)
    local scene = {}
    setmetatable(scene, SCENE_META)
    return scene
end

return MOD
