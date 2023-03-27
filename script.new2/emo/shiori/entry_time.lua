local RE_CAL_DY = "D([%d%-][%d%-])([%d%-][%d%-])([%d%-][%d%-])"
local RE_CAL_DM = "D([%d%-][%d%-])([%d%-][%d%-])"
local RE_CAL_W = "W(%d+)"
local RE_CAL_T = "T([%d%-][%d%-])([%d%-][%d%-])"
local RE_NUM = "^(%d+)$"


--- osdate `os.date('*t',time) を返す。
--- @param time integer os.time()値
--- @return osdate date `os.date('*t',time)値
local function osdate(time)
    return os.date("*t", time)
end


--- エントリをテーブル分解。
--- @param entry string 日時エントリー定義文字列。`Dyymmdd` 年月日、`Dmmdd`月日、`Wn`週（日曜日=1始まり）、`Thhmm`日時
--- @return osdate dt 日時テーブル`os.date("*t", time)`フォーマット
local function date_table(entry)
    local function NUM(t)
        local _, _, m = string.find(t, RE_NUM)
        if m then
            return m + 0
        else
            return nil
        end
    end

    local x = {}
    local s, _, year, month, day = string.find(entry, RE_CAL_DY)
    if s then
        x.year  = NUM(year)
        x.month = NUM(month)
        x.day   = NUM(day)
        if x.year then
            x.year = x.year + 2000
        end
    else
        local s, _, month, day = string.find(entry, RE_CAL_DM)
        if s then
            x.month = NUM(month)
            x.day   = NUM(day)
        end
    end
    local s, _, a = string.find(entry, RE_CAL_W)
    if s then
        x.wday = NUM(a)
    end
    local s, _, hour, min = string.find(entry, RE_CAL_T)
    if s then
        x.hour = NUM(hour)
        x.min  = NUM(min)
    end
    return x
end


--- エントリテーブルを作成する。
--- @param entry string 日時エントリー定義文字列。`Dyymmdd` 年月日、`Dmmdd`月日、`Wn`週（日曜日=1始まり）、`Thhmm`日時
--- @return table dt エントリテーブル
local function entry_table(entry)
    local priority_wait = 0
    local c1 = string.sub(entry, 1, 1)
    if c1 == 'D' then
        priority_wait = 0.5
    elseif c1 == 'W' then
        priority_wait = 3.3
    end
    local t = {
        date = date_table(entry),
        priority = #entry + priority_wait,
        rand = math.random() * 0.1,
    }
    return t
end


--- 与えられた時刻に対するエントリマッチ度を返す。
--- @param entry table エントリテーブル
--- @param now osdate 比較する時刻テーブル
--- @return number|nil priority マッチした場合、priority値。マッチしなければnil
local function entry_match(entry, now)
    for k, v in pairs(entry.date) do
        if now[k] ~= v then
            return nil
        end
    end
    return entry.priority + entry.rand
end


--- 指定日時をベースに直近の月曜日午前０時を返す。
--- @param target table 基準日時
--- @return number monday_time 直前の月曜日午前０時
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
    local zero_date = osdate(zero_time)
    local wday = zero_date.wday

    -- 直近のwday=2になるように日付をマイナス
    local day = wday - 2
    if day < 0 then day = day + 7 end
    local monday_time = zero_time - day * 60 * 60 * 24
    return monday_time
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
--- @return 0|1|2 flag  ０⇒対象無し　１⇒ガードタイム　２⇒発動
--- @return table|nil entry 発動する場合のエントリ
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
    osdate               = osdate,
    date_table           = date_table,
    entry_table          = entry_table,
    entry_match          = entry_match,
    get_last_monday_time = get_last_monday_time,
    reset_entry          = reset_cal_entry,
    peek_entry           = peek_cal_entry,
    fire_entry           = fire_cal_entry,
}

return MOD
