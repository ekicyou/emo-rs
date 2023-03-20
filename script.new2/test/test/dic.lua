---@diagnostic disable: lowercase-global

function test_dic_actor_register()
    local t = require "test.luaunit"
    local dic = require "emo.dic"
    local actor = require "emo.dic.actor"
    local env = {}
    actor.register("えも")
        :wait(50, 300, 400, 500, 200)
        :emote("通常", "\\s[1]")
    actor.register("紫")
        :wait(50, 300, 400, 500, 200)
        :emote("通常", "default")
    local scene = dic.create_scene(env)
    local a, b = scene:actor("えも", "紫")
    t.assertEquals(#a.actor.wait, 5)
    t.assertEquals(a.actor.name, "えも")
    t.assertEquals(a.actor.emote_dic["通常"], [=[\s[1]]=])
    t.assertEquals(a.actor.default_emote, "通常")
end

function test_dic_sakura_script_wait()
    local t = require "test.luaunit"
    local ss = require "emo.dic.sakura_script"

    t.assertEquals(ss.wait(50), "")
    t.assertEquals(ss.wait(51), "\\_w[1]")
    t.assertEquals(ss.wait(100), "\\w1")
    t.assertEquals(ss.wait(101), "\\_w[51]")
end

function test_dic_sakura_script_talk()
    local t = require "test.luaunit"
    local ss = require "emo.dic.sakura_script"

    -- ABC,!?xy,z-.az.bc･･･,def.
    -- 1111131121141141155531114
    local text = "ABC,!?xy,z-.az.bc///,def."
    local wait = {
        050, -- 通常wait
        300, -- 半濁点
        400, -- エクステンション
        500, -- 濁点
        200, -- 点々
    }
    t.assertEquals(ss.talk(wait, text), "ABC,!?\\w8xy,\\w6z-.\\_w[500]az.\\_w[500]bc/\\w3/\\w3/\\w3,\\w6def.\\_w[500]")
end
