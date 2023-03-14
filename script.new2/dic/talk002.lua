local dic = require "emo.dic"
local ev = dic.event.OnTalk
local _ = dic.word

ev.rate = function(env)
    return 1
end

ev.t001 = function(env)
    local scene = dic.create_scene(env)
    local a, b = scene:actor("えも", "紫")
    local tenki = scene:local_entry()
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
end

