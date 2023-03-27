---@diagnostic disable: lowercase-global

function test_entry_time_entry_table()
    local t = require "test.luaunit"
    local et = require "shiori.entry_time"

    t.assertEquals(et.date_table("D201231"), { year = 2020, month = 12, day = 31, })
    t.assertEquals(et.date_table("D1231"), { month = 12, day = 31, })
    t.assertEquals(et.date_table("D1231T1234"), { month = 12, day = 31, hour = 12, min = 34, })
    t.assertEquals(et.date_table("T1234"), { hour = 12, min = 34, })
    t.assertEquals(et.date_table("W2T1234"), { wday = 2, hour = 12, min = 34, })
end

function test_entry_time_get_last_monday_time()
    local t = require "test.luaunit"
    local et = require "shiori.entry_time"

    local now = et.date_table("D211231T0123")
    local time = et.get_last_monday_time(now)
    t.assertEquals(time, 1640530800)
    local act = et.osdate(time)
    t.assertEquals(act.year, 2021)
    t.assertEquals(act.wday, 2)
    t.assertEquals(act.month, 12)
    t.assertEquals(act.day, 27)
    t.assertEquals(act.hour, 0)
    t.assertEquals(act.min, 0)
end

function test_entry_time_entry_match()
    local t = require "test.luaunit"
    local et = require "shiori.entry_time"

    local now = et.osdate(os.time(et.date_table("D211231T0123")))

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
