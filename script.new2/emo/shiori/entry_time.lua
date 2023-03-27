-- カレンダートークのエントリー処理
local MOD = {}

--- osdate `os.date('*t',time) を返す。
--- @param time integer os.time()値
--- @return osdate date `os.date('*t',time)値
function MOD.osdate(time)
    return os.date("*t", time)
end

local RE_CAL_DY = "D([%d%-][%d%-])([%d%-][%d%-])([%d%-][%d%-])"
local RE_CAL_DM = "D([%d%-][%d%-])([%d%-][%d%-])"
local RE_CAL_W = "W(%d+)"
local RE_CAL_T = "T([%d%-][%d%-])([%d%-][%d%-])"
local RE_CAL_M = "M([%d%-][%d%-])"
local RE_NUM = "^(%d+)$"

--- エントリをテーブル分解。
--- @param entry string 日時エントリー定義文字列。`Dyymmdd` 年月日、`Dmmdd`月日、`Wn`週（日曜日=1始まり）、`Thhmm`日時
--- @return osdate dt 日時テーブル`os.date("*t", time)`フォーマット
function MOD.date_table(entry)
    local function NUM(t)
        local _, _, m = string.find(t, RE_NUM)
        if m then
            return m + 0
        else
            return nil
        end
    end

    local x = {}
    do
        local s, _, year, month, day = string.find(entry, RE_CAL_DY)
        if s then
            x.year  = NUM(year)
            x.month = NUM(month)
            x.day   = NUM(day)
            if x.year then
                x.year = x.year + 2000
            end
        else
            s, _, month, day = string.find(entry, RE_CAL_DM)
            if s then
                x.month = NUM(month)
                x.day   = NUM(day)
            end
        end
    end
    do
        local s, _, a = string.find(entry, RE_CAL_W)
        if s then
            x.wday = NUM(a)
        end
    end
    do
        local s, _, hour, min = string.find(entry, RE_CAL_T)
        if s then
            x.hour = NUM(hour)
            x.min  = NUM(min)
        end
    end
    do
        local s, _, min = string.find(entry, RE_CAL_M)
        if s then
            x.min = NUM(min)
        end
    end
    return x
end

--- エントリテーブルを作成する。
--- @param entry string 日時エントリー定義文字列。`Dyymmdd` 年月日、`Dmmdd`月日、`Wn`週（日曜日=1始まり）、`Thhmm`日時
--- @return table dt エントリテーブル
function MOD.create_entry(entry)
    local priority_wait = 0
    local c1 = string.sub(entry, 1, 1)
    if c1 == 'D' then
        priority_wait = 0.5
    elseif c1 == 'W' then
        priority_wait = 3.3
    end
    local t = {
        date = MOD.date_table(entry),
        priority = #entry + priority_wait,
        rand = math.random() * 0.1,
    }
    return t
end

--- 指定日時をベースに直近の月曜日午前０時を返す。
--- @param target osdate 基準日時
--- @return number monday_time 直前の月曜日午前０時
function MOD.get_last_monday_time(target)
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
    local zero_date = MOD.osdate(zero_time)
    local wday = zero_date.wday

    -- 直近のwday=2になるように日付をマイナス
    local day = wday - 2
    if day < 0 then day = day + 7 end
    local monday_time = zero_time - day * 60 * 60 * 24
    return monday_time
end

local TIME_1MIN  = 60
local TIME_1HOUR = TIME_1MIN * 60
local TIME_1DAY  = TIME_1HOUR * 24
local TIME_1WEEK = TIME_1DAY * 7

--- 日時エントリー定義と現在時刻より、直近の発動時刻を返す。
--- @param entry osdate エントリー定義
--- @param now_time integer 参照時刻
--- @param now osdate 参照時刻
--- @return integer|nil s_time 発動開始時刻
--- @return integer|nil e_time 発動終了時刻（同じ値は含まない）
function MOD.calc_fire_time(entry, now_time, now)
    local year = entry.year
    local month = entry.month
    local day = entry.day
    local wday = entry.wday
    local hour = entry.hour
    local min = entry.min

    local function TIME_DUE()
        if min then
            return TIME_1MIN
        elseif hour then
            return TIME_1HOUR
        end
        return TIME_1DAY
    end
    local due = TIME_DUE()

    if hour == nil then
        hour = 0
        min = 0
    elseif min == nil then
        min = 0
    end

    local function S_YEAR()
        local t = {
            year  = year,
            month = month,
            day   = day,
            hour  = hour,
            min   = min,
        }
        return os.time(t)
    end

    -- 年指定
    if year then
        local s_time = S_YEAR()
        local e_time = s_time + due
        local s = MOD.osdate(s_time)
        local e = MOD.osdate(e_time)
        if e_time > now_time then
            return s_time, e_time
        else
            return nil
        end
    end

    -- 月指定
    if month then
        local s = {
            year  = now.year,
            month = month,
            day   = day,
            hour  = hour,
            min   = min,
        }
        local s_time = os.time(s)
        local e_time = s_time + due
        if e_time > now_time then
            -- e_timeが未来日時ならそのまま
            return s_time, e_time
        end
        -- e_timeが過去日時だったので１年進める
        s.year = s.year + 1
        s_time = os.time(s)
        e_time = s_time + due
        return s_time, e_time
    end

    -- 週指定
    local function WEEK_SKIP()
        local rc = wday - 2
        if rc < 0 then
            rc = rc + 7
        end
        return rc
    end

    local function HOUR_TIME()
        if not hour then return 0 end
        return TIME_1HOUR * hour + TIME_1MIN * min
    end

    -- 最初に一致する現在または未来の週日時
    if wday then
        local function FOREACH()
            local monday_time = MOD.get_last_monday_time(now) + HOUR_TIME()
            local skip_time = TIME_1DAY * WEEK_SKIP()
            local time = monday_time + skip_time
            return function()
                local s_time = time
                local e_time = s_time + due
                time = time + TIME_1WEEK
                return s_time, e_time
            end
        end
        for s_time, e_time in FOREACH() do
            if e_time > now_time then
                return s_time, e_time
            end
        end
    end

    -- 時刻の一致
    if hour then
        local function FOREACH()
            local s = {
                year  = now.year,
                month = now.month,
                day   = now.day,
                hour  = hour,
                min   = min,
            }
            local time = os.time(s)
            return function()
                local s_time = time
                local e_time = s_time + due
                time = time + TIME_1DAY
                return s_time, e_time
            end
        end
        for s_time, e_time in FOREACH() do
            if e_time > now_time then
                return s_time, e_time
            end
        end
    end

    -- 分の一致
    do
        local function FOREACH()
            local s = {
                year  = now.year,
                month = now.month,
                day   = now.day,
                hour  = now.hour,
                min   = min,
            }
            local time = os.time(s)
            return function()
                local s_time = time
                local e_time = s_time + due
                time = time + TIME_1HOUR
                return s_time, e_time
            end
        end
        for s_time, e_time in FOREACH() do
            if e_time > now_time then
                return s_time, e_time
            end
        end
    end
end

--- 与えられた時刻に対するエントリマッチ度を返す。
--- @param entry table エントリテーブル
--- @param now osdate 比較する時刻テーブル
--- @return number|nil priority マッチした場合、priority値。マッチしなければnil
function MOD.entry_match(entry, now)
    for k, v in pairs(entry.date) do
        if now[k] ~= v then
            return nil
        end
    end
    return entry.priority + entry.rand
end

-- 全エントリの発動時刻を削除する
function MOD.reset_entry(items)
    for i, v in ipairs(items) do
        v.time_entry = nil
    end
end

-- 全エントリの発動時刻を更新し、最優先エントリーを検索する。
function MOD.peek_entry(items, now)
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
--- @return 0|1|2 flag  ０⇒対象無し　１⇒ガードタイム　２⇒発動
--- @return table|nil entry 発動する場合のエントリ
function MOD.fire_entry(guard_sec, items, now)
    local i, entry = MOD.peek_entry(items, now)
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

return MOD
