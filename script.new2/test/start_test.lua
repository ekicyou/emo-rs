---@diagnostic disable: lowercase-global

require "test"

-- とりあえずすぐ試したいテストはここに書く。

function test_entry_time_fire_entry()
    local t = require "test.luaunit"
    local et = require "shiori.entry_time"
end

function test_dic_entry()
    local t = require "test.luaunit"
    local entry = require "emo.dic.entry"

    local a = entry.create()
    t.assertEquals(a.rate(), 1)
    a.talk1 = function(env)
    end
    a.talk2 = function(env)
    end
    t.assertEquals(#a, 0)
end

-- ここまで
local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_DEFAULT)
local rc = t.run()
