local scene = require "scene"
local えも = require "actor_emo"
local 紫   = require "actor_murasaki"


function 梅雨のお天気(env)
    local s = scene.open(えも, 紫)
    s.talk(えも, [=[＠笑顔　今日はいい天気ですね。]=])
    s.talk(紫  , [=[＠通常　明日も天気は良さそうです。]=])





end