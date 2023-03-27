---@diagnostic disable: lowercase-global

require "test"

-- とりあえずすぐ試したいテストはここに書く。

function test_entry_time_entry_match()
    local t = require "test.luaunit"
    local et = require "shiori.entry_time"

    local now = et.osdate(os.time(et.time_table("D211231T0123")))

    local pp = require "libs.pprint"
    local function X(entry)
        local a = et.entry_table(entry)
        local rc = et.entry_match(a, now)
        if rc then return a.priority end
        return nil
    end
    t.assertEquals(X("D211231"), 7.5)
    t.assertEquals(X("D1231"), 5.5)
    t.assertEquals(X("T0123"), 5)
    t.assertEquals(X("W6"), 5.3)

    t.assertIsNil(X("D221231"))
    t.assertIsNil(X("D1131"))
    t.assertIsNil(X("T0124"))
    t.assertIsNil(X("W1"))
end

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
