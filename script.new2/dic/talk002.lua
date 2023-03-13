local dic = require "emo.dic"
local ev = dic.event.OnTalk
local _ = dic.word

ev.t001 = function(scene)
    local a, b = scene.actor("えも", "紫")
    local tenki = scene.local_jump()
    scene.start = function()
        a "今日の天気は？"
        tenki()
    end
    tenki.a = function()
        b "晴れだよ。"
        a "にっこり。"
    end
    tenki.b = function()
        b "雨だよ。"
        a "がっかり。"
    end
    scene.action()
end
