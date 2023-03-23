---@diagnostic disable: lowercase-global

function test_entry_time_entry_table()
    local t = require "test.luaunit"
    local et = require "shiori.entry_time"

    t.assertEquals(et.entry_table("D201231"), { year = 2020, month = 12, day = 31, sec = 0, })
    t.assertEquals(et.entry_table("D1231"), { month = 12, day = 31, sec = 0, })
    t.assertEquals(et.entry_table("D1231T1234"), { month = 12, day = 31, hour = 12, min = 34, sec = 0, })
    t.assertEquals(et.entry_table("T1234"), { hour = 12, min = 34, sec = 0, })
    t.assertEquals(et.entry_table("W2T1234"), { week = 2, hour = 12, min = 34, sec = 0, })
end

function test_entry_time_adjust_hour()
    local t = require "test.luaunit"
    local et = require "shiori.entry_time"

    local now = et.entry_table("D211231T0123")
    local function X(target)
        et.adjust_hour(target, now)
        return target
    end

    t.assertEquals(X({ hour = 10 }), { hour = 10, min = 0, sec = 0, })
    t.assertEquals(X({ hour = 12, min = 34 }), { hour = 12, min = 34, sec = 0, })
    t.assertEquals(X({}), { hour = 1, min = 24, sec = 0, })
end

function test_entry_time_get_last_monday_time()
    local t = require "test.luaunit"
    local et = require "shiori.entry_time"

    local now = et.entry_table("D211231T0123")
    local time = et.get_last_monday_time(now)
    t.assertEquals(time, 1640530800)
    local act = os.date("*t", time)
    t.assertEquals(act.year, 2021)
    t.assertEquals(act.wday, 2)
    t.assertEquals(act.month, 12)
    t.assertEquals(act.day, 27)
    t.assertEquals(act.hour, 0)
    t.assertEquals(act.min, 0)
end
