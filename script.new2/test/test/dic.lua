---@diagnostic disable: lowercase-global

-- actorの読込
do
    local actor = require "emo.dic.actor"
    actor.register("えも")
        :wait(50, 300, 400, 500, 200)
        :emote("通常", "\\s[1]")
    actor.register("紫")
        :wait(50, 300, 400, 500, 200)
        :emote("通常", "default")
end

function test_dic_actor_register()
    local t = require "test.luaunit"
    local dic = require "emo.dic"
    local env = {}
    local scene = dic.create_scene(env)
    local a, b = scene:actor("えも", "紫")
    t.assertEquals(#a.actor.wait, 5)
    t.assertEquals(a.actor.name, "えも")
    t.assertEquals(a.actor.emote_dic["通常"], [=[\s[1]]=])
    t.assertEquals(a.actor.default_emote, "通常")
end
