---@diagnostic disable: lowercase-global

require "test.hello"
require "test.wait_str"

-- とりあえずすぐ試したいテストはここに書く。


function test_dic_entry()
    local t = require "test.luaunit"
    local entry = require "emo.dic.entry"

    local a = entry.create()
    t.assertEquals(a.rate(), 1)
    a.talk1 = function(env)
    end
    a.talk2 = function(env)
    end
    t.assertEquals(#a, 2)
end

function test_scene()
    local dic = require "emo.dic"
    local actor = require "emo.dic.actor"
    local env = {}
    local wait = {
        050, -- 通常wait
        300, -- 半濁点
        400, -- エクステンション
        500, -- 濁点
        200, -- 点々
    }
    actor.register("えも", wait, {}, "通常")
    actor.register("紫", wait, {}, "通常")
    local scene = dic.create_scene(env)
    local a, b = scene:actor("えも", "紫")
end

-- ここまで
local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
