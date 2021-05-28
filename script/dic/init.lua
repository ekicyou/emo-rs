local scene = require "scene"
local えも = require "actor_emo"
local 紫   = require "actor_murasaki"


function えも＠笑顔(ev)
    ev.scene.raw("")
end

function えも＠通常(ev)
    ev.scene.raw("")
end

function 紫＠笑顔(ev)
    ev.scene.raw("")
end

function 紫＠通常(ev)
    ev.scene.raw("")
end

function ＠梅雨のお天気(ev)
    local s = scene.open(えも, 紫)
    s.talk(えも, [=[＠笑顔　今日はいい天気ですね。]=])
    s.talk(紫  , [=[＠通常　明日も天気は良さそうです。]=])
    s.cut()

    local function A()
    end
    local function B()
    end

    s.call(A,B)

    return s.jump("梅雨のお天気＠")
end


function 梅雨のお天気＠返答１(env)

end