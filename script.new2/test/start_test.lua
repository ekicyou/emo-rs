---@diagnostic disable: lowercase-global

require "test"

-- とりあえずすぐ試したいテストはここに書く。

function test_entry_time_fire_entry()
    local t = require "test.luaunit"
    local et = require "shiori.entry_time"

    local now = et.entry_table("D211231T0123")
    local now_time = os.time(now)
    t.assertEquals(now_time, 1640881380)

    local items = {}
    local function ENTRY(id, cal)
        local entry = { cal = cal, id = id, }
        table.insert(items, entry)
    end

    ENTRY(1, "D1124")
    local flag, entry = et.fire_entry(50, items, now_time)
    t.assertEquals(flag, 0)
    t.assertEquals(entry.id, 1)
    t.assertEquals(entry.time, 1669215600)

    ENTRY(2, "D211123")
    flag, entry = et.fire_entry(50, items, now_time)
    t.assertEquals(flag, 0)
    t.assertEquals(entry.id, 1)
    t.assertEquals(entry.time, 1669215600)
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
