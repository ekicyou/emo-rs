-- 文字ウエイト計算
local MOD = {}

local function utable(table, no, s)
    for _, c in utf8.codes(s) do
        table[c] = no
    end
end

local WAIT1 = -1 -- 通常wait、直前の残waitを確定
local WAIT2 = 02 -- 半濁点
local WAIT3 = 03 -- エクステンション
local WAIT4 = 04 -- 濁点
local WAIT5 = -5 -- 点々、直前の残waitを確定
local SKIP = 06  -- 無視
local match_wait_table = {}

utable(match_wait_table, WAIT2, [=[。．｡.]=])
utable(match_wait_table, WAIT3, [=[？！?!]=])
utable(match_wait_table, WAIT4, [=[、，）］｝」』､,)]}｣]=])
utable(match_wait_table, WAIT5, [=[・‥…･]=])
utable(match_wait_table, SKIP, "\r\n\t")

--- 文字列を(c, wait_ms)で列挙する。
function MOD.en_char_wait(wait, text)
    -- 今日はいい天気、！？です、ね～。あと‥‥、明日はどうかな。
    --  1 1 1 1 1 1 1 1 1 3 1 1 2 1 1 4 1 1 5 5 2 1 1 1 1 1 1 1 4
    local function CO1()
        for _, c in utf8.codes(text) do
            local i = match_wait_table[c]
            if not i then i = WAIT1 end
            coroutine.yield(c, i)
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
                suf = WAIT1
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
