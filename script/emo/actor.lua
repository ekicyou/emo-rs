local ACTOR = {}
local meta_ACTOR = {__index=ACTOR}


-- ACTOR の初期化
function ACTOR:set_name(n)
    self.name = n
end

-- Wait設定(濁点, 感嘆詞, 半濁点, リーダ)
function ACTOR:set_wait(w1,w2,w3,w4)
    self.wait1 = w1
    self.wait2 = w2
    self.wait3 = w3
    self.wait4 = w4
end



-- actor作成
local function create()
    local actor = {}
    setmetatable(actor, meta_ACTOR)
    return actor
end

return create