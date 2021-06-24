local ecs = require "libs.ecs"
local world = require "world"

local function x(e)
    return world.addEntity(e)
end

local えも = x({ actor = 1, name= "えも"})
local 紫   = x({ actor = 2, name= "紫"  })

x({
    ＠ = {
        x({talk={actor=えも, script="＠通常　明日の天気は？"}}),
        x({next="明日の天気は？"}),
}})

x({
    明日の天気は？ = {
        x({talk={actor=紫  , script="＠笑顔　晴れたらいいね。"}}),
}})

x({
    明日の天気は？ = {
        x({talk={actor=紫  , script="＠にやり　大雨かも知れません。"}}),
        x({talk={actor=えも, script="＠ぐんにょり　嫌だなあ‥‥"}}),
}})
