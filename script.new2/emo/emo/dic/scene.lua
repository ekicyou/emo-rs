-- scene管理
local MOD = {}
local entry = require "emo.dic.entry"

local META = {}
local METHID = {}
META.__index = METHID

-- actorの取得
function METHID:actor(...)
    return ...
end

-- ローカルエントリーの作成
function METHID:local_entry()
    error('NOT_IMPL')
end



-- scene作成
function MOD.create(env)
    local scene = {}
    setmetatable(scene, META)
    return scene
end

return MOD
