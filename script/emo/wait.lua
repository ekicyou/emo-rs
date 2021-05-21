local utf8 = require "utf8"
local esc = utf8.escape

local chars_tp = [=[。．｡.]=]
local chars_ins = [=[？！?!]=]
local chars_semi = [=[、，）］｝」』､,)]}｣]=]
local chars_think = [=[・‥…･]=]

local chars_wait1 = chars_tp .. chars_ins .. chars_semi
local chars_wait2 = chars_think

local re_tp    = '[' .. esc(chars_tp) ..']+'
local re_ins    = '[' .. esc(chars_ins) ..']+'

local re_wait1 = '[' .. esc(chars_wait1) ..']+'
local re_wait2 = '[' .. esc(chars_wait2) ..']'
local re_wait = '[' .. esc(chars_wait2) ..']'


local function WAIT(ms)
    if ms > 0 then
        local rc = [=[\_w[]=] .. ms .. [=[]]=]
        return rc
    end
    return ""
end

local function wait1(text, w1, w2, w3)
    -- 濁点が含まれればw1、！など含まれればw2、含まれなければw3
    local function CALC(s)
        local tp = utf8.match(s,re_tp)
        if tp then
            return w1
        end
        local ins = utf8.match(s,re_ins)
        if ins then
            return w2
        end
        return w3
    end
    -- ウエイト値をスクリプトに挿入
    local function REP(s)
        local wait = CALC(s)
        return s .. WAIT(wait)
    end
    return utf8.gsub(text, re_wait1, REP)
end

local function wait2(text, wait)
    local function REP(s)
        return s .. WAIT(wait)
    end
    return utf8.gsub(text, re_wait2, REP)
end

-- スクリプトにウエイトを入れる。w1:濁点、w2:感嘆詞、w3:半濁点、w4:思考文字
local function wait(text, w1, w2, w3, w4)
    local s = wait1(text,w1,w2, w3)
    return wait2(s,w4)
end

local MOD = {
    wait1 = wait1,
    wait2 = wait2,
    wait  = wait,
}

return MOD