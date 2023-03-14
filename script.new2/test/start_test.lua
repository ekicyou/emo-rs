---@diagnostic disable: lowercase-global

require "test.hello"

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
    local env = {}
    local scene = dic.create_scene(env)
    local a, b = scene:actor("えも", "紫")





end


-- ここまで
local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
