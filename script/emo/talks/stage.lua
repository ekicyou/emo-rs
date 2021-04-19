local ACTOR = {}
local meta_ACTOR = {__index=ACTOR}


-- ACTOR の初期化
function ACTOR:init()
    self:set_wait(900, 400, 200)
end

-- Wait設定(濁点, 半濁点, リーダ)
function ACTOR:set_wait(w1,w2,w3)
    self.wait1 = w1
    self.wait2 = w2
    self.wait3 = w3
end


-- ACTOR辞書
local ACTORS = {}

-- name の ACTOR が存在しないときの処理⇒ ACTOR 作成
ACTORS.__index = function(table, key)
    local actor={name=key}
    setmetatable(actor, meta_ACTOR)
    actor:init()
    ACTORS[key] = actor
    return actor
end


-- ステージ
local STAGE = {}
local meta_STAGE = {__index=STAGE}

-- ACTOR 作成（原則、１回だけ行うこと）
function STAGE:create_actor(name)
    local actor = ACTORS[name]
    return actor
end


-- STAGE の開始
local function start_stage()
    local stage = {}
    setmetatable(stage, meta_STAGE)
    return stage
end



return start_stage