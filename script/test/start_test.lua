require "test.utils.save_load"
require "test.shiori.response"
require "test.shiori.event"
require "test.shiori.utils"
require "test.shiori.load"
require "test.shiori.insert_wait"
require "test.talks.o"
require "test.talks.dkit"


-- とりあえずすぐ試したいテストはここに書く。

function test_get_last_monday_time(d)
    local date0 = {
        year    =2020,
        month   =   8,
        day     =  19,
        hour    =  12,
        min     =  34,
        sec     =  56,
    }
    local cal = require "talks.cal_time"
    local t = require "test.luaunit"
    local ser = require "libs.serpent"

    local monday = cal.get_last_monday_time(date0)
    local x = os.date("*t", monday)
    t.assertEquals(x.year   ,2020)
    t.assertEquals(x.month  ,   8)
    t.assertEquals(x.day    ,  17)
    t.assertEquals(x.hour   ,   0)
    t.assertEquals(x.min    ,   0)
    t.assertEquals(x.sec    ,   0)
end

function test_calendar()
    local t = require "test.luaunit"
    local ser = require "libs.serpent"
    local cal = require "talks.cal_time"

    local function DT(t) 
        return os.date("%Y%m%dT%H%M", t)
    end

    local date0 = {
        year    =2020,
        month   =   8,
        day     =  19,
        hour    =   0,
        min     =   0,
        sec     =   0,
    }
    local time0 = os.time(date0)
    t.assertEquals(time0, 1597762800)
    local time1315 = time0 + 60*60*13 + 60*15
    date0.hour  = 13
    date0.min   = 15
    local exp =  os.time(date0)
    t.assertEquals(time1315, exp)

    -- エントリのパース
    local x = cal.entry_table("D210723T2345")
    t.assertEquals(x.year   , 2021)
    t.assertEquals(x.month  , 07)
    t.assertEquals(x.day    , 23)
    t.assertEquals(x.hour   , 23)
    t.assertEquals(x.min    , 45)
    local x = cal.entry_table("D----23T----")
    t.assertEquals(x.year   , nil)
    t.assertEquals(x.month  , nil)
    t.assertEquals(x.day    , 23)
    t.assertEquals(x.hour   , nil)
    t.assertEquals(x.min    , nil)
    local x = cal.entry_table("W1234T1234")
    t.assertEquals(x.week   , "1234")
    t.assertEquals(x.hour   , 12)
    t.assertEquals(x.min    , 34)

    -- 結果計算
    --print(DT(time1315))     --時刻指定           現在時刻：20200819T1315
    t.assertEquals(DT(cal.time(     "W2T1234", time1315)) , "20200825T1234")
    t.assertEquals(DT(cal.time(     "W3T1234", time1315)) , "20200826T1234")
    t.assertEquals(DT(cal.time(     "W4T1234", time1315)) , "20200820T1234")
    t.assertEquals(DT(cal.time("D------T0800", time1315)) , "20200820T0800")
    t.assertEquals(DT(cal.time("D------T1500", time1315)) , "20200819T1500")
    t.assertEquals(DT(cal.time("D------T--30", time1315)) , "20200819T1330")
    t.assertEquals(DT(cal.time("D------T--15", time1315)) , "20200819T1415")
    t.assertEquals(DT(cal.time("D200819T----", time1315)) , "20200819T1316")
    t.assertEquals(DT(cal.time("D200820T----", time1315)) , "20200820T0000")
    t.assertEquals(DT(cal.time("D--0818T----", time1315)) , "20210818T0000")
    t.assertEquals(DT(cal.time("D--0819T----", time1315)) , "20200819T1316")
    t.assertEquals(DT(cal.time("D--0820T----", time1315)) , "20200820T0000")
    t.assertEquals(DT(cal.time("D200820T1234", time1315)) , "20200820T1234")


    local cal_entry = {
        {cal= "D210723T2000"},
        {cal=  "W23456T1200"},
        {cal=      "W1T1200"},
        {cal= "D--0815T1200"},
        {cal= "D--0815T1200"},
        {cal= "D------T0800"},
        {cal= "D------T1315"},
        {cal= "D------T2020"},
        {cal= "D------T--30"},
        {cal= "D------T--15"},
        {cal= "D------T--45"},
        {cal= "D--0214T----"},
        {cal= "D--0819T----"},
        {cal= "D--1010T----"},
    }
    local i,v = cal.peek_entry(cal_entry, time1315)
    t.assertEquals(   v.cal   , "D--0819T----")
    t.assertEquals(DT(v.time) , "20200819T1316")

    local v = cal.pull_entry(cal_entry, time1315)
    t.assertEquals(   v.cal   , "D--0819T----")
    t.assertEquals(DT(v.time) , "20200819T1316")

    local v = cal.pull_entry(cal_entry, time1315)
    t.assertEquals(   v.cal   , "D------T--30")
    t.assertEquals(DT(v.time) , "20200819T1330")

end


function test_check_hour()
    local t = require "test.luaunit"
    local cal = require "talks.cal_time"
    local d = {
        year    =2020,
        month   =   8,
        day     =  19,
        hour    =  12,
        min     =  34,
        sec     =  56,
    }
    -- 指定なし
    local x = {}
    cal.adjust_hour(x, d)
    t.assertEquals(x.hour, 12)
    t.assertEquals(x.min , 36)
    -- 時分あり
    x.hour = 23
    cal.adjust_hour(x, d)
    t.assertEquals(x.hour, 23)
    t.assertEquals(x.min , 36)
    -- 時のみ
    x.hour = 12
    x.min  = nil
    cal.adjust_hour(x, d)
    t.assertEquals(x.hour, 12)
    t.assertEquals(x.min ,  0)
    -- 分のみ
    x.hour = nil
    x.min  = 50
    cal.adjust_hour(x, d)
    t.assertEquals(x.hour, 12)
    t.assertEquals(x.min , 50)
    x.hour = nil
    x.min  = 12
    cal.adjust_hour(x, d)
    t.assertEquals(x.hour, 13)
    t.assertEquals(x.min , 12)
end

function test_cts()
    local t = require "test.luaunit"
    local ser = require "libs.serpent"
    local cts = require "shiori.cts"

    local function drop_action()
        print("drop: func_a")
    end
    local function func_a(ct)
        ct:reg(drop_action)
        ct:reg(function()
            print("drop: anonymous")
        end)
    end

    local ok, rc = cts.using(func_a)

    local ok, rc = cts.using(function(ct)
        print("exec: using1")
        ct:reg(function()
            print("drop: using1")
        end)
        print("exec: using2")
        ct:reg(function()
            print("drop: using2")
        end)
    end)

end


-- ここまで

local t = require "test.luaunit"
t.set_verbosity(t.VERBOSITY_VERBOSE)
local rc = t.run()
