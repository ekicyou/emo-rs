
local RE_CAL_D = "D([%d%-][%d%-])([%d%-][%d%-])([%d%-][%d%-])"
local RE_CAL_W = "W(%d+)"
local RE_CAL_T = "T([%d%-][%d%-])([%d%-][%d%-])"
local RE_NUM = "^(%d+)$"

-- エントリをテーブル分解
local function cal_entry_table(entry)
    local function num(t)
        local s, e, m = string.find(t, RE_NUM)
        if m then
            return m+0
        else
            return nil
        end
    end
    local x = {sec=0,}
    local s, _, year, month, day = string.find(entry, RE_CAL_D)
    if s then
        x.year  = num(year)
        x.month = num(month)
        x.day   = num(day)
        if x.year then
            x.year = x.year + 2000
        end
    end
    local s, _, a, d, e = string.find(entry, RE_CAL_W)
    if s then
        x.weeks = a
    end
    local s, _, hour, min = string.find(entry, RE_CAL_T)
    if s then
        x.hour  = num(hour)
        x.min   = num(min)
    end
    return x
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

local function TO_DATE_TIME(d)
    local x = {
        year    = d.year,
        month   = d.month,
        day     = d.day,
        hour    = 0,
        min     = 0,
        sec     = 0,
    }
    return os.time(x)
end

function GEN.year(x,d)
    local is_hour = x.hour
    adjust_hour(x,d)
    -- 時分指定なし、日付違うなら日時を０に
    local x_date = TO_DATE_TIME(x)
    local d_date = TO_DATE_TIME(d)
    if not is_hour and x_date ~= d_date then 
        x.hour = 0
        x.min  = 0
        x.sec  = 0
    end
    coroutine.yield(os.time(x))
end

-- 年無し、月日あり
function GEN.month(x,d)
    local is_hour = x.hour
    adjust_hour(x,d)
    local d_date = TO_DATE_TIME(d)
    for i=0, 1 do
        x.year = d.year + i
        -- 時分指定なし、日付違うなら日時を０に
        local x_date = TO_DATE_TIME(x)
        if not is_hour and x_date ~= d_date then 
            x.hour = 0
            x.min  = 0
            x.sec  = 0
        end
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

-- 分のみ⇒今時、次時
function GEN.min(x,d)
    adjust_hour(x,d)
    x.year  = d.year
    x.month = d.month
    x.day = d.day
    for i=0, 1 do
        x.hour = d.hour + i
        local time = os.time(x)
        coroutine.yield(time)
    end
end


-- 指定時刻以後の、エントリ発動時刻を返す
local function cal_time(entry, now)
    local function TASK()
        local d = os.date("*t", now)
        local x = cal_entry_table(entry)
        if     x.year   then return GEN.year(x,d)
        elseif x.month  then return GEN.month(x,d)
        elseif x.day    then return GEN.month(x,d)
        elseif x.week   then return GEN.week(x,d)
        elseif x.hour   then return GEN.hour(x,d)
        else                 return GEN.min(x,d)
        end
    end
    local gen = coroutine.wrap(TASK)
    while true do
        local time = gen()
        if not time         then return nil
        elseif time > now   then return time
        end
    end
end

return {
    adjust_hour =adjust_hour,
    entry_table =cal_entry_table,
    time        =cal_time,
}