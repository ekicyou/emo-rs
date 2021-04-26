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
local re_wait2 = '[' .. esc(chars_wait2) ..']+'


local function WAIT(ms)
    if ms > 0 then
        local rc = [=[\_w[]=] .. ms .. [=[]]=]
        return rc
    end
    return ""
end

function MODULE.wait1(s, w1, w2)
    local function CALC(s)
        local index = utf8.match(s,re_tp)
        if not (index) then
            return w2
        end
        return w1
    end
    local function REP(s)
        local wait = CALC(s)
        return s .. WAIT(wait)
    end
    return utf8.gsub(s, re_wait1, REP)
end



return MODULE