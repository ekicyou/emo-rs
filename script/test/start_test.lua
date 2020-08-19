require "test.utils.save_load"
require "test.shiori.response"
require "test.shiori.event"
require "test.shiori.utils"
require "test.shiori.load"
require "test.shiori.insert_wait"
require "test.talks.o"
require "test.talks.dkit"


-- とりあえずすぐ試したいテストはここに書く。

local RE_CAL = "^([%d%-][%d%-])([%d%-][%d%-])([%d%-][%d%-])T([%d%-][%d%-])([%d%-][%d%-])$"
local RE_CAL_W = "^W(%d+)T([%d%-][%d%-])([%d%-][%d%-])$"
local RE_NUM = "^(%d+)$"

-- エントリをテーブル分解
local function cal_entry_table(entry)
    local function num(t)
        local s, e, m = string.find(t, RE_NUM)
        if m then
            return m+0
        else
            return -1
        end
    end
    local i, j, a, b, c, d, e = string.find(entry, RE_CAL)
    if i then
        local x = {}
        x.year  = num(a)
        x.month = num(b)
        x.day   = num(c)
        x.hour  = num(d)
        x.min   = num(e)
        x.sec   = 0
        if x.year >= 0 then
            x.year = x.year + 2000
        end
        return x
    end
    local s, _, a, d, e = string.find(entry, RE_CAL_W)
    if s then
        local x = {}
        x.weeks = a
        x.hour  = num(d)
        x.min   = num(e)
        x.sec   = 0
        return x
    end
end

local function GET_TIME(x)
    local t = x.sec
    t = t   + x.min  *60
    t = t   + x.hour *60 *60
    return t
end
local function SET_TIME(x, time)
    local s = time %  60
    time    = time // 60
    local m = time %  60
    time    = time // 60
    local h = time %  24
    x.hour  = h
    x.min   = m
    x.sec   = s
end


-- 時・分の設定がない場合、現在時刻から数分進めた分に設定する。
local function adjust_hour(x,d)
    if x.hour then
        -- 時分指定　⇒そのまま返す
        -- 時のみ指定⇒０分にする。
        if not x.min then x.min = 0 end
        return
    else
        -- 分のみ指定⇒次の時を設定して終了
        if x.min then
            x.hour = d.hour
            local xt = GET_TIME(x)
            local dt = GET_TIME(d)
            if xt < dt then xt = xt + 60*60 end
            SET_TIME(x, xt)
            return
        end
    end

    -- 指定なし⇒現在時刻から数分後
    time = os.time(d)+91
    time = time // 60  * 60
    local d2 = os.date("*t", time)
    x.hour = d2.hour
    x.min  = d2.min
    x.sec  = d2.sec
end

-- 指定日時をベースに直近の月曜日午前０時を返す。
local function get_last_monday_time(d)
    local d2 = {
        year  = d.year,
        month = d.month,
        day   = d.day,
        hour  = 0,
        min   = 0,
        sec   = 0,
    }
    local zero_time = os.time(d2)
    -- wdayを取得
    local zero_date = os.date("*t", zero_time)
    local wday = zero_date.wday

    -- 直近のwday=2になるように日付をマイナス
    local day = wday -2
    if day < 0 then day = day + 7 end
    local mon_time =zero_time - day*60*60*24
    return mon_time
end

function test_get_last_monday_time(d)
    local date0 = {
        year    =2020,
        month   =   8,
        day     =  19,
        hour    =  12,
        min     =  34,
        sec     =  56,
    }
    local t = require "test.luaunit"
    local ser = require "libs.serpent"

    local monday = get_last_monday_time(date0)
    local x = os.date("*t", monday)
    t.assertEquals(x.year   ,2020)
    t.assertEquals(x.month  ,   8)
    t.assertEquals(x.day    ,  17)
    t.assertEquals(x.hour   ,   0)
    t.assertEquals(x.min    ,   0)
    t.assertEquals(x.sec    ,   0)
end


-- 指定時刻でまるめをおこなった、エントリ発動時刻を列挙していく
local GEN = {}

function GEN.year(x,d)
    adjust_hour(x,d)
    return os.time(x)
end

-- 年無し、月日あり
function GEN.month(x,d)
    adjust_hour(x,d)
    for i=0, 1 do
        x.year = d.year + i
        local time = os.time(x)
        coroutine.yield(time)
    end
end

-- 日のみ⇒今月の今日、来月の今日
function GEN.day(x,d)
    adjust_hour(x,d)
    x.year  = d.year
    for i=0, 1 do
        x.month = d.month + i
        local time = os.time(x)
        coroutine.yield(time)
    end
end

-- 週指定⇒今週と来週で週指定の日付列挙
function GEN.week(x,d)
    adjust_hour(x,d)

    for i=0, 1 do
        x.day = d.day + i
        local time = os.time(x)
        coroutine.yield(time)
    end
end

-- 時分のみ⇒今日、明日の日付
function GEN.hour(x,d)
    adjust_hour(x,d)
    x.year  = d.year
    x.month = d.month
    for i=0, 1 do
        x.day = d.day + i
        local time = os.time(x)
        coroutine.yield(time)
    end
end


-- 指定時刻以後の、エントリ発動時刻を返す
local function cal_time(entry, now)
    local function TASK()
        local d = os.date("*t", now)
        local x = cal_entry_table(entry)
        if      x.year  then return GEN.year(x,d)
        elseif x.month  then return GEN.month(x,d)
        elseif x.day    then return GEN.month(x,d)
        elseif x.week   then return GEN.week(x,d)
        else                 return GEN.hour(x,d)
        end
    end
    local gen = coroutine.warp(TASK)
    while true do
        local time = gen()
        if not time         then return nil
        elseif time > now   then return time
        end
    end
end


function test_calendar()
    local t = require "test.luaunit"
    local ser = require "libs.serpent"

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
    local x = cal_entry_table("210723T2345")
    t.assertEquals(x.year   , 2021)
    t.assertEquals(x.month  , 07)
    t.assertEquals(x.day    , 23)
    t.assertEquals(x.hour   , 23)
    t.assertEquals(x.min    , 45)
    local x = cal_entry_table("----23T----")
    t.assertEquals(x.year   , -1)
    t.assertEquals(x.month  , -1)
    t.assertEquals(x.day    , 23)
    t.assertEquals(x.hour   , -1)
    t.assertEquals(x.min    , -1)
    local x = cal_entry_table("W1234T1234")
    t.assertEquals(x.weeks  , "1234")
    t.assertEquals(x.hour   , 12)
    t.assertEquals(x.min    , 34)





    local cal_entry = {
        {cal= "------T0800"},
        {cal= "------T1315"},
        {cal= "------T2020"},
        {cal= "------T--30"},
        {cal= "------T--15"},
        {cal= "------T--45"},
        {cal= "--0214T----"},
        {cal= "--0819T----"},
        {cal= "--1010T----"},
        {cal= "--0815T1200"},
        {cal= "--0815T1200"},
        {cal=     "W1T1200"},
        {cal= "W23456T1200"},
        {cal= "210723T2000"},
    }


end


function test_check_hour()
    local t = require "test.luaunit"
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
    adjust_hour(x, d)
    t.assertEquals(x.hour, 12)
    t.assertEquals(x.min , 36)
    -- 時分あり
    x.hour = 23
    adjust_hour(x, d)
    t.assertEquals(x.hour, 23)
    t.assertEquals(x.min , 36)
    -- 時のみ
    x.hour = 12
    x.min  = nil
    adjust_hour(x, d)
    t.assertEquals(x.hour, 12)
    t.assertEquals(x.min ,  0)
    -- 分のみ
    x.hour = nil
    x.min  = 50
    adjust_hour(x, d)
    t.assertEquals(x.hour, 12)
    t.assertEquals(x.min , 50)
    x.hour = nil
    x.min  = 12
    adjust_hour(x, d)
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
