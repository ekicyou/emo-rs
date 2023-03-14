-- scene（スクリプト合成、発行）管理
local MOD = {}
local entry = require "emo.dic.entry"
local actor = require "emo.dic.actor"

--- @class Scene
local METHOD = {}
local META = {}
META.__index = METHOD

--- actorの取得、アクター名の一覧を渡す。
function METHOD:actor(...)
    return actor.create(self, ...)
end

--- text をそのままスクリプトに登録する。
function METHOD:append_raw_script(text)
    if self.raw_script == nil then
        self.raw_script = ''
    end
    self.raw_script = self.raw_script .. text
end

--- text をwait設定で変換してスクリプトに登録する。
function METHOD:append_talk(text, wait1, wait2, wait3)
    self:append_raw_script(text)
end


-- ローカルエントリーの作成
function METHOD:local_entry()
    return entry.create()
end


-- scene作成
function MOD.create(env)
    --- @class Scene
    local scene = {
        raw_script = ''
    }
    setmetatable(scene, META)
    return scene
end

return MOD
