local TALK = {}
local meta_TALK = {__index=TALK}












-- TALK オブジェクトの作成
local function create()
    local obj = {}
    setmetatable(obj, meta_TALK)
    obj.＠ = require "emo.dic"
    local actor = require "emo.actor"
    for k,v in pairs(actor.actors()) do
        obj[k] = v
    end
    return obj
end

-- ＠：emo.talk モジュール
local MOD = {
    create = create,
}

return MOD