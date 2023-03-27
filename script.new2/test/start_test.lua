---@diagnostic disable: lowercase-global

require "test"

-- とりあえずすぐ試したいテストはここに書く。

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
