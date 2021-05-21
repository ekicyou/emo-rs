local utf8 = require "utf8"
local esc = utf8.escape
local MODULE = {}

local chars_tp = [=[。．｡.]=]
local chars_ins = [=[？！?!]=]
local chars_semi = [=[、，）］｝」』､,)]}｣]=]
local chars_think = [=[・‥…･]=]

local chars_wait1 = chars_tp .. chars_ins .. chars_semi
local chars_wait2 = chars_think

local re_tp    = '[' .. esc(chars_tp) ..']+'

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

function MODULE.wait1(text, w1, w2)
    -- 濁点が含まれればw1、含まれなければw2
    local function CALC(s)
        local index = utf8.match(s,re_tp)
        if not (index) then
            return w2
        end
        return w1
    end
    -- ウエイト値をスクリプトに挿入
    local function REP(s)
        local wait = CALC(s)
        return s .. WAIT(wait)
    end
    return utf8.gsub(text, re_wait1, REP)
end

function MODULE.wait2(text, wait)
    local function REP(s)
        return s .. WAIT(wait)
    end
    return utf8.gsub(text, re_wait2, REP)
end

function MODULE.wait(text, w1, w2, w3)
    local s = MODULE.wait1(text,w1,w2)
    return MODULE.wait2(s,w3)
end

return MODULE