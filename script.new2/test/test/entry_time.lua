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
        local a = et.create_entry(entry)
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

function test_entry_time_calc_fire_time()
    local t = require "test.luaunit"
    local et = require "shiori.entry_time"
    local now_time = os.time(et.date_table("D211231T0123"))
    local now = et.osdate(now_time)
    local function TRIM(s)
        return (s:gsub("^%s*(.-)%s*$", "%1"))
    end
    local function X(entry, ext_s, ext_e)
        local table = et.date_table(TRIM(entry))
        local s, e = et.calc_fire_time(table, now_time, now)
        if s == nil and ext_s == nil then return end
        local act_s = os.date("%Y%m%d_%H%M%S", s)
        local act_e = os.date("%Y%m%d_%H%M%S", e)
        t.assertEquals(act_s, ext_s, "s")
        t.assertEquals(act_e, ext_e, "e")
    end
    --"D211231T0123"
    X("D211231T0123", "20211231_012300", "20211231_012400")
    X("D211231T0159", "20211231_015900", "20211231_020000")
    X("D211231     ", "20211231_000000", "20220101_000000")
    X("D211231T0122", nil)
    X("D211230     ", nil)
    X("D1231       ", "20211231_000000", "20220101_000000")
    X("D1230       ", "20221230_000000", "20221231_000000")
    X("W1          ", "20220102_000000", "20220103_000000")
    X("W2          ", "20220103_000000", "20220104_000000")
    X("W3          ", "20220104_000000", "20220105_000000")
    X("W4          ", "20220105_000000", "20220106_000000")
    X("W5          ", "20220106_000000", "20220107_000000")
    X("W6          ", "20211231_000000", "20220101_000000")
    X("W7          ", "20220101_000000", "20220102_000000")
    X("T0123       ", "20211231_012300", "20211231_012400")
    X("T0122       ", "20220101_012200", "20220101_012300")
    X("M23         ", "20211231_012300", "20211231_012400")
    X("M22         ", "20211231_022200", "20211231_022300")
end

function test_entry_time_update_entries()
    local t = require "test.luaunit"
    local et = require "shiori.entry_time"

    local entries = {}
    local function ENT(keyword)
        local a = { time_keyword = keyword }
        table.insert(entries, a)
    end

    ENT("D211231T0123")
    ENT("D211231T0159")
    ENT("D211231     ")
    ENT("D211231T0122")
    ENT("D211230     ")
    ENT("D1231       ")
    ENT("D1230       ")
    ENT("W1          ")
    ENT("W2          ")
    ENT("W3          ")
    ENT("W4          ")
    ENT("W5          ")
    ENT("W6          ")
    ENT("W7          ")
    ENT("T0123       ")
    ENT("T0122       ")
    ENT("M23         ")
    ENT("M22         ")

    local now_time = os.time(et.date_table("D211231T0123"))

    et.update_entries(entries, now_time)

    local function X(keyword, ext_s, ext_e)
        for _, v in ipairs(entries) do
            if v.time_keyword == keyword then
                if v.time_fire == nil and ext_s == nil then return end
                local s = v.time_fire.s_time
                local e = v.time_fire.e_time
                local act_s = os.date("%Y%m%d_%H%M%S", s)
                local act_e = os.date("%Y%m%d_%H%M%S", e)
                t.assertEquals(act_s, ext_s, "s")
                t.assertEquals(act_e, ext_e, "e")
                return
            end
        end
        t.fail("not found")
    end

    X("D211231T0123", "20211231_012300", "20211231_012400")
    X("D211231T0159", "20211231_015900", "20211231_020000")
    X("D211231     ", "20211231_000000", "20220101_000000")
    X("D211231T0122", nil)
    X("D211230     ", nil)
    X("D1231       ", "20211231_000000", "20220101_000000")
    X("D1230       ", "20221230_000000", "20221231_000000")
    X("W1          ", "20220102_000000", "20220103_000000")
    X("W2          ", "20220103_000000", "20220104_000000")
    X("W3          ", "20220104_000000", "20220105_000000")
    X("W4          ", "20220105_000000", "20220106_000000")
    X("W5          ", "20220106_000000", "20220107_000000")
    X("W6          ", "20211231_000000", "20220101_000000")
    X("W7          ", "20220101_000000", "20220102_000000")
    X("T0123       ", "20211231_012300", "20211231_012400")
    X("T0122       ", "20220101_012200", "20220101_012300")
    X("M23         ", "20211231_012300", "20211231_012400")
    X("M22         ", "20211231_022200", "20211231_022300")
end
