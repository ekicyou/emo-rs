local RE_CAL_D1 = "D([%d%-][%d%-])([%d%-][%d%-])([%d%-][%d%-])"
local RE_CAL_D2 = "D([%d%-][%d%-])([%d%-][%d%-])"
local RE_CAL_W = "W(%d+)"
local RE_CAL_T = "T([%d%-][%d%-])([%d%-][%d%-])"
local RE_NUM = "^(%d+)$"

-- エントリをテーブル分解
local function cal_entry_table(entry)
    local function NUM(t)
        local _, _, m = string.find(t, RE_NUM)
        if m then
            return m + 0
        else
            return nil
        end
    end

    local x = { sec = 0, }
    local s, _, year, month, day = string.find(entry, RE_CAL_D1)
    if s then
        x.year  = NUM(year)
        x.month = NUM(month)
        x.day   = NUM(day)
        if x.year then
            x.year = x.year + 2000
        end
    else
        local s, _, month, day = string.find(entry, RE_CAL_D2)
        if s then
            x.month = NUM(month)
            x.day   = NUM(day)
        end
    end
    local s, _, a = string.find(entry, RE_CAL_W)
    if s then
        x.week = NUM(a)
    end
    local s, _, hour, min = string.find(entry, RE_CAL_T)
    if s then
        x.hour = NUM(hour)
        x.min  = NUM(min)
    end
    return x
end

local function GET_TIME(x)
    local t = x.sec
    t = t + x.min * 60
    t = t + x.hour * 60 * 60
    return t
end
local function SET_TIME(x, time)
    local s = time % 60
    time    = math.floor(time / 60)
    local m = time % 60
    time    = math.floor(time / 60)
    local h = time % 24
    x.hour  = h
    x.min   = m
    x.sec   = s
end


--- 時・分の設定がない場合、現在時刻から数分進めた分に設定する。
--- @param target table 調整対象の時分
--- @param now table 現在の時分
local function adjust_hour(target, now)
    if target.hour then
        -- 時分指定　⇒そのまま返す
        -- 時のみ指定⇒０分にする。
        if not target.min then target.min = 0 end
        if not target.sec then target.sec = 0 end
        return
    else
        -- 分のみ指定⇒次の時を設定して終了
        if target.min then
            target.hour = now.hour
            local xt = GET_TIME(target)
            local dt = GET_TIME(now)
            if xt < dt then xt = xt + 60 * 60 end
            SET_TIME(target, xt)
            return
        end
    end

    -- 指定なし⇒現在時刻から数分後
    local time  = os.time(now) + 91
    time        = math.floor(time / 60) * 60
    local d2    = os.date("*t", time)
    target.hour = d2.hour
    target.min  = d2.min
    target.sec  = d2.sec
end

-- 指定日時をベースに直近の月曜日午前０時を返す。
local function get_last_monday_time(target)
    local d2 = {
        year  = target.year,
        month = target.month,
        day   = target.day,
        hour  = 0,
        min   = 0,
        sec   = 0,
    }
    local zero_time = os.time(d2)
    -- wdayを取得
    local zero_date = os.date("*t", zero_time)
    local wday = zero_date.wday

    -- 直近のwday=2になるように日付をマイナス
    local day = wday - 2
    if day < 0 then day = day + 7 end
    local mon_time = zero_time - day * 60 * 60 * 24
    return mon_time
end


-- 指定時刻でまるめをおこなった、エントリ発動時刻を列挙していく
local GEN = {}

local function TO_DATE_TIME(d)
    local x = {
        year  = d.year,
        month = d.month,
        day   = d.day,
        hour  = 0,
        min   = 0,
        sec   = 0,
    }
    return os.time(x)
end

function GEN.year(x, d)
    local is_hour = x.hour
    adjust_hour(x, d)
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
function GEN.month(x, d)
    local is_hour = x.hour
    adjust_hour(x, d)
    local d_date = TO_DATE_TIME(d)
    for i = 0, 1 do
        x.year = d.year + i
        -- 時分指定なし、日付違うなら日時を０に
        local x_date = TO_DATE_TIME(x)
        if not is_hour and x_date ~= d_date then
            x.hour = 0
            x.min  = 0
            x.sec  = 0
        end
        local time = os.time(x)
        coroutine.yield(time, not is_hour)
    end
end

-- 日のみ⇒今月の今日、来月の今日
function GEN.day(x, d)
    adjust_hour(x, d)
    x.year = d.year
    for i = 0, 1 do
        x.month = d.month + i
        local time = os.time(x)
        coroutine.yield(time)
    end
end

-- 週指定⇒今週と来週で週指定の日付列挙
function GEN.week(x, d)
    local is_hour = x.hour
    adjust_hour(x, d)
    local d_date      = TO_DATE_TIME(d)
    local monday_time = get_last_monday_time(d)
    local n_date      = os.date("*t", monday_time)
    x.year            = n_date.year
    x.month           = n_date.month
    for i = 0, 1 do
        for j = 1, #x.week do
            local c = string.sub(x.week, j, j) + 0
            x.day = n_date.day + i * 7 + c - 1
            -- 時分指定なし、日付違うなら日時を０に
            if not is_hour then
                local x_date = TO_DATE_TIME(x)
                if not is_hour and x_date ~= d_date then
                    x.hour = 0
                    x.min  = 0
                    x.sec  = 0
                end
            end

            local time = os.time(x)
            coroutine.yield(time, not is_hour)
        end
    end
end

-- 時分のみ⇒今日、明日の日付
function GEN.hour(x, d)
    adjust_hour(x, d)
    x.year  = d.year
    x.month = d.month
    for i = 0, 1 do
        x.day = d.day + i
        local time = os.time(x)
        coroutine.yield(time)
    end
end

-- 分のみ⇒今時、次時
function GEN.min(x, d)
    adjust_hour(x, d)
    x.year  = d.year
    x.month = d.month
    x.day   = d.day
    for i = 0, 1 do
        x.hour = d.hour + i
        local time = os.time(x)
        coroutine.yield(time)
    end
end

--- エントリーの発動時刻を返す。
--- @param entry string エントリー定義
--- @param now number 現在時刻`os.time()`
--- @return number time 発動時刻
--- @return boolean has_delete 発動後に削除する必要があればtrue。
local function cal_time(entry, now)
    local function TASK()
        local d = os.date("*t", now)
        local x = cal_entry_table(entry)
        if x.year then
            return GEN.year(x, d)
        elseif x.month then
            return GEN.month(x, d)
        elseif x.day then
            return GEN.month(x, d)
        elseif x.week then
            return GEN.week(x, d)
        elseif x.hour then
            return GEN.hour(x, d)
        else
            return GEN.min(x, d)
        end
    end
    for time, has_delete in coroutine.wrap(TASK) do
        if time > now then
            return time, has_delete
        end
    end
    return nil
end

-- 全エントリの発動時刻を削除する
local function reset_cal_entry(items)
    for i, v in ipairs(items) do
        v.time = nil
    end
end

-- 全エントリの発動時刻を更新し、最優先エントリーを検索する。
local function peek_cal_entry(items, now)
    local sel_i, sel
    for i, v in ipairs(items) do
        if not v.time then
            v.time, v.has_delete = cal_time(v.cal, now)
        end
        -- 一番小さな発動時刻を選択する
        if sel and sel.time <= v.time then
            v = nil
        end
        if v then
            sel_i = i
            sel   = v
        end
    end
    return sel_i, sel
end

--- カレンダトークを再生するかどうかを判定し、結果を返す。
--- 再生する場合は必要に応じてエントリを削除する。
--- @param guard_sec number ガード秒数
--- @param items any[]      エントリ一覧
--- @param now number       現在時刻(os.time())
--- @return number flag  ０⇒対象無し　１⇒ガードタイム　２⇒発動
--- @return any    entry 発動する場合のエントリ
local function fire_cal_entry(guard_sec, items, now)
    local i, entry = peek_cal_entry(items, now)
    if not entry then return 0 end
    if entry.time > now then
        if entry.time > now + guard_sec then
            return 0, entry
        else
            return 1, entry
        end
    end
    -- 発動するので必要ならエントリを削除
    if entry.has_delete then
        table.remove(items, i)
    end
    entry.time = nil
    return 2, entry
end

-- カレンダートークのエントリー処理
local MOD = {
    get_last_monday_time = get_last_monday_time,
    adjust_hour          = adjust_hour,
    entry_table          = cal_entry_table,
    time                 = cal_time,
    reset_entry          = reset_cal_entry,
    peek_entry           = peek_cal_entry,
    fire_entry           = fire_cal_entry,
}

return MOD
