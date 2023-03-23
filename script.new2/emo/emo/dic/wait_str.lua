-- 文字ウエイト計算
local MOD = {}

local utf8 = require "emo.libs.luajit-utf8"

local function utable(table, no, s)
    for _, cp in utf8.codes(s) do
        table[cp] = no
    end
end

local SS_ESC   = 1 --- [ESC]
local SS_UB    = 2 --- _
local SS_09    = 3 --- 0-9
local SS_AZ    = 4 --- a-z_
local SS_BS    = 5 --- [
local SS_BE    = 6 --- ]

local match_ss = {}
utable(match_ss, SS_ESC, "\\")
utable(match_ss, SS_UB, "_")
utable(match_ss, SS_09, "0123456789")
utable(match_ss, SS_AZ, "abcdefghijklmnopqrstuvwxyz!")
utable(match_ss, SS_BS, "[")
utable(match_ss, SS_BE, "]")

local NORMAL_CHAR = 1
local SS_FUNC = 2

function MOD.en_char_ss(text)
    local function MATCH(cp)
        return match_ss[cp]
    end

    local function CO1()
        local gen = utf8.codes(text)

        -- ############################
        ::LOOP_NORMAL::
        local i, cp = gen()
        if not i then return end
        local a = MATCH(cp)
        if a ~= SS_ESC then
            coroutine.yield(cp, NORMAL_CHAR)
            goto LOOP_NORMAL
        end
        coroutine.yield(cp, SS_FUNC)

        -- ############################
        ::LOOP_SS2::
        i, cp = gen()
        if not i then return end
        a = MATCH(cp)
        if a == SS_ESC then
            coroutine.yield(cp, NORMAL_CHAR)
            goto LOOP_NORMAL
        elseif a == SS_UB then
            coroutine.yield(cp, SS_FUNC)
            goto LOOP_SS2
        elseif a == SS_09 then
            coroutine.yield(cp, SS_FUNC)
            goto LOOP_NORMAL
        elseif a ~= SS_AZ then
            coroutine.yield(cp, NORMAL_CHAR)
            goto LOOP_NORMAL
        end
        coroutine.yield(cp, SS_FUNC)

        -- ############################
        ::LOOP_SS3::
        i, cp = gen()
        if not i then return end
        a = MATCH(cp)
        if a == SS_09 then
            coroutine.yield(cp, SS_FUNC)
            goto LOOP_NORMAL
        elseif a == SS_ESC then
            coroutine.yield(cp, SS_FUNC)
            goto LOOP_SS2
        elseif a ~= SS_BS then
            coroutine.yield(cp, NORMAL_CHAR)
            goto LOOP_NORMAL
        end
        coroutine.yield(cp, SS_FUNC)

        -- ############################
        ::LOOP_SS4::
        i, cp = gen()
        if not i then return end
        a = MATCH(cp)
        if a ~= SS_BE then
            coroutine.yield(cp, SS_FUNC)
            goto LOOP_SS4
        end
        coroutine.yield(cp, SS_FUNC)
        goto LOOP_NORMAL
    end

    return coroutine.wrap(CO1)
end

local WAIT1 = -1 -- 通常wait、直前の残waitを確定
local WAIT2 = 02 -- 半濁点
local WAIT3 = 03 -- エクステンション
local WAIT4 = 04 -- 濁点
local WAIT5 = -5 -- 点々、直前の残waitを確定
local SKIP = -6  -- 無視
local ESCAPE = 7 -- エスケープ

local match_wait_table = {}
utable(match_wait_table, WAIT2, [=[、，）］｝」』､,)]}｣]=])
utable(match_wait_table, WAIT3, [=[？！?!]=])
utable(match_wait_table, WAIT4, [=[。．｡.]=])
utable(match_wait_table, WAIT5, [=[・‥…･/]=])
utable(match_wait_table, SKIP, "\r\n\t")
utable(match_wait_table, ESCAPE, "\\")

--- 文字列を(c, wait_ms)で列挙する。
--- @param wait number[] ウェイト設定配列
--- @param text string トーク
function MOD.en_char_wait(wait, text)
    -- 今日はいい天気、！？です、ね～。あと‥‥、明日はどうかな。
    --  1 1 1 1 1 1 1 1 1 3 1 1 2 1 1 4 1 1 5 5 2 1 1 1 1 1 1 1 4
    local function CHAR(cp)
        if cp == nil then return "nil" end
        return utf8.char(cp)
    end

    local function CO1()
        for cp, tp in MOD.en_char_ss(text) do
            if tp == NORMAL_CHAR then
                local a = match_wait_table[cp]
                if not a then a = WAIT1 end
                coroutine.yield(cp, a)
            else
                coroutine.yield(cp, SKIP)
            end
        end
    end

    local function CO2()
        local remain = 0 -- 確定前のwait値
        for c, i in coroutine.wrap(CO1) do
            local pre, suf = 0, 0
            if i < 0 then
                pre = remain
                remain = 0
                suf = -i
            elseif i ~= SKIP then
                if remain < i then remain = i end
                suf = -WAIT1
            end
            coroutine.yield(pre, c, suf)
        end
        coroutine.yield(remain, nil, 0)
    end

    -- ms値へ変換
    local function MS(i)
        local ms = wait[i]
        if not ms then ms = 0 end
        return ms
    end

    local function CO3()
        for pre, c, suf in coroutine.wrap(CO2) do
            local pre_ms = MS(pre)
            local suf_ms = MS(suf)
            --print(string.format("  %03d (%s) %03d", pre_ms, CHAR(c), suf_ms))
            coroutine.yield(pre_ms, c, suf_ms)
        end
    end

    -- (c,ms)で列挙
    local function CO4()
        local remain_ms = 0
        local last_c = nil
        for pre_ms, c, suf_ms in coroutine.wrap(CO3) do
            remain_ms = remain_ms + pre_ms
            if last_c ~= nil then
                coroutine.yield(last_c, remain_ms)
                remain_ms = 0
            end
            if c == nil then return end
            last_c = c
            remain_ms = suf_ms
        end
    end

    return coroutine.wrap(CO4)
end

return MOD
